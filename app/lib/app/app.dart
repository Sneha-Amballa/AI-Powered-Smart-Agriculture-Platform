import 'package:flutter/material.dart';
import 'router.dart';
import 'theme/app_theme.dart';

/// Root application widget configured with GoRouter and the centralized Material 3 theme.
class SmartAgriApp extends StatelessWidget {
  const SmartAgriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'KisanAI - Smart Agriculture',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
