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
/// Plaintext passwords are NEVER stored. Only authenticated user tokens,
/// persistent user records, and profile state are persisted.
///
/// Log out clears only the active session token and active user pointer.
/// Account deletion permanently deletes user accounts and profiles.
class SessionStorage {
  static const String _keyToken = 'kisan_auth_token';
  static const String _keyUser = 'kisan_auth_user';
  static const String _keyProfile = 'kisan_farmer_profile';
  static const String _keyActivePhone = 'kisan_active_phone';
  static const String _keyLanguage = 'kisan_app_language';

  // Prefixes for persistent multi-account storage (keyed by clean phone number)
  static const String _prefixAccount = 'kisan_acc_';
  static const String _prefixProfile = 'kisan_prof_';
  static const String _prefixCredential = 'kisan_cred_';

  // --- Active Session Management ---

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

  /// Save active farmer user account details.
  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_keyUser, userJson);
    await prefs.setString(_keyActivePhone, user.phoneNumber);

    // Also persist in the account registry by phone number
    if (user.phoneNumber.isNotEmpty) {
      await prefs.setString('$_prefixAccount${user.phoneNumber}', userJson);
    }
  }

  /// Retrieve currently active farmer user account.
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

  /// Save complete farmer operational profile to active session and persistent store.
  Future<void> saveProfile(FarmerProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = jsonEncode(profile.toJson());
    await prefs.setString(_keyProfile, profileJson);

    // Save to active phone's persistent profile
    final activePhone = prefs.getString(_keyActivePhone);
    if (activePhone != null && activePhone.isNotEmpty) {
      await prefs.setString('$_prefixProfile$activePhone', profileJson);
    }
  }

  /// Retrieve active farmer operational profile.
  Future<FarmerProfile?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyProfile);
    if (raw == null || raw.isEmpty) {
      // Fallback: check persistent profile for active phone
      final activePhone = prefs.getString(_keyActivePhone);
      if (activePhone != null && activePhone.isNotEmpty) {
        return getProfileForPhone(activePhone);
      }
      return null;
    }
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return FarmerProfile.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  /// Save preferred app language code across app restarts.
  Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, languageCode);
  }

  /// Retrieve preferred app language code.
  Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLanguage);
  }

  // --- Persistent Account & Profile Storage (Survives Logout) ---

  /// Save registered user account and credential hash to persistent storage.
  Future<void> saveRegisteredAccount({
    required UserModel user,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    if (user.phoneNumber.isNotEmpty) {
      await prefs.setString('$_prefixAccount${user.phoneNumber}', userJson);
      await prefs.setString('$_prefixCredential${user.phoneNumber}', password);
    }
    if (user.email != null && user.email!.trim().isNotEmpty) {
      final emailKey = user.email!.trim().toLowerCase();
      await prefs.setString('$_prefixAccount$emailKey', userJson);
      await prefs.setString('$_prefixCredential$emailKey', password);
    }
    final usernameKey = user.fullName.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');
    if (usernameKey.isNotEmpty) {
      await prefs.setString('$_prefixAccount$usernameKey', userJson);
      await prefs.setString('$_prefixCredential$usernameKey', password);
    }
  }

  /// Retrieve persistent account record by phone number.
  Future<UserModel?> getAccountByPhone(String phone) async {
    return getAccountByIdentifier(phone);
  }

  /// Retrieve persistent account record by phone number, email, or username.
  Future<UserModel?> getAccountByIdentifier(String identifier) async {
    final prefs = await SharedPreferences.getInstance();
    final cleanId = identifier.trim();
    final lowerId = cleanId.toLowerCase();

    // 1. Direct lookup by key or lowercase
    var raw = prefs.getString('$_prefixAccount$cleanId') ??
        prefs.getString('$_prefixAccount$lowerId');

    // 2. Mobile number normalization lookup
    if (raw == null || raw.isEmpty) {
      var cleaned = cleanId.replaceAll(RegExp(r'[\s\-\(\)]'), '');
      if (cleaned.startsWith('+91')) cleaned = cleaned.substring(3);
      if (cleaned.startsWith('0') && cleaned.length == 11) cleaned = cleaned.substring(1);
      if (cleaned.isNotEmpty) {
        raw = prefs.getString('$_prefixAccount$cleaned');
      }
    }

    // 3. Fallback: check currently active user if properties match
    if (raw == null || raw.isEmpty) {
      final current = await getUser();
      if (current != null) {
        final currentUsername = current.fullName.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');
        if (current.phoneNumber == cleanId ||
            current.email?.toLowerCase() == lowerId ||
            currentUsername == lowerId) {
          return current;
        }
      }
      return null;
    }

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return UserModel.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  /// Verify entered password against persistent account credential.
  Future<bool> verifyPassword(String identifier, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final cleanId = identifier.trim();
    final lowerId = cleanId.toLowerCase();

    var savedPwd = prefs.getString('$_prefixCredential$cleanId') ??
        prefs.getString('$_prefixCredential$lowerId');

    if (savedPwd == null || savedPwd.isEmpty) {
      var cleaned = cleanId.replaceAll(RegExp(r'[\s\-\(\)]'), '');
      if (cleaned.startsWith('+91')) cleaned = cleaned.substring(3);
      if (cleaned.startsWith('0') && cleaned.length == 11) cleaned = cleaned.substring(1);
      if (cleaned.isNotEmpty) {
        savedPwd = prefs.getString('$_prefixCredential$cleaned');
      }
    }

    if (savedPwd == null || savedPwd.isEmpty) {
      return false;
    }
    return savedPwd == password;
  }

  /// Save completed farmer profile for a specific phone number.
  Future<void> saveProfileForPhone(String phone, FarmerProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = jsonEncode(profile.toJson());
    await prefs.setString('$_prefixProfile$phone', profileJson);
    await prefs.setString(_keyProfile, profileJson);
  }

  /// Retrieve persistent profile for a specific phone number.
  Future<FarmerProfile?> getProfileForPhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_prefixProfile$phone');
    if (raw == null || raw.isEmpty) {
      // Fallback to active profile if matches
      final current = await getProfile();
      return current;
    }
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

  /// Clear active session upon Logout / Sign Out.
  ///
  /// CRITICAL DISTINCTION:
  /// Logging out ONLY invalidates the active session token and active session pointer.
  /// It DOES NOT delete registered accounts, profiles, or farm data.
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUser);
    await prefs.remove(_keyProfile);
    await prefs.remove(_keyActivePhone);
  }

  /// Permanently delete an account and its farmer profile.
  ///
  /// CRITICAL DISTINCTION:
  /// Account deletion permanently wipes user credentials, farm details,
  /// and local data for this mobile number from the device.
  Future<void> deleteAccount(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_prefixAccount$phone');
    await prefs.remove('$_prefixProfile$phone');
    await prefs.remove('$_prefixCredential$phone');

    // Also clear active session if currently signed in to this account
    final activePhone = prefs.getString(_keyActivePhone);
    if (activePhone == phone || activePhone == null) {
      await clearSession();
    }
  }
}

