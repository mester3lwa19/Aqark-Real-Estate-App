import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../features/auth/data/data.dart';
import '../../features/properties/data/data.dart';
import '../database/database_helper.dart';
import 'network_info.dart';

class SyncService {
  final AuthRepository authRepository;
  final PropertyRepository propertyRepository;
  final NetworkInfo networkInfo;
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  StreamSubscription? _subscription;
  bool _isSyncing = false;

  SyncService({
    required this.authRepository,
    required this.propertyRepository,
    required this.networkInfo,
  });

  void start() {
    _subscription = networkInfo.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (!results.contains(ConnectivityResult.none)) {
        // We are back online!
        _performSync();
      }
    });
    
    // Also try an initial sync if already online
    _performSync();
  }

  Future<void> _performSync() async {
    if (_isSyncing) return;
    
    final bool connected = await networkInfo.isConnected;
    if (!connected) return;

    _isSyncing = true;
    debugPrint("Starting background sync...");

    try {
      // 1. Process Sync Queue (Local -> Remote)
      await _processSyncQueue();

      // 2. Sync Auth/User Data
      await authRepository.syncOfflineData();

      // 3. Sync Favorites (Bidirectional)
      await propertyRepository.syncFavorites();
      
      // 4. Update local properties from remote
      await propertyRepository.refreshProperties();

      debugPrint("Background sync completed successfully.");
    } catch (e) {
      debugPrint("Error during background sync: $e");
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _processSyncQueue() async {
    final queue = await dbHelper.getSyncQueue();
    if (queue.isEmpty) return;

    debugPrint("Processing ${queue.length} items from sync queue...");

    for (var item in queue) {
      final int id = item['id'];
      final String action = item['action'];
      final Map<String, dynamic> payload = jsonDecode(item['payload']);

      try {
        switch (action) {
          case 'toggle_favorite':
            // Logic to sync favorite to Firebase
            await propertyRepository.syncFavoriteAction(payload);
            break;
          // Add other actions like 'add_property', 'update_profile' etc.
        }
        await dbHelper.removeFromSyncQueue(id);
      } catch (e) {
        debugPrint("Failed to sync item $id: $e");
        // Keep in queue for next time
      }
    }
  }

  void stop() {
    _subscription?.cancel();
  }
}
