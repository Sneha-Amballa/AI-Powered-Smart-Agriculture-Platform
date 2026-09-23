import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/session_storage.dart';
import '../domain/models/farmer_profile_model.dart';
import '../domain/models/user_model.dart';

/// Provider for AuthRepository.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.watch(sessionStorageProvider);
  return AuthRepository(storage);
});

/// Repository handling authentication lifecycle, credential checks,
/// and profile persistence.
class AuthRepository {
  final SessionStorage _storage;

  AuthRepository(this._storage);

  /// Sanitize and validate Indian 10-digit mobile number.
  String cleanPhoneNumber(String phone) {
    var cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (cleaned.startsWith('+91')) {
      cleaned = cleaned.substring(3);
    } else if (cleaned.startsWith('0') && cleaned.length == 11) {
      cleaned = cleaned.substring(1);
    }
    return cleaned;
  }

  /// Check if phone number is valid 10-digit Indian mobile.
  bool isValidIndianMobile(String phone) {
    final cleaned = cleanPhoneNumber(phone);
    return RegExp(r'^[6-9]\d{9}$').hasMatch(cleaned);
  }

  /// Register a new farmer account.
  Future<UserModel> register({
    required String fullName,
    required String phoneNumber,
    required String password,
    String preferredLanguage = 'en',
  }) async {
    final cleanPhone = cleanPhoneNumber(phoneNumber);
    if (!isValidIndianMobile(cleanPhone)) {
      throw const FormatException('Please enter a valid 10-digit Indian mobile number');
    }
    if (fullName.trim().length < 2) {
      throw const FormatException('Please enter a valid farmer name');
    }
    if (password.length < 6) {
      throw const FormatException('Password must be at least 6 characters');
    }

    // In offline-first architecture, generate user session token and save user record
    final userId = 'kisan_${DateTime.now().millisecondsSinceEpoch}';
    final user = UserModel(
      id: userId,
      fullName: fullName.trim(),
      phoneNumber: cleanPhone,
      preferredLanguage: preferredLanguage,
      createdAt: DateTime.now(),
    );

    final sessionToken = 'kisan_sess_${base64Url.encode(utf8.encode('$userId:$cleanPhone'))}';

    // Save to persistent multi-account storage and active session
    await _storage.saveRegisteredAccount(user: user, password: password);
    await _storage.saveUser(user);
    await _storage.saveToken(sessionToken);
    await _storage.saveLanguage(preferredLanguage);

    return user;
  }

  /// Sign in with identifier (email, username, or mobile number) and password.
  Future<({UserModel user, FarmerProfile? profile})> login({
    String? identifier,
    String? phoneNumber,
    required String password,
  }) async {
    final rawInput = (identifier ?? phoneNumber ?? '').trim();
    if (rawInput.isEmpty) {
      throw const FormatException('Please enter your email or username');
    }
    if (password.isEmpty) {
      throw const FormatException('Please enter your account password');
    }

    final lowerInput = rawInput.toLowerCase();
    final cleanPhone = cleanPhoneNumber(rawInput);
    final isPhone = isValidIndianMobile(cleanPhone);

    // 1. Look up existing persistent account by identifier or phone
    final existingAccount = await _storage.getAccountByIdentifier(rawInput) ??
        (isPhone ? await _storage.getAccountByPhone(cleanPhone) : null);

    if (existingAccount != null) {
      // Verify credentials against stored credential hash
      final isPasswordValid = await _storage.verifyPassword(
            existingAccount.phoneNumber.isNotEmpty ? existingAccount.phoneNumber : rawInput,
            password,
          ) ||
          await _storage.verifyPassword(rawInput, password);

      if (!isPasswordValid) {
        throw const FormatException('Incorrect password. Please verify and try again.');
      }

      // Retrieve persistent farmer profile associated with this account
      final existingProfile = existingAccount.phoneNumber.isNotEmpty
          ? await _storage.getProfileForPhone(existingAccount.phoneNumber)
          : await _storage.getProfile();

      final token = 'kisan_sess_${base64Url.encode(utf8.encode('${existingAccount.id}:${existingAccount.phoneNumber}'))}';

      // Restore active session
      await _storage.saveUser(existingAccount);
      await _storage.saveToken(token);
      if (existingAccount.preferredLanguage.isNotEmpty) {
        await _storage.saveLanguage(existingAccount.preferredLanguage);
      }
      if (existingProfile != null) {
        await _storage.saveProfile(existingProfile);
      }

      return (user: existingAccount, profile: existingProfile);
    }

    // 2. Demo account credentials check:
    // Supported demo identifiers: 9876543210, farmer, demo, admin, farmer@kisan.ai, demo@kisan.ai
    final isDemoIdentifier = cleanPhone == '9876543210' ||
        lowerInput == 'farmer' ||
        lowerInput == 'demo' ||
        lowerInput == 'admin' ||
        lowerInput == 'farmer@kisan.ai' ||
        lowerInput == 'demo@kisan.ai';

    if (isDemoIdentifier) {
      if (password != 'kisan123' && password != 'admin' && password != 'password123') {
        throw const FormatException('Incorrect password. For demo account, use: kisan123');
      }
      const demoUser = UserModel(
        id: 'farmer_sample_3210',
        fullName: 'Rajesh Sharma',
        phoneNumber: '9876543210',
        email: 'farmer@kisan.ai',
      );
      const demoProfile = FarmerProfile(
        userId: 'farmer_sample_3210',
        location: FarmerLocation(
          state: 'Andhra Pradesh',
          district: 'Kurnool',
          village: 'Nandyal',
          pincode: '518501',
          latitude: 15.8281,
          longitude: 78.0373,
        ),

        farmDetails: FarmDetails(
          landArea: 5.2,
          areaUnit: 'Acres',
          hasSoilReport: true,
          ph: 6.5,
          nitrogen: 120,
          phosphorus: 45,
          potassium: 60,
          irrigationType: 'Borewell',
          primaryCrop: 'Cotton / Chilli',
          farmingExperienceYears: 12,
        ),
      );

      await _storage.saveRegisteredAccount(user: demoUser, password: 'kisan123');
      await _storage.saveProfileForPhone('9876543210', demoProfile);
      await _storage.saveUser(demoUser);
      await _storage.saveToken('kisan_sess_demo_3210');
      await _storage.saveProfile(demoProfile);

      return (user: demoUser, profile: demoProfile);
    }

    // 3. Unrecognized account or invalid credentials:
    throw const FormatException('Invalid credentials. Please verify your email/username and password.');
  }

  /// Save completed or updated farmer profile.
  Future<FarmerProfile> saveFarmerProfile(FarmerProfile profile) async {
    await _storage.saveProfile(profile);
    final user = await _storage.getUser();
    if (user != null && user.phoneNumber.isNotEmpty) {
      await _storage.saveProfileForPhone(user.phoneNumber, profile);
    }
    return profile;
  }

  /// Restore existing session on app initialization.
  Future<({UserModel? user, FarmerProfile? profile, String? token})> restoreSession() async {
    final token = await _storage.getToken();
    final user = await _storage.getUser();
    final profile = await _storage.getProfile();
    return (user: user, profile: profile, token: token);
  }

  /// Logout and clear active session token.
  /// Does NOT delete the farmer's registered account or saved profile.
  Future<void> logout() async {
    await _storage.clearSession();
  }

  /// Permanently delete farmer account and wipe profile data from this device.
  Future<void> deleteAccount() async {
    final user = await _storage.getUser();
    if (user != null && user.phoneNumber.isNotEmpty) {
      await _storage.deleteAccount(user.phoneNumber);
    } else {
      await _storage.clearSession();
    }
  }

  /// Update farmer preferred language in active user, persistent registry, and storage.
  Future<UserModel?> updateLanguage(String languageCode) async {
    final user = await _storage.getUser();
    await _storage.saveLanguage(languageCode);
    if (user != null) {
      final updatedUser = user.copyWith(preferredLanguage: languageCode);
      await _storage.saveUser(updatedUser);

      final profile = await _storage.getProfile();
      if (profile != null) {
        final updatedProfile = profile.copyWith(preferredLanguage: languageCode);
        await _storage.saveProfile(updatedProfile);
        if (user.phoneNumber.isNotEmpty) {
          await _storage.saveProfileForPhone(user.phoneNumber, updatedProfile);
        }
      }
      return updatedUser;
    }
    return null;
  }
}

