import 'package:flutter/material.dart';

class ResponsiveHelper {
  ResponsiveHelper._();

  static const double _referenceWidth = 375;
  static const double _referenceHeight = 812;

  static double scaleWidth(BuildContext context, double size) {
    return size * (MediaQuery.of(context).size.width / _referenceWidth);
  }

  static double scaleHeight(BuildContext context, double size) {
    return size * (MediaQuery.of(context).size.height / _referenceHeight);
  }

  static double scaleFont(BuildContext context, double size) {
    final scale = MediaQuery.of(context).size.width / _referenceWidth;
    return size * scale.clamp(0.8, 1.3);
  }

  static double padding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 32;
    if (width > 400) return 24;
    return 16;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600;
  }

  static bool isLarge(BuildContext context) {
    return MediaQuery.of(context).size.width >= 400;
  }

  static double iconSize(BuildContext context, double base) {
    return scaleWidth(context, base).clamp(base * 0.8, base * 1.5);
  }
}
