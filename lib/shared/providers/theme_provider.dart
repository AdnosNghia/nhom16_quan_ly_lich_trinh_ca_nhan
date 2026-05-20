import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  int _colorSeed = 0xFF4D41DF;
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

  void _invalidateCache() {
    _cachedLight = null;
    _cachedDark = null;
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
  }

  void setColorSeed(int colorHex) {
    _colorSeed = colorHex;
    _invalidateCache();
    notifyListeners();
  }
}
