import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import 'app_language.dart';
import 'app_translations.dart';
import 'locale_provider.dart';

/// Commercial-grade vernacular language selection bottom sheet for KisanAI.
/// Usable across Registration, Profile, and Settings screens.
Future<AppLanguage?> showLanguageSelectorSheet(
  BuildContext context,
  WidgetRef ref,
) async {
  final currentLang = ref.read(localeNotifierProvider);

  return showModalBottomSheet<AppLanguage>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return Consumer(
        builder: (sheetContext, sheetRef, _) {
          final activeLang = sheetRef.watch(localeNotifierProvider);

          return SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(sheetContext).size.height * 0.78,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppSpacing.gapV12,
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.cardBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  AppSpacing.gapV16,

                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.sage,
                            borderRadius: AppRadius.radiusSm,
                          ),
                          child: const Icon(
                            Icons.translate_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                        AppSpacing.gapH12,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppTranslations.translate('auth_select_language', activeLang),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                AppTranslations.translate('auth_language_hint', activeLang),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.textSecondary),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.gapV12,
                  const Divider(height: 1),

                  // Language List
                  Flexible(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      shrinkWrap: true,
                      itemCount: AppLanguage.values.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 4),
                      itemBuilder: (itemCtx, index) {
                        final lang = AppLanguage.values[index];
                        final isSelected = lang == activeLang;

                        return InkWell(
                          onTap: () async {
                            await sheetRef
                                .read(localeNotifierProvider.notifier)
                                .setLanguage(lang);
                            if (ctx.mounted) {
                              Navigator.of(ctx).pop(lang);
                            }
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.check_circle, color: Colors.white, size: 20),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${AppTranslations.translate('common_language_updated', lang)} ${lang.displayName}',
                                        ),
                                      ),
                                    ],
                                  ),
                                  backgroundColor: AppColors.primary,
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                          borderRadius: AppRadius.radiusMd,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.sage : Colors.transparent,
                              borderRadius: AppRadius.radiusMd,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary.withValues(alpha: 0.4)
                                    : Colors.transparent,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Badge code
                                Container(
                                  width: 38,
                                  height: 38,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.primary : AppColors.surface,
                                    borderRadius: AppRadius.radiusSm,
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.cardBorder,
                                    ),
                                  ),
                                  child: Text(
                                    lang.badge,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: isSelected ? Colors.white : AppColors.primaryDark,
                                    ),
                                  ),
                                ),
                                AppSpacing.gapH12,

                                // Language names
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            lang.nativeName,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                              color: isSelected
                                                  ? AppColors.primaryDark
                                                  : AppColors.textPrimary,
                                            ),
                                          ),
                                          if (lang.code != 'en') ...[
                                            const SizedBox(width: 6),
                                            Text(
                                              '(${lang.englishName})',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: isSelected
                                                    ? AppColors.primaryDark.withValues(alpha: 0.8)
                                                    : AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      Text(
                                        '${lang.greeting}!',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isSelected ? AppColors.primary : AppColors.textTertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Checkmark
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.primary,
                                    size: 22,
                                  )
                                else
                                  Icon(
                                    Icons.radio_button_unchecked,
                                    color: AppColors.textTertiary.withValues(alpha: 0.5),
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  AppSpacing.gapV8,
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
