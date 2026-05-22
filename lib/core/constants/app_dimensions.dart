import 'package:flutter/material.dart';
import '../helpers/responsive_helper.dart';

class AppDimensions {
  AppDimensions._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  static const double gutter = 16;
  static const double marginMobile = 16;

  static const double radiusXs = 4;
  static const double radiusSm = 6;
  static const double radiusMd = 8;
  static const double radiusLg = 12;
  static const double radiusXl = 16;
  static const double radiusFull = 9999;

  static double bodyPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 32;
    if (width > 400) return 24;
    return 16;
  }

  static double cardMaxWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 480;
    return width * 0.92;
  }

  static double progressCircleSize(BuildContext context) {
    return ResponsiveHelper.scaleWidth(context, 96).clamp(64, 120);
  }

  static double calendarDotSize(BuildContext context) {
    return ResponsiveHelper.scaleWidth(context, 5).clamp(3, 7);
  }

  static double headerHeight(BuildContext context) {
    return ResponsiveHelper.scaleWidth(context, 64).clamp(56, 72);
  }
}
