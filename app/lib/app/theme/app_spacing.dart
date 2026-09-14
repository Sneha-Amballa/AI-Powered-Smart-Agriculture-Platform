import 'package:flutter/material.dart';

/// Centralized Spacing tokens for consistent padding, margins, and gaps.
class AppSpacing {
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 40.0;
  static const double huge = 48.0;
  static const double massive = 64.0;

  // Convenient EdgeInsets
  static const EdgeInsets edgeAllXs = EdgeInsets.all(xs);
  static const EdgeInsets edgeAllSm = EdgeInsets.all(sm);
  static const EdgeInsets edgeAllMd = EdgeInsets.all(md);
  static const EdgeInsets edgeAllLg = EdgeInsets.all(lg);
  static const EdgeInsets edgeAllXl = EdgeInsets.all(xl);
  static const EdgeInsets edgeAllXxl = EdgeInsets.all(xxl);

  static const EdgeInsets edgeScreen = EdgeInsets.symmetric(horizontal: md, vertical: lg);
  static const EdgeInsets edgeCard = EdgeInsets.all(md);
  static const EdgeInsets edgeButton = EdgeInsets.symmetric(horizontal: xl, vertical: sm);

  // Common Gap Widgets (SizedBox)
  static const SizedBox gapH2 = SizedBox(width: 2.0);
  static const SizedBox gapH4 = SizedBox(width: xxs);
  static const SizedBox gapH6 = SizedBox(width: 6.0);
  static const SizedBox gapH8 = SizedBox(width: xs);
  static const SizedBox gapH10 = SizedBox(width: 10.0);
  static const SizedBox gapH12 = SizedBox(width: sm);
  static const SizedBox gapH14 = SizedBox(width: 14.0);
  static const SizedBox gapH16 = SizedBox(width: md);
  static const SizedBox gapH20 = SizedBox(width: lg);
  static const SizedBox gapH24 = SizedBox(width: xl);
  static const SizedBox gapH32 = SizedBox(width: xxl);

  static const SizedBox gapV2 = SizedBox(height: 2.0);
  static const SizedBox gapV4 = SizedBox(height: xxs);
  static const SizedBox gapV6 = SizedBox(height: 6.0);
  static const SizedBox gapV8 = SizedBox(height: xs);
  static const SizedBox gapV10 = SizedBox(height: 10.0);
  static const SizedBox gapV12 = SizedBox(height: sm);
  static const SizedBox gapV14 = SizedBox(height: 14.0);
  static const SizedBox gapV16 = SizedBox(height: md);
  static const SizedBox gapV20 = SizedBox(height: lg);
  static const SizedBox gapV24 = SizedBox(height: xl);
  static const SizedBox gapV32 = SizedBox(height: xxl);
  static const SizedBox gapV40 = SizedBox(height: xxxl);
  static const SizedBox gapV48 = SizedBox(height: huge);
  static const SizedBox gapV64 = SizedBox(height: massive);
}
