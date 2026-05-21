import 'package:flutter/material.dart';

/// Extension on BuildContext to provide theme-aware colors.
/// Use `context.colors` instead of `AppColors` to get dynamic colors
/// that automatically adapt to light/dark mode and color seed changes.
extension ThemeColors on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
