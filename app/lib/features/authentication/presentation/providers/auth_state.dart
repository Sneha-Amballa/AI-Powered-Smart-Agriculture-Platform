import '../../domain/models/farmer_profile_model.dart';
import '../../domain/models/user_model.dart';

/// Explicit lifecycle states for farmer authentication and profile setup.
enum AuthStatus {
  /// Session initialization check in progress.
  initial,

  /// No authenticated session active.
  unauthenticated,

  /// User credentials valid, profile status being checked.
  authenticated,

  /// User registered or authenticated, but farm profile setup has not been completed.
  profileIncomplete,

  /// User authenticated with complete operational farm profile.
  profileComplete,
}

/// Centralized state for authentication, farmer profile, and operation status.
class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final FarmerProfile? profile;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.user,
    this.profile,
    this.isLoading = false,
    this.errorMessage,
  });

  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);

  factory AuthState.unauthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);

  bool get isAuthenticated =>
      status == AuthStatus.authenticated ||
      status == AuthStatus.profileIncomplete ||
      status == AuthStatus.profileComplete;

  bool get isProfileComplete => status == AuthStatus.profileComplete;

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    FarmerProfile? profile,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool clearProfile = false,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      profile: clearProfile ? null : (profile ?? this.profile),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          user == other.user &&
          isLoading == other.isLoading &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode =>
      status.hashCode ^
      user.hashCode ^
      isLoading.hashCode ^
      errorMessage.hashCode;
}

