import 'package:flutter/material.dart';

/// Centralized Radius tokens for modern, restrained, and consistent corners.
class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double pill = 999.0;

  // BorderRadius objects
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusPill = BorderRadius.all(Radius.circular(pill));

  // RoundedRectangleBorders
  static const RoundedRectangleBorder shapeSm =
      RoundedRectangleBorder(borderRadius: radiusSm);
  static const RoundedRectangleBorder shapeMd =
      RoundedRectangleBorder(borderRadius: radiusMd);
  static const RoundedRectangleBorder shapeLg =
      RoundedRectangleBorder(borderRadius: radiusLg);
  static const RoundedRectangleBorder shapeXl =
      RoundedRectangleBorder(borderRadius: radiusXl);
  static const RoundedRectangleBorder shapePill =
      RoundedRectangleBorder(borderRadius: radiusPill);
}
