import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  static const _keyThemeMode = 'schedulr_theme_mode';
  static const _keyColorSeed = 'schedulr_color_seed';

  ThemeMode _themeMode = ThemeMode.light;
  int _colorSeed = 0xFF0099CC;
  ThemeData? _cachedLight;
  ThemeData? _cachedDark;

  ThemeMode get themeMode => _themeMode;
  int get colorSeed => _colorSeed;

  ThemeData get lightTheme {
    _cachedLight ??= AppTheme.buildTheme(Brightness.light, Color(_colorSeed));
    return _cachedLight!;
  }

  ThemeData get darkTheme {
    _cachedDark ??= AppTheme.buildTheme(Brightness.dark, Color(_colorSeed));
    return _cachedDark!;
  }

  /// Load persisted theme settings from SharedPreferences.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final modeIndex = prefs.getInt(_keyThemeMode);
    if (modeIndex != null && modeIndex >= 0 && modeIndex < ThemeMode.values.length) {
      _themeMode = ThemeMode.values[modeIndex];
    }
    final savedColor = prefs.getInt(_keyColorSeed);
    if (savedColor != null) {
      // If the saved color is the old purple default, upgrade it to the new ocean blue default
      if (savedColor == 0xFF4D41DF || savedColor == 0xFF7B74FF) {
        _colorSeed = 0xFF0099CC;
        await _persist();
      } else {
        _colorSeed = savedColor;
      }
    }
    _invalidateCache();
  }

  void _invalidateCache() {
    _cachedLight = null;
    _cachedDark = null;
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyThemeMode, _themeMode.index);
    await prefs.setInt(_keyColorSeed, _colorSeed);
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    SystemChrome.setSystemUIOverlayStyle(
      mode == ThemeMode.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
    );
    _invalidateCache();
    notifyListeners();
    _persist();
  }

  void setColorSeed(int colorHex) {
    _colorSeed = colorHex;
    _invalidateCache();
    notifyListeners();
    _persist();
  }
}
