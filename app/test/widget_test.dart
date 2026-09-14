import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_agriculture_app/app/app.dart';
import 'package:smart_agriculture_app/app/router.dart';
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

  testWidgets('App initializes splash and loads landing screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      const ProviderScope(
        child: SmartAgriApp(),
      ),
    );

    // Initial frame displays splash branding
    expect(find.text('AI-Powered Precision Agriculture Platform'), findsOneWidget);

    // Advance clock past splash timer to transition to landing page
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pumpAndSettle();

    // Verify Landing page hero headline is rendered
    expect(find.textContaining('Smarter Decisions'), findsOneWidget);
  });

  testWidgets('All planned routes mount cleanly without error for authenticated farmer', (WidgetTester tester) async {
    const user = UserModel(
      id: 'kisan_test_1',
      fullName: 'Rajesh Sharma',
      phoneNumber: '9876543210',
    );
    const profile = FarmerProfile(
      userId: 'kisan_test_1',
      location: FarmerLocation(
        state: 'Andhra Pradesh',
        district: 'Kurnool',
        village: 'Nandyal',
        pincode: '518501',
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

    SharedPreferences.setMockInitialValues({
      'kisan_auth_user': jsonEncode(user.toJson()),
      'kisan_auth_token': 'token_test_1',
      'kisan_farmer_profile': jsonEncode(profile.toJson()),
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

    final routesToTest = [
      '/dashboard',
      '/crop-recommendation',
      '/disease-detection',
      '/pest-detection',
      '/weather',
      '/market',
      '/price-prediction',
      '/government-schemes',
      '/assistant',
      '/profile',
      '/settings',
      '/onboarding',
    ];

    for (final route in routesToTest) {
      appRouter.go(route);
      await tester.pumpAndSettle();
      expect(find.byType(SmartAgriApp), findsOneWidget);
    }
  });

  testWidgets('Zero RenderFlex overflow across narrow (320dp), standard (360dp), large phone (412dp), tablet (768dp), and desktop (1280dp)', (WidgetTester tester) async {
    const user = UserModel(
      id: 'kisan_test_1',
      fullName: 'Rajesh Sharma',
      phoneNumber: '9876543210',
    );
    const profile = FarmerProfile(
      userId: 'kisan_test_1',
      location: FarmerLocation(
        state: 'Andhra Pradesh',
        district: 'Kurnool',
        village: 'Nandyal',
        pincode: '518501',
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

    SharedPreferences.setMockInitialValues({
      'kisan_auth_user': jsonEncode(user.toJson()),
      'kisan_auth_token': 'token_test_1',
      'kisan_farmer_profile': jsonEncode(profile.toJson()),
    });

    authStateListenable.value = const AuthState(
      status: AuthStatus.profileComplete,
      user: user,
      profile: profile,
    );

    final deviceSizes = [
      const Size(320, 568),  // Ultra-compact mobile
      const Size(360, 740),  // Standard Android phone
      const Size(412, 915),  // Large Android phone (e.g. SM M366B)
      const Size(768, 1024), // Tablet
      const Size(1280, 800), // Desktop / Web
    ];

    final keyRoutes = [
      '/',
      '/dashboard',
      '/crop-recommendation',
      '/disease-detection',
      '/pest-detection',
      '/weather',
      '/market',
      '/price-prediction',
      '/government-schemes',
      '/assistant',
      '/profile',
      '/settings',
      '/register',
      '/login',
      '/profile-setup',
      '/forgot-password',
    ];

    for (final size in deviceSizes) {
      tester.view.physicalSize = Size(size.width * 2, size.height * 2);
      tester.view.devicePixelRatio = 2.0;

      await tester.pumpWidget(
        const ProviderScope(
          child: SmartAgriApp(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 2000));
      await tester.pumpAndSettle();

      for (final route in keyRoutes) {
        if (route == '/register' || route == '/login' || route == '/forgot-password' || route == '/') {
          authStateListenable.value = AuthState.unauthenticated();
        } else if (route == '/profile-setup') {
          authStateListenable.value = const AuthState(
            status: AuthStatus.profileIncomplete,
            user: UserModel(id: 'test', fullName: 'Test Farmer', phoneNumber: '9876543210'),
          );
        } else {
          authStateListenable.value = const AuthState(
            status: AuthStatus.profileComplete,
            user: user,
            profile: profile,
          );
        }

        appRouter.go(route);
        await tester.pumpAndSettle();
        expect(find.byType(SmartAgriApp), findsOneWidget);
      }
    }

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });

  testWidgets('Route guard redirects unauthenticated user from /dashboard to /login', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    authStateListenable.value = AuthState.unauthenticated();

    await tester.pumpWidget(
      const ProviderScope(
        child: SmartAgriApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pumpAndSettle();

    appRouter.go('/dashboard');
    await tester.pumpAndSettle();

    // Verify redirected to Login screen
    expect(find.text('Farmer Sign In'), findsOneWidget);
  });

  testWidgets('Route guard redirects incomplete profile user from /dashboard to /profile-setup', (WidgetTester tester) async {
    final user = const UserModel(id: 'u1', fullName: 'New Farmer', phoneNumber: '9876543210');
    SharedPreferences.setMockInitialValues({
      'kisan_auth_user': jsonEncode(user.toJson()),
      'kisan_auth_token': 'token_u1',
    });

    authStateListenable.value = AuthState(
      status: AuthStatus.profileIncomplete,
      user: user,
    );

    await tester.pumpWidget(
      const ProviderScope(
        child: SmartAgriApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pumpAndSettle();

    appRouter.go('/dashboard');
    await tester.pumpAndSettle();

    // Verify redirected to Profile Setup screen
    expect(find.textContaining('Step 1: Farm Location'), findsOneWidget);
  });

  testWidgets('Forgot password screen displays official Kisan Helpline (1800-180-1551)', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    authStateListenable.value = AuthState.unauthenticated();

    await tester.pumpWidget(
      const ProviderScope(
        child: SmartAgriApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pumpAndSettle();

    appRouter.go('/forgot-password');
    await tester.pumpAndSettle();

    expect(find.text('1800-180-1551'), findsOneWidget);
    expect(find.text('Password Assistance'), findsOneWidget);
  });

  testWidgets('Farmer Dashboard displays personalized greeting, farm advisory centerpiece, weather impact, and quick actions', (WidgetTester tester) async {
    const user = UserModel(
      id: 'kisan_dash_1',
      fullName: 'Ramesh Patel',
      phoneNumber: '9876543210',
    );
    const profile = FarmerProfile(
      userId: 'kisan_dash_1',
      location: FarmerLocation(
        state: 'Gujarat',
        district: 'Rajkot',
        village: 'Gondal',
      ),
      farmDetails: FarmDetails(
        landArea: 6.5,
        areaUnit: 'Acres',
        hasSoilReport: true,
        ph: 6.8,
        nitrogen: 110,
        phosphorus: 40,
        potassium: 55,
        irrigationType: 'Drip Irrigation',
        primaryCrop: 'Cotton',
      ),
    );

    SharedPreferences.setMockInitialValues({
      'kisan_auth_user': jsonEncode(user.toJson()),
      'kisan_auth_token': 'token_dash_1',
      'kisan_farmer_profile': jsonEncode(profile.toJson()),
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

    appRouter.go('/dashboard');
    await tester.pumpAndSettle();

    // 1. Personalized Greeting with dynamic farmer name
    expect(find.textContaining('Ramesh'), findsOneWidget);

    // 2. Today's Farm Advisory (Centerpiece)
    expect(find.text('TODAY’S ADVISORY'), findsOneWidget);
    expect(find.text('Rain is expected tomorrow.'), findsOneWidget);

    // 3. Weather + Farming Impact
    expect(find.text('Farming Impact'), findsOneWidget);

    // 4. Crop Recommendation (found in summary card and quick actions)
    expect(find.text('Crop Recommendation'), findsAtLeastNWidgets(1));

    // 5. Market Snapshot
    expect(find.textContaining('Market Snapshot'), findsOneWidget);

    // 6. Disease Detection Spotlight (No separate pest card)
    expect(find.text('Plant Disease Detection'), findsOneWidget);
    expect(find.text('Take Photo'), findsOneWidget);
    expect(find.text('Upload Image'), findsOneWidget);

    // 7. Government Schemes
    expect(find.textContaining('Government Support'), findsOneWidget);

    // 8. AI Assistant Entry
    expect(find.text('Ask your Agriculture Assistant'), findsOneWidget);
    expect(find.text('Ask AgriAI'), findsOneWidget);
  });
}


