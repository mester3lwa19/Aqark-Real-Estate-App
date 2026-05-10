import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../auth/data/data.dart';
import '../../../core/database/database_helper.dart';
import '../../../core/network/network_info.dart';
import '../models/models.dart';

class PropertyRepository {
  final AuthRepository _authRepository;
  final FirebaseDatabase _database;
  final DatabaseHelper _dbHelper;
  final NetworkInfo _networkInfo;

  PropertyRepository({
    required AuthRepository authRepository,
    required FirebaseDatabase database,
    required DatabaseHelper dbHelper,
    required NetworkInfo networkInfo,
  })  : _authRepository = authRepository,
        _database = database,
        _dbHelper = dbHelper,
        _networkInfo = networkInfo;

  DatabaseReference get _favoritesRef {
    final uid = _authRepository.currentUserId;
    if (uid == null) throw Exception("User not logged in");
    return _database.ref("users/$uid/favorites");
  }

  DatabaseReference get _propertiesRef => _database.ref("properties");

  Future<void> toggleFavorite(Property property) async {
    final uid = _authRepository.currentUserId;
    if (uid == null) return;

    final isFav = await _dbHelper.isFavorite(property.id, uid);

    if (isFav) {
      // 1. Update local state to 'pending_remove' for instant UI feedback
      final propertyMap = property.toMap();
      propertyMap['userid'] = uid;
      propertyMap['syncStatus'] = 'pending_remove';
      await _dbHelper.saveFavorite(propertyMap);

      if (await _networkInfo.isConnected) {
        try {
          await _favoritesRef.child(property.id).remove();
          await _dbHelper.removeFavorite(property.id, uid);
        } catch (e) {
          debugPrint("Error removing favorite from cloud: $e");
          // Action is already in local DB as 'pending_remove'
        }
      } else {
        // Queue for background sync
        await _dbHelper.addToSyncQueue('toggle_favorite', {
          'id': property.id,
          'action': 'remove',
          'userid': uid,
        });
      }
    } else {
      // 1. Update local state to 'pending_add'
      final propertyMap = property.toMap();
      propertyMap['userid'] = uid;
      propertyMap['syncStatus'] = 'pending_add';
      await _dbHelper.saveFavorite(propertyMap);

      if (await _networkInfo.isConnected) {
        try {
          await _favoritesRef.child(property.id).set(propertyMap);
          propertyMap['syncStatus'] = 'synced';
          await _dbHelper.saveFavorite(propertyMap);
        } catch (e) {
          debugPrint("Error adding favorite to cloud: $e");
          // Action is already in local DB as 'pending_add'
        }
      } else {
        // Queue for background sync
        await _dbHelper.addToSyncQueue('toggle_favorite', {
          'id': property.id,
          'action': 'add',
          'property': propertyMap,
          'userid': uid,
        });
      }
    }
  }

  Future<void> syncFavoriteAction(Map<String, dynamic> payload) async {
    final String action = payload['action'];
    final String id = payload['id'];
    final String uid = payload['userid'];
    
    final ref = _database.ref("users/$uid/favorites");
    if (action == 'add') {
      final propertyMap = Map<String, dynamic>.from(payload['property']);
      await ref.child(id).set(propertyMap);
      
      propertyMap['syncStatus'] = 'synced';
      propertyMap['userid'] = uid;
      await _dbHelper.saveFavorite(propertyMap);
    } else {
      await ref.child(id).remove();
      await _dbHelper.removeFavorite(id, uid);
    }
  }

  Future<List<Property>> getFavorites() async {
    final uid = _authRepository.currentUserId;
    if (uid == null) return [];

    // Instant local load - includes pending_add, excludes pending_remove
    final localData = await _dbHelper.getFavorites(uid);
    final localFavorites = localData
        .where((e) => e['syncStatus'] != 'pending_remove')
        .map((e) => Property.fromMap(e))
        .toList();

    return localFavorites;
  }

  Future<void> _refreshFavorites(String uid) async {
    try {
      if (!(await _networkInfo.isConnected)) return;

      // 1. Push any local pending changes first to avoid overwriting them
      final pendingFavorites = await _dbHelper.getPendingSyncFavorites(uid);
      for (var fav in pendingFavorites) {
        if (fav['syncStatus'] == 'pending_add') {
          await _favoritesRef.child(fav['id']).set(fav);
          await _dbHelper.saveFavorite({...fav, 'syncStatus': 'synced'});
        } else if (fav['syncStatus'] == 'pending_remove') {
          await _favoritesRef.child(fav['id']).remove();
          await _dbHelper.removeFavorite(fav['id'], uid);
        }
      }

      // 2. Pull remote favorites
      final snapshot = await _favoritesRef.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        final List<Map<String, dynamic>> remoteList = [];
        final List<String> remoteIds = [];
        
        data.forEach((key, value) {
          final map = Map<String, dynamic>.from(value);
          remoteList.add(map);
          remoteIds.add(map['id']);
        });

        // 3. Update local DB - sync remote to local
        await _dbHelper.syncFavoritesToLocal(remoteList, uid);
        
        // 4. Remove local 'synced' favorites that are no longer in remote
        await _dbHelper.clearSyncedFavorites(uid, remoteIds);
      } else {
        // Remote is empty, clear local synced favorites
        await _dbHelper.clearSyncedFavorites(uid, []);
      }
    } catch (e) {
      debugPrint("Error refreshing favorites: $e");
    }
  }

  Future<void> syncFavorites() async {
    final uid = _authRepository.currentUserId;
    if (uid == null || !(await _networkInfo.isConnected)) return;
    await _refreshFavorites(uid);
  }

  Future<List<Property>> getProperties({String? query}) async {
    // 1. Load from local DB immediately
    final localData = await _dbHelper.getProperties();
    List<Property> properties = localData.map((e) => Property.fromMap(e)).toList();

    // If local DB is empty, use mock data as initial seed
    if (properties.isEmpty) {
      properties = _getMockProperties();
      await _dbHelper.saveProperties(properties.map((e) => e.toMap()).toList());
    }

    // 2. If online, refresh from Firebase in background
    if (await _networkInfo.isConnected) {
      refreshProperties();
    }

    if (query != null && query.isNotEmpty) {
      return properties
          .where((p) => p.title.toLowerCase().contains(query.toLowerCase()) ||
                        p.address.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    return properties;
  }

  Future<void> refreshProperties() async {
    try {
      if (!(await _networkInfo.isConnected)) return;
      
      final snapshot = await _propertiesRef.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        final List<Map<String, dynamic>> properties = [];
        data.forEach((key, value) {
          properties.add(Map<String, dynamic>.from(value));
        });
        await _dbHelper.saveProperties(properties);
      }
    } catch (e) {
      debugPrint("Error refreshing properties: $e");
    }
  }

  List<Property> _getMockProperties() {
    return [
      Property(
        id: '1',
        title: 'Modern Villa in New Cairo',
        description: 'A beautiful modern villa with 5 bedrooms and a private pool.',
        price: 12500000,
        address: 'New Cairo, Egypt',
        imageUrl: 'assets/images/properties/villa/villa_1.jpg',
        ownerId: 'owner1',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        beds: 5,
        baths: 4,
        sqm: 450,
        type: 'Villa',
      ),
      Property(
        id: '2',
        title: 'Luxury Apartment in Zayed',
        description: 'Spacious apartment with a view of the city skyline.',
        price: 4200000,
        address: 'Sheikh Zayed, Egypt',
        imageUrl: 'assets/images/properties/apartment/apartment_1.jpg',
        ownerId: 'owner2',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        beds: 3,
        baths: 2,
        sqm: 180,
        type: 'Apartment',
      ),
      Property(
        id: '3',
        title: 'Cozy Studio in Maadi',
        description: 'Perfect for young professionals, close to all amenities.',
        price: 1800000,
        address: 'Maadi, Cairo',
        imageUrl: 'assets/images/properties/studio/studio_1.jpg',
        ownerId: 'owner3',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        beds: 1,
        baths: 1,
        sqm: 65,
        type: 'Studio',
      ),
      Property(
        id: 'apt_1',
        title: 'Luxury Downtown Apartment',
        description: 'High-end apartment in the heart of downtown with premium finishes.',
        price: 350000,
        address: 'Downtown Street, City Center',
        imageUrl: 'assets/images/properties/apartment/apartment_1.jpg',
        ownerId: 'owner_apt1',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        beds: 2,
        baths: 2,
        sqm: 120,
        type: 'Apartment',
      ),
      Property(
        id: 'apt_2',
        title: 'Cozy Studio Apartment',
        description: 'Compact and efficient living space, perfect for students or singles.',
        price: 180000,
        address: 'University Ave, City Center',
        imageUrl: 'assets/images/properties/apartment/apartment_2.jpg',
        ownerId: 'owner_apt2',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        beds: 1,
        baths: 1,
        sqm: 65,
        type: 'Apartment',
      ),
      Property(
        id: 'duplex_1',
        title: 'Modern Duplex Loft',
        description: 'Industrial style duplex with double-height ceilings and large windows.',
        price: 550000,
        address: 'Arts District, East Side',
        imageUrl: 'assets/images/properties/duplex/duplex_1.jpg',
        ownerId: 'owner_dup1',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        beds: 3,
        baths: 2,
        sqm: 180,
        type: 'Duplex',
      ),
      Property(
        id: 'duplex_2',
        title: 'Family Duplex Home',
        description: 'Spacious two-story home with a private garden and modern amenities.',
        price: 620000,
        address: 'Green Valley, Suburb Area',
        imageUrl: 'assets/images/properties/duplex/duplex_2.jpg',
        ownerId: 'owner_dup2',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        beds: 4,
        baths: 3,
        sqm: 220,
        type: 'Duplex',
      ),
      Property(
        id: 'villa_1',
        title: 'Beachfront Luxury Villa',
        description: 'Stunning villa with direct beach access and panoramic ocean views.',
        price: 1200000,
        address: 'Ocean Drive, Coastline',
        imageUrl: 'assets/images/properties/villa/villa_1.jpg',
        ownerId: 'owner_villa1',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        beds: 5,
        baths: 4,
        sqm: 350,
        type: 'Villa',
      ),
      Property(
        id: 'villa_2',
        title: 'Mountain View Villa',
        description: 'Quiet retreat surrounded by nature with spectacular mountain views.',
        price: 890000,
        address: 'Pine Ridge, Hillside',
        imageUrl: 'assets/images/properties/villa/villa_2.jpg',
        ownerId: 'owner_villa2',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        beds: 4,
        baths: 4,
        sqm: 280,
        type: 'Villa',
      ),
      Property(
        id: 'town_1',
        title: 'Modern Townhouse',
        description: 'Contemporary townhouse with a rooftop terrace in a prime location.',
        price: 420000,
        address: 'Maple Street, City Center',
        imageUrl: 'assets/images/properties/townhouse/townhouse_1.jpg',
        ownerId: 'owner_town1',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        beds: 3,
        baths: 2,
        sqm: 150,
        type: 'Townhouse',
      ),
      Property(
        id: 'town_2',
        title: 'Corner Unit Townhouse',
        description: 'Extra-wide townhouse unit with lots of natural light and side yard.',
        price: 510000,
        address: 'Oak Lane, Residential Zone',
        imageUrl: 'assets/images/properties/townhouse/townhouse_2.jpg',
        ownerId: 'owner_town2',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        beds: 4,
        baths: 3,
        sqm: 195,
        type: 'Townhouse',
      ),
      Property(
        id: 'studio_1',
        title: 'Minimalist Studio',
        description: 'Clean and modern studio apartment, optimized for urban living.',
        price: 120000,
        address: 'Central Park West, Downtown',
        imageUrl: 'assets/images/properties/studio/studio_1.jpg',
        ownerId: 'owner_studio1',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        beds: 0,
        baths: 1,
        sqm: 45,
        type: 'Studio',
      ),
      Property(
        id: 'studio_2',
        title: 'Art District Studio',
        description: 'Vibrant studio located in the heart of the arts and culture district.',
        price: 135000,
        address: 'Gallery Row, Creative Zone',
        imageUrl: 'assets/images/properties/studio/studio_2.jpg',
        ownerId: 'owner_studio2',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        beds: 0,
        baths: 1,
        sqm: 50,
        type: 'Studio',
      ),
      Property(
        id: 'pent_1',
        title: 'Skyline Penthouse',
        description: 'Top-floor penthouse with a private terrace and city-wide views.',
        price: 950000,
        address: 'Sky Tower, City Center',
        imageUrl: 'assets/images/properties/penthouse/penthouse_1.jpg',
        ownerId: 'owner_pent1',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        beds: 3,
        baths: 3,
        sqm: 250,
        type: 'Penthouse',
      ),
      Property(
        id: 'pent_2',
        title: 'Luxury Penthouse Suite',
        description: 'The ultimate in luxury, featuring ultra-premium amenities and water views.',
        price: 1400000,
        address: 'Marina Bay, Waterfront',
        imageUrl: 'assets/images/properties/penthouse/penthouse_2.jpg',
        ownerId: 'owner_pent2',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        beds: 4,
        baths: 3,
        sqm: 310,
        type: 'Penthouse',
      ),
    ];
  }
}
