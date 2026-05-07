import '../database/database_helper.dart';

class SettingsRepository {
  final DatabaseHelper _dbHelper;

  SettingsRepository(this._dbHelper);

  static const String keyDarkMode = 'dark_mode';
  static const String keyLanguage = 'language';
  static const String keyNotifications = 'notifications_enabled';

  Future<void> setDarkMode(bool enabled) async {
    await _dbHelper.saveSetting(keyDarkMode, enabled.toString());
  }

  Future<bool> isDarkMode() async {
    final value = await _dbHelper.getSetting(keyDarkMode);
    return value == 'true';
  }

  Future<void> setLanguage(String code) async {
    await _dbHelper.saveSetting(keyLanguage, code);
  }

  Future<String> getLanguage() async {
    return await _dbHelper.getSetting(keyLanguage) ?? 'en';
  }
}
