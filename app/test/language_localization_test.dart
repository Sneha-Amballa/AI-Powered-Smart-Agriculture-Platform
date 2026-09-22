import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_agriculture_app/app/app.dart';
import 'package:smart_agriculture_app/app/router.dart';
import 'package:smart_agriculture_app/core/localization/app_language.dart';
import 'package:smart_agriculture_app/core/localization/app_translations.dart';
import 'package:smart_agriculture_app/core/localization/locale_provider.dart';
import 'package:smart_agriculture_app/core/storage/session_storage.dart';
import 'package:smart_agriculture_app/features/authentication/domain/models/farmer_profile_model.dart';
import 'package:smart_agriculture_app/features/authentication/domain/models/user_model.dart';
import 'package:smart_agriculture_app/features/authentication/presentation/providers/auth_provider.dart';
import 'package:smart_agriculture_app/features/authentication/presentation/providers/auth_state.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    authStateListenable.value = AuthState.initial();
  });

  testWidgets('Registration screen asks for language and immediately adapts form labels on tap', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    authStateListenable.value = AuthState.unauthenticated();

    await tester.pumpWidget(
      const ProviderScope(
        child: SmartAgriApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pumpAndSettle();

    // Navigate to registration
    appRouter.go('/register');
    await tester.pumpAndSettle();

    // Verify language section is present with prompt and chips
    expect(find.textContaining('Language'), findsAtLeastNWidgets(1));
    expect(find.textContaining('हिन्दी (HI)'), findsOneWidget);
    expect(find.textContaining('తెలుగు (TE)'), findsOneWidget);
    expect(find.textContaining('தமிழ் (TA)'), findsOneWidget);

    // Initial language is English - full name label is "Farmer Full Name *"
    expect(find.text('Farmer Full Name *'), findsOneWidget);

    // Tap Hindi chip
    await tester.tap(find.textContaining('हिन्दी (HI)'));
    await tester.pumpAndSettle();

    // Verify form dynamically switched to Hindi!
    // Full name label translated: 'किसान का पूरा नाम *'
    expect(find.text('किसान का पूरा नाम *'), findsOneWidget);
    // Submit button translated: 'पंजीकरण करें और खेत विवरण भरें'
    expect(find.text('पंजीकरण करें और खेत विवरण भरें'), findsOneWidget);

    // Tap Telugu chip
    await tester.tap(find.textContaining('తెలుగు (TE)'));
    await tester.pumpAndSettle();

    // Verify form dynamically switched to Telugu!
    expect(find.text('రైతు పూర్తి పేరు *'), findsOneWidget);
    expect(find.text('నమోదు చేసి ఫారం వివరాలకు వెళ్లండి'), findsOneWidget);
  });

  testWidgets('Farmer can view and edit language in ProfileScreen, updating entire app language', (WidgetTester tester) async {
    const user = UserModel(
      id: 'kisan_lang_test',
      fullName: 'Ramesh Patel',
      phoneNumber: '9876543210',
      preferredLanguage: 'en',
    );
    const profile = FarmerProfile(
      userId: 'kisan_lang_test',
      location: FarmerLocation(
        state: 'Gujarat',
        district: 'Rajkot',
        village: 'Gondal',
      ),
      farmDetails: FarmDetails(
        landArea: 6.5,
        areaUnit: 'Acres',
        primaryCrop: 'Cotton',
        irrigationType: 'Drip Irrigation',
      ),
      preferredLanguage: 'en',
    );

    SharedPreferences.setMockInitialValues({
      'kisan_auth_user': jsonEncode(user.toJson()),
      'kisan_auth_token': 'token_lang_test',
      'kisan_farmer_profile': jsonEncode(profile.toJson()),
      'kisan_app_language': 'en',
    });

    authStateListenable.value = const AuthState(
      status: AuthStatus.profileComplete,
      user: user,
      profile: profile,
    );

    await tester.pumpWidget(
      const ProviderScope(
        child: SmartAgriApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pumpAndSettle();

    // Navigate to Profile
    appRouter.go('/profile');
    await tester.pumpAndSettle();

    // Verify Language preference section is displayed
    expect(find.text('Preferred Language'), findsAtLeastNWidgets(1));
    expect(find.text('English'), findsAtLeastNWidgets(1));
    // Scroll to and tap Change Language button to open language selector bottom sheet
    await tester.ensureVisible(find.text('Change Language').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Change Language').first);
    await tester.pumpAndSettle();

    // Verify Bottom sheet displays Indian regional languages
    expect(find.text('Select App Language'), findsOneWidget);
    expect(find.text('हिन्दी'), findsOneWidget);
    expect(find.text('తెలుగు'), findsOneWidget);

    // Select Hindi in the sheet
    await tester.tap(find.text('हिन्दी'));
    await tester.pumpAndSettle();

    // Verify language changed to Hindi in profile screen
    // 'Preferred Language' translated to 'पसंदीदा भाषा'
    expect(find.text('पसंदीदा भाषा'), findsAtLeastNWidgets(1));

    // Navigate to Dashboard to verify entire app changed to Hindi
    appRouter.go('/dashboard');
    await tester.pumpAndSettle();

    // Verify Dashboard greeting is now in Hindi ('नमस्ते, Ramesh!')
    expect(find.textContaining('नमस्ते'), findsOneWidget);
  });

  test('SessionStorage persists and restores user preferred language', () async {
    final storage = SessionStorage();
    await storage.saveLanguage('hi');

    final retrieved = await storage.getLanguage();
    expect(retrieved, equals('hi'));

    await storage.saveLanguage('te');
    expect(await storage.getLanguage(), equals('te'));
  });
}
