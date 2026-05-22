import 'package:flutter/material.dart';

class L10n {
  L10n._();

  static const supportedLocales = [
    Locale('vi'), // Tiếng Việt (mặc định)
    Locale('en'), // English
  ];

  static String getLanguageName(String code) {
    switch (code) {
      case 'vi':
        return 'Tiếng Việt';
      case 'en':
        return 'English';
      default:
        return code;
    }
  }

  static String getFlag(String code) {
    switch (code) {
      case 'vi':
        return '🇻🇳';
      case 'en':
        return '🇬🇧';
      default:
        return '🌐';
    }
  }
}
