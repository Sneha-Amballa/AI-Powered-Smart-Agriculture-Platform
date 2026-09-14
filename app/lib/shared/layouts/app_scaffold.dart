import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import 'app_app_bar.dart';

/// Clean general-purpose scaffold with consistent theme background and safe area.
class AppScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final bool showAppBar;
  final bool showBackButton;
  final bool showLogo;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;

  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.showAppBar = true,
    this.showBackButton = true,
    this.showLogo = false,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.actions,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      appBar: showAppBar
          ? AppAppBar(
              title: title,
              showBackButton: showBackButton,
              showLogo: showLogo,
              actions: actions,
              onBackPressed: onBackPressed,
            )
          : null,
      body: SafeArea(child: body),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
