import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../database/database_helper.dart';
import '../../features/properties/models/models.dart';

class FavoriteSyncService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  DatabaseReference? get _favoritesRef {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    return _database.ref("users/$uid/favorites");
  }

  // Sync local favorites to Firebase
  Future<void> syncToCloud() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final connectivityResults = await Connectivity().checkConnectivity();
    if (connectivityResults.isEmpty || connectivityResults.first == ConnectivityResult.none) return;

    final localFavorites = await _dbHelper.getFavorites(user.uid);
    final ref = _favoritesRef;
    if (ref == null) return;

    for (var favMap in localFavorites) {
      final propertyId = favMap['id'];
      // Remove 'userid' before uploading if you want clean cloud data, 
      // but keeping it doesn't hurt.
      await ref.child(propertyId).set({
        ...favMap,
        'timestamp': ServerValue.timestamp,
      });
    }
  }

  // Sync Firebase favorites to local
  Future<void> syncFromCloudToLocal() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final connectivityResults = await Connectivity().checkConnectivity();
    if (connectivityResults.isEmpty || connectivityResults.first == ConnectivityResult.none) return;

    try {
      final ref = _favoritesRef;
      if (ref == null) return;

      final snapshot = await ref.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        
        for (var entry in data.entries) {
          final propertyMap = Map<String, dynamic>.from(entry.value as Map);
          propertyMap['userid'] = user.uid;
          // In Realtime DB, timestamp is usually returned as int (ms)
          await _dbHelper.saveFavorite(propertyMap);
        }
      }
    } catch (e) {
      print("Error syncing from cloud: $e");
    }
  }

  Future<void> autoSync() async {
    await syncToCloud();
    await syncFromCloudToLocal();
  }
  
  Future<void> addToCloud(Property property) async {
    final ref = _favoritesRef;
    if (ref == null) return;

    await ref.child(property.id).set({
      ...property.toMap(),
      'timestamp': ServerValue.timestamp,
    });
  }

  Future<void> removeFromCloud(String propertyId) async {
    final ref = _favoritesRef;
    if (ref == null) return;

    await ref.child(propertyId).remove();
  }
}
