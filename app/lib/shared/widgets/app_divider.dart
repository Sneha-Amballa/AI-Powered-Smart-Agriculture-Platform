import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

/// Clean subtle divider for content separation.
class AppDivider extends StatelessWidget {
  final double height;
  final Color? color;
  final double indent;
  final double endIndent;

  const AppDivider({
    super.key,
    this.height = 16.0,
    this.color,
    this.indent = 0.0,
    this.endIndent = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: 1,
      color: color ?? AppColors.divider,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
