import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_agriculture_app/app/app.dart';
import 'package:smart_agriculture_app/app/router.dart';
import 'package:smart_agriculture_app/core/storage/session_storage.dart';
import 'package:smart_agriculture_app/features/authentication/data/auth_repository.dart';
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

  group('Authentication and Navigation Flow Tests', () {
    testWidgets(
      'Flow 1: App Launch -> Tap Sign In -> Displays Login screen without auto-login',
      (WidgetTester tester) async {
        SharedPreferences.setMockInitialValues({});
        authStateListenable.value = AuthState.unauthenticated();

        await tester.pumpWidget(
          const ProviderScope(
            child: SmartAgriApp(),
          ),
        );

        // Advance splash timer to transition to landing page
        await tester.pump(const Duration(milliseconds: 2000));
        await tester.pumpAndSettle();

        // Verify on Landing page
        final signInBtn = find.widgetWithText(TextButton, 'Sign In');
        expect(signInBtn, findsOneWidget);

        // Tap Sign In
        await tester.tap(signInBtn);
        await tester.pumpAndSettle();

        // Must display proper Login screen
        expect(find.text('Farmer Sign In'), findsOneWidget);
        expect(find.text('Email or Username'), findsOneWidget);
        expect(find.text('Password'), findsOneWidget);

        // User must NOT be automatically signed in
        expect(authStateListenable.value.isAuthenticated, isFalse);
      },
    );

    testWidgets(
      'Flow 2: Login validation rejects invalid credentials and accepts valid credentials',
      (WidgetTester tester) async {
        final storage = SessionStorage();
        final repository = AuthRepository(storage);

        // 1. Invalid credentials reject
        expect(
          () => repository.login(identifier: 'invalid_user', password: 'wrongpassword'),
          throwsA(isA<FormatException>()),
        );

        // 2. Demo credentials with wrong password reject
        expect(
          () => repository.login(identifier: 'farmer@kisan.ai', password: 'wrongpassword'),
          throwsA(isA<FormatException>()),
        );

        // 3. Demo credentials with valid password succeed
        final result = await repository.login(
          identifier: 'farmer@kisan.ai',
          password: 'kisan123',
        );
        expect(result.user.fullName, equals('Rajesh Sharma'));
        expect(result.profile, isNotNull);
        expect(await storage.hasActiveSession(), isTrue);
      },
    );

    testWidgets(
      'Flow 3: Home -> Module -> Back -> Home maintains authenticated session',
      (WidgetTester tester) async {
        final storage = SessionStorage();
        const user = UserModel(
          id: 'farmer_sample_3210',
          fullName: 'Rajesh Sharma',
          phoneNumber: '9876543210',
          email: 'farmer@kisan.ai',
        );
        const profile = FarmerProfile(
          userId: 'farmer_sample_3210',
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

        await storage.saveRegisteredAccount(user: user, password: 'kisan123');
        await storage.saveUser(user);
        await storage.saveProfile(profile);
        await storage.saveToken('kisan_sess_test');

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

        // 1. App is on Home/Dashboard
        appRouter.go('/dashboard');
        await tester.pumpAndSettle();
        expect(find.textContaining('Rajesh'), findsWidgets);

        // 2. Open Weather module
        appRouter.go('/weather');
        await tester.pumpAndSettle();
        expect(find.text('Agronomy Weather & Rain'), findsOneWidget);

        // 3. Press Back button in AppBar
        final backButton = find.byIcon(Icons.arrow_back);
        expect(backButton, findsOneWidget);
        await tester.tap(backButton);
        await tester.pumpAndSettle();

        // 4. Must return to Home/Dashboard, NOT public landing page!
        expect(find.textContaining('Rajesh'), findsWidgets);
        expect(find.textContaining('Smarter Decisions'), findsNothing);
        expect(authStateListenable.value.isAuthenticated, isTrue);

        // 5. Open Crop Recommendation module
        appRouter.go('/crop-recommendation');
        await tester.pumpAndSettle();
        expect(find.text('Recommendation'), findsOneWidget);

        // Press Back button in AppBar
        final cropBackButton = find.byIcon(Icons.arrow_back);
        expect(cropBackButton, findsOneWidget);
        await tester.tap(cropBackButton);
        await tester.pumpAndSettle();

        // Returns to Home/Dashboard
        expect(find.textContaining('Rajesh'), findsWidgets);
        expect(authStateListenable.value.isAuthenticated, isTrue);
      },
    );

    testWidgets(
      'Flow 4: Navigating to public landing page while authenticated preserves auth state',
      (WidgetTester tester) async {
        final storage = SessionStorage();
        const user = UserModel(
          id: 'farmer_sample_3210',
          fullName: 'Rajesh Sharma',
          phoneNumber: '9876543210',
          email: 'farmer@kisan.ai',
        );
        const profile = FarmerProfile(
          userId: 'farmer_sample_3210',
          location: FarmerLocation(state: 'Punjab', district: 'Ludhiana', village: 'Khanna', pincode: '141401'),
          farmDetails: FarmDetails(
            landArea: 10.0,
            areaUnit: 'Acres',
            hasSoilReport: true,
            ph: 7.0,
            nitrogen: 140,
            phosphorus: 50,
            potassium: 65,
            irrigationType: 'Canal',
            primaryCrop: 'Wheat',
            farmingExperienceYears: 15,
          ),
        );

        await storage.saveRegisteredAccount(user: user, password: 'kisan123');
        await storage.saveUser(user);
        await storage.saveProfile(profile);
        await storage.saveToken('kisan_sess_test');

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

        // Navigate to public landing page while authenticated
        appRouter.go('/');
        await tester.pumpAndSettle();

        // Must still be authenticated
        expect(authStateListenable.value.isAuthenticated, isTrue);

        // Shows Sign Out and Dashboard buttons, NOT Sign In
        expect(find.text('Sign Out'), findsOneWidget);
        expect(find.widgetWithText(ElevatedButton, 'Dashboard'), findsOneWidget);
        expect(find.widgetWithText(TextButton, 'Sign In'), findsNothing);

        // Tap Dashboard to return to Home
        await tester.tap(find.widgetWithText(ElevatedButton, 'Dashboard'));
        await tester.pumpAndSettle();

        expect(find.textContaining('Rajesh'), findsWidgets);
        expect(authStateListenable.value.isAuthenticated, isTrue);
      },
    );

    testWidgets(
      'Flow 5: Explicit Sign Out clears session and returns to login/landing',
      (WidgetTester tester) async {
        final storage = SessionStorage();
        const user = UserModel(
          id: 'farmer_sample_3210',
          fullName: 'Rajesh Sharma',
          phoneNumber: '9876543210',
        );

        await storage.saveUser(user);
        await storage.saveToken('test_token');

        expect(await storage.hasActiveSession(), isTrue);

        final repository = AuthRepository(storage);
        await repository.logout();

        // Session token and user are cleared
        expect(await storage.hasActiveSession(), isFalse);
        expect(await storage.getToken(), isNull);
      },
    );
  });
}
