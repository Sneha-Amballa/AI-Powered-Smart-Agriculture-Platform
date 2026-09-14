import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_repository.dart';
import '../../domain/models/farmer_profile_model.dart';
import 'auth_state.dart';

/// Global listenable synchronized with the current AuthState for GoRouter.
final authStateListenable = ValueNotifier<AuthState>(AuthState.initial());

/// NotifierProvider for authentication state management.
final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

/// Centralized authentication and farmer profile state controller.
class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository _repository;

  @override
  AuthState build() {
    _repository = ref.watch(authRepositoryProvider);
    Future.microtask(() => initialize());
    return AuthState.initial();
  }

  void _updateState(AuthState newState) {
    state = newState;
    if (authStateListenable.value != newState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        authStateListenable.value = newState;
      });
    }
  }

  /// Initialize and restore existing session from local storage.
  Future<void> initialize() async {
    try {
      final session = await _repository.restoreSession();
      if (session.user == null) {
        _updateState(AuthState.unauthenticated());
        return;
      }

      final profile = session.profile;
      final isProfileComplete = profile != null &&
          profile.location.state.isNotEmpty &&
          profile.location.district.isNotEmpty &&
          profile.farmDetails.landArea > 0;

      _updateState(AuthState(
        status: isProfileComplete
            ? AuthStatus.profileComplete
            : AuthStatus.profileIncomplete,
        user: session.user,
        profile: profile,
      ));
    } catch (_) {
      _updateState(AuthState.unauthenticated());
    }
  }

  /// Register a new farmer user account.
  Future<bool> register({
    required String fullName,
    required String phoneNumber,
    required String password,
  }) async {
    _updateState(state.copyWith(isLoading: true, clearError: true));
    try {
      final user = await _repository.register(
        fullName: fullName,
        phoneNumber: phoneNumber,
        password: password,
      );

      _updateState(AuthState(
        status: AuthStatus.profileIncomplete,
        user: user,
        profile: null,
        isLoading: false,
      ));
      return true;
    } catch (e) {
      final message = e.toString().replaceFirst('FormatException: ', '');
      _updateState(state.copyWith(
        isLoading: false,
        errorMessage: message,
      ));
      return false;
    }
  }

  /// Authenticate farmer user with mobile number and password.
  Future<bool> login({
    required String phoneNumber,
    required String password,
  }) async {
    _updateState(state.copyWith(isLoading: true, clearError: true));
    try {
      final result = await _repository.login(
        phoneNumber: phoneNumber,
        password: password,
      );

      final profile = result.profile;
      final isProfileComplete = profile != null &&
          profile.location.state.isNotEmpty &&
          profile.location.district.isNotEmpty &&
          profile.farmDetails.landArea > 0;

      _updateState(AuthState(
        status: isProfileComplete
            ? AuthStatus.profileComplete
            : AuthStatus.profileIncomplete,
        user: result.user,
        profile: profile,
        isLoading: false,
      ));
      return true;
    } catch (e) {
      final message = e.toString().replaceFirst('FormatException: ', '');
      _updateState(state.copyWith(
        isLoading: false,
        errorMessage: message,
      ));
      return false;
    }
  }

  /// Save completed farmer profile from setup wizard.
  Future<bool> saveFarmerProfile({
    required FarmerLocation location,
    required FarmDetails farmDetails,
  }) async {
    _updateState(state.copyWith(isLoading: true, clearError: true));
    try {
      final currentUserId =
          state.user?.id ?? 'farmer_${DateTime.now().millisecondsSinceEpoch}';
      final profile = FarmerProfile(
        userId: currentUserId,
        location: location,
        farmDetails: farmDetails,
        updatedAt: DateTime.now(),
      );

      final saved = await _repository.saveFarmerProfile(profile);

      _updateState(state.copyWith(
        status: AuthStatus.profileComplete,
        profile: saved,
        isLoading: false,
      ));
      return true;
    } catch (e) {
      _updateState(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to save farmer profile: ${e.toString()}',
      ));
      return false;
    }
  }

  /// Update existing farmer profile details.
  Future<bool> updateProfile(FarmerProfile updatedProfile) async {
    _updateState(state.copyWith(isLoading: true, clearError: true));
    try {
      final saved = await _repository.saveFarmerProfile(updatedProfile);
      _updateState(state.copyWith(
        profile: saved,
        isLoading: false,
      ));
      return true;
    } catch (e) {
      _updateState(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update profile: ${e.toString()}',
      ));
      return false;
    }
  }

  /// Logout farmer user, wipe local credentials, and redirect.
  Future<void> logout() async {
    await _repository.logout();
    _updateState(AuthState.unauthenticated());
  }

  /// Clear any active error banner.
  void clearError() {
    if (state.errorMessage != null) {
      _updateState(state.copyWith(clearError: true));
    }
  }
}


