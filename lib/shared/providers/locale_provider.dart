import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const _keyLocale = 'schedulr_locale';

  Locale _locale = const Locale('vi');
  Locale get locale => _locale;

  /// Load persisted locale from SharedPreferences.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_keyLocale) ?? 'vi';
    _locale = Locale(code);
  }

  /// Change locale and persist the choice.
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLocale, locale.languageCode);
  }
}
