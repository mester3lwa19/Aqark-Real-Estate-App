import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/database/database_helper.dart';
import '../../../core/network/network_info.dart';
import '../models/models.dart';

class PropertyRepository {
  final FirebaseAuth _auth;
  final FirebaseDatabase _database;
  final DatabaseHelper _dbHelper;
  final NetworkInfo _networkInfo;

  PropertyRepository({
    required FirebaseAuth auth,
    required FirebaseDatabase database,
    required DatabaseHelper dbHelper,
    required NetworkInfo networkInfo,
  })  : _auth = auth,
        _database = database,
        _dbHelper = dbHelper,
        _networkInfo = networkInfo;

  DatabaseReference get _favoritesRef {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");
    return _database.ref("users/$uid/favorites");
  }

  Future<void> toggleFavorite(Property property) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final favorites = await _dbHelper.getFavorites(uid);
    final isFavorite = favorites.any((element) => element['id'] == property.id);

    if (isFavorite) {
      await _dbHelper.removeFavorite(property.id);
      if (await _networkInfo.isConnected) {
        await _favoritesRef.child(property.id).remove();
      } else {
        // Queue for sync: this could be a more complex sync queue implementation
        // For now we'll rely on the full sync on reconnect
      }
    } else {
      final propertyMap = property.toMap();
      propertyMap['userId'] = uid;
      await _dbHelper.saveFavorite(propertyMap);
      if (await _networkInfo.isConnected) {
        await _favoritesRef.child(property.id).set(propertyMap);
      }
    }
  }

  Future<List<Property>> getFavorites() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];

    if (await _networkInfo.isConnected) {
      final snapshot = await _favoritesRef.get();
      if (snapshot.exists) {
        final List<Property> remoteFavorites = [];
        final data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          remoteFavorites.add(Property.fromMap(Map<String, dynamic>.from(value)));
        });
        
        // Update local database with remote favorites
        for (var property in remoteFavorites) {
          final map = property.toMap();
          map['userId'] = uid;
          await _dbHelper.saveFavorite(map);
        }
        return remoteFavorites;
      }
    }

    // Fallback to local
    final localData = await _dbHelper.getFavorites(uid);
    return localData.map((e) => Property.fromMap(e)).toList();
  }

  Future<void> syncFavorites() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || !(await _networkInfo.isConnected)) return;

    final localFavorites = await _dbHelper.getFavorites(uid);
    
    // Simple sync: push local to remote
    // In a production app, you'd want timestamp-based merging
    for (var favorite in localFavorites) {
      await _favoritesRef.child(favorite['id']).set(favorite);
    }
    
    // Also pull remote to local to ensure everything is synced
    await getFavorites();
  }

  Future<List<Property>> getProperties({String? query}) async {
    // In a real app, this would fetch from Firebase or a local cache
    // For now, let's return some mock data and filter it if query is provided
    final mockProperties = [
      Property(
        id: '1',
        title: 'Modern Villa in New Cairo',
        description: 'A beautiful modern villa with 5 bedrooms and a private pool.',
        price: 12500000,
        address: 'New Cairo, Egypt',
        imageUrl: '',
        ownerId: 'owner1',
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
      Property(
        id: '2',
        title: 'Luxury Apartment in Zayed',
        description: 'Spacious apartment with a view of the city skyline.',
        price: 4200000,
        address: 'Sheikh Zayed, Egypt',
        imageUrl: '',
        ownerId: 'owner2',
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
      Property(
        id: '3',
        title: 'Cozy Studio in Maadi',
        description: 'Perfect for young professionals, close to all amenities.',
        price: 1800000,
        address: 'Maadi, Cairo',
        imageUrl: '',
        ownerId: 'owner3',
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    ];

    if (query != null && query.isNotEmpty) {
      return mockProperties
          .where((p) => p.title.toLowerCase().contains(query.toLowerCase()) ||
                        p.address.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    return mockProperties;
  }
}
