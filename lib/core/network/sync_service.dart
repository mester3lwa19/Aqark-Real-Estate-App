import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../features/auth/data/data.dart';
import '../../features/properties/data/data.dart';
import 'network_info.dart';

class SyncService {
  final AuthRepository authRepository;
  final PropertyRepository propertyRepository;
  final NetworkInfo networkInfo;
  StreamSubscription? _subscription;

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
  }

  Future<void> _performSync() async {
    try {
      await authRepository.syncOfflineData();
      await propertyRepository.syncFavorites();
      print("Offline data sync completed successfully.");
    } catch (e) {
      print("Error during offline sync: $e");
    }
  }

  void stop() {
    _subscription?.cancel();
  }
}
