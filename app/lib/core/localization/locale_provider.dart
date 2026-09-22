import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/session_storage.dart';
import 'app_language.dart';

/// Global notifier for reactive, persistent app-wide language preference.
class LocaleNotifier extends Notifier<AppLanguage> {
  late final SessionStorage _storage;

  @override
  AppLanguage build() {
    _storage = ref.watch(sessionStorageProvider);
    _initFromStorage();
    return AppLanguage.en;
  }

  Future<void> _initFromStorage() async {
    final savedCode = await _storage.getLanguage();
    if (savedCode != null && savedCode.isNotEmpty) {
      final resolved = AppLanguage.fromCode(savedCode);
      if (resolved != state) {
        state = resolved;
      }
    } else {
      // Also check active user's preferred language if already logged in
      final user = await _storage.getUser();
      if (user != null && user.preferredLanguage.isNotEmpty) {
        final resolved = AppLanguage.fromCode(user.preferredLanguage);
        if (resolved != state) {
          state = resolved;
          await _storage.saveLanguage(resolved.code);
        }
      }
    }
  }

  /// Change active app language globally, persist it, and sync to farmer user profile.
  Future<void> setLanguage(AppLanguage language, {bool syncUser = true}) async {
    if (state == language) return;
    state = language;
    await _storage.saveLanguage(language.code);

    if (syncUser) {
      final user = await _storage.getUser();
      if (user != null) {
        final updatedUser = user.copyWith(preferredLanguage: language.code);
        await _storage.saveUser(updatedUser);

        final profile = await _storage.getProfile();
        if (profile != null) {
          final updatedProfile = profile.copyWith(preferredLanguage: language.code);
          await _storage.saveProfile(updatedProfile);
        }
      }
    }
  }
}

/// Centralized provider for reading and updating the active application language.
final localeNotifierProvider =
    NotifierProvider<LocaleNotifier, AppLanguage>(LocaleNotifier.new);
