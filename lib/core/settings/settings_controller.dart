import 'package:flutter/material.dart';
import 'settings_repository.dart';

class SettingsController extends ChangeNotifier {
  final SettingsRepository _repository;

  SettingsController(this._repository);

  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  Future<void> loadSettings() async {
    final isDark = await _repository.isDarkMode();
    final langCode = await _repository.getLanguage();
    
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _locale = Locale(langCode);
    notifyListeners();
  }

  Future<void> updateThemeMode(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    await _repository.setDarkMode(isDark);
    notifyListeners();
  }

  Future<void> updateLocale(String langCode) async {
    _locale = Locale(langCode);
    await _repository.setLanguage(langCode);
    notifyListeners();
  }
}
