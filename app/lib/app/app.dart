import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/localization/locale_provider.dart';
import 'router.dart';
import 'theme/app_theme.dart';

/// Root application widget configured with GoRouter, the centralized Material 3 theme,
/// and reactive multi-lingual locale support across all Indian regional languages.
class SmartAgriApp extends ConsumerWidget {
  const SmartAgriApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLanguage = ref.watch(localeNotifierProvider);

    return MaterialApp.router(
      title: 'KisanAI - Smart Agriculture',
      debugShowCheckedModeBanner: false,
      locale: Locale(activeLanguage.code),
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
