import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/authentication/domain/models/farmer_profile_model.dart';
import '../../features/authentication/domain/models/user_model.dart';

/// Provider for local session persistence.
final sessionStorageProvider = Provider<SessionStorage>((ref) {
  return SessionStorage();
});

/// Manages local user session and profile persistence via SharedPreferences.
///
/// Plaintext passwords are NEVER stored. Only authenticated user tokens
/// and user profile state are persisted.
class SessionStorage {
  static const String _keyToken = 'kisan_auth_token';
  static const String _keyUser = 'kisan_auth_user';
  static const String _keyProfile = 'kisan_farmer_profile';

  /// Save active JWT or session auth token.
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  /// Retrieve current session auth token.
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  /// Save logged in farmer user account details.
  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));
  }

  /// Retrieve cached farmer user account.
  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyUser);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return UserModel.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  /// Save complete farmer operational profile.
  Future<void> saveProfile(FarmerProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProfile, jsonEncode(profile.toJson()));
  }

  /// Retrieve cached farmer operational profile.
  Future<FarmerProfile?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyProfile);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return FarmerProfile.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  /// Check whether an authenticated session exists.
  Future<bool> hasActiveSession() async {
    final token = await getToken();
    final user = await getUser();
    return token != null && token.isNotEmpty && user != null;
  }

  /// Check whether the farmer has completed their profile setup.
  Future<bool> hasCompletedProfile() async {
    final profile = await getProfile();
    return profile != null &&
        profile.location.state.isNotEmpty &&
        profile.location.district.isNotEmpty &&
        profile.farmDetails.landArea > 0;
  }

  /// Clear all credentials and profile data upon logout.
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUser);
    await prefs.remove(_keyProfile);
  }
}

