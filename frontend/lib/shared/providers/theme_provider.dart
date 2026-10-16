import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _key = 'theme_mode';

  /// Première ouverture : suit le thème du téléphone.
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  bool get followsSystem => _mode == ThemeMode.system;

  bool isDarkOf(BuildContext context) {
    if (_mode == ThemeMode.dark) return true;
    if (_mode == ThemeMode.light) return false;
    return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
  }

  /// Compat : vrai seulement si le mode forcé est sombre (pas système).
  bool get isDark => _mode == ThemeMode.dark;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    // Aucune préférence = première ouverture → thème système
    if (raw == null || raw.isEmpty) {
      _mode = ThemeMode.system;
    } else if (raw == 'light') {
      _mode = ThemeMode.light;
    } else if (raw == 'dark') {
      _mode = ThemeMode.dark;
    } else {
      _mode = ThemeMode.system;
    }
    notifyListeners();
  }

  Future<void> setMode(ThemeMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
      ThemeMode.dark => 'dark',
    };
    await prefs.setString(_key, value);
  }

  Future<void> setDark(bool dark) =>
      setMode(dark ? ThemeMode.dark : ThemeMode.light);

  Future<void> setSystem() => setMode(ThemeMode.system);
}
