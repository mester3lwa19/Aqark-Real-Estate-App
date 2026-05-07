import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/network_info.dart';
import '../network/sync_service.dart';
import '../../features/auth/data/data.dart';
import '../../features/properties/data/data.dart';
import '../database/database_helper.dart';
import '../settings/settings_repository.dart';

Future<void> setupServiceLocator() async {
  final locator = GetIt.instance;

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);
  locator.registerLazySingleton(() => Connectivity());
  locator.registerLazySingleton(() => FirebaseAuth.instance);
  locator.registerLazySingleton(() => FirebaseDatabase.instance);

  // Core
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));
  locator.registerLazySingleton(() => DatabaseHelper.instance);
  locator.registerLazySingleton(() => SettingsRepository(locator()));

  // Repository
  locator.registerLazySingleton(() => AuthRepository(
        auth: locator(),
        database: locator(),
        dbHelper: locator(),
        networkInfo: locator(),
      ));
  locator.registerLazySingleton(() => PropertyRepository(
        auth: locator(),
        database: locator(),
        dbHelper: locator(),
        networkInfo: locator(),
      ));

  // Services
  locator.registerLazySingleton(() => SyncService(
        authRepository: locator(),
        propertyRepository: locator(),
        networkInfo: locator(),
      ));
}
