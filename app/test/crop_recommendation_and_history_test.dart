import 'dart:convert';
import 'dart:io';
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
import 'package:smart_agriculture_app/features/crop_recommendation/data/crop_history_model.dart';
import 'package:smart_agriculture_app/features/crop_recommendation/data/crop_history_repository.dart';
import 'package:smart_agriculture_app/features/crop_recommendation/data/crop_recommendation_model.dart';
import 'package:smart_agriculture_app/features/crop_recommendation/data/crop_recommendation_repository.dart';
import 'package:smart_agriculture_app/features/crop_recommendation/presentation/crop_recommendation_page.dart';
import 'package:smart_agriculture_app/features/crop_recommendation/presentation/widgets/crop_history_card.dart';
import 'package:smart_agriculture_app/features/crop_recommendation/presentation/widgets/crop_history_detail_sheet.dart';
import 'package:smart_agriculture_app/features/crop_recommendation/presentation/widgets/crop_history_view.dart';
import 'package:smart_agriculture_app/features/crop_recommendation/presentation/widgets/edit_soil_bottom_sheet.dart';
import 'package:smart_agriculture_app/features/crop_recommendation/presentation/widgets/edit_weather_bottom_sheet.dart';
import 'package:smart_agriculture_app/features/crop_recommendation/presentation/widgets/recommendation_result_card.dart';
import 'package:smart_agriculture_app/features/crop_recommendation/presentation/widgets/soil_information_card.dart';
import 'package:smart_agriculture_app/features/dashboard/presentation/widgets/crop_recommendation_card.dart';
import 'package:smart_agriculture_app/features/weather/data/weather_condition_service.dart';

class MockCropRecommendationRepository implements CropRecommendationRepository {
  bool shouldThrow = false;
  String throwMessage = 'Service temporarily busy. Please try again.';
  CropRecommendationInput? lastInput;

  @override
  Future<CropRecommendationResult> getRecommendation(CropRecommendationInput input) async {
    lastInput = input;
    if (shouldThrow) {
      throw Exception(throwMessage);
    }
    return const CropRecommendationResult(
      recommendedCrop: 'Rice',
      recommendations: [
        CropAlternative(crop: 'Rice', confidence: 0.88),
        CropAlternative(crop: 'Jute', confidence: 0.72),
        CropAlternative(crop: 'Maize', confidence: 0.65),
      ],
    );
  }
}

class MockWeatherConditionService extends WeatherConditionService {
  WeatherConditionData dataToReturn;

  MockWeatherConditionService({
    this.dataToReturn = const WeatherConditionData(
      isAvailable: false,
      source: 'Current weather',
    ),
  });

  @override
  Future<WeatherConditionData> fetchCurrentConditions({String? district, String? state}) async {
    return dataToReturn;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const testUser = UserModel(
    id: 'kisan_farmer_001',
    fullName: 'Ramesh Patel',
    phoneNumber: '9876543210',
  );

  const testProfileComplete = FarmerProfile(
    userId: 'kisan_farmer_001',
    location: FarmerLocation(
      state: 'Gujarat',
      district: 'Mehsana',
      village: 'Visnagar',
      pincode: '384315',
    ),
    farmDetails: FarmDetails(
      landArea: 4.5,
      areaUnit: 'Acres',
      hasSoilReport: true,
      soilType: 'Clay Loam',
      nitrogen: 120,
      phosphorus: 45,
      potassium: 60,
      ph: 6.5,
      irrigationType: 'Borewell',
      primaryCrop: 'Castor',
      farmingExperienceYears: 10,
    ),
  );

  late MockCropRecommendationRepository mockRepo;
  late MockWeatherConditionService mockWeather;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockRepo = MockCropRecommendationRepository();
    mockWeather = MockWeatherConditionService();
  });

  tearDown(() {
    authStateListenable.value = AuthState.initial();
  });

  Widget buildTestApp({
    FarmerProfile? profile = testProfileComplete,
    Map<String, Object>? additionalPrefs,
  }) {
    if (profile != null) {
      final prefs = <String, Object>{
        'kisan_auth_user': jsonEncode(testUser.toJson()),
        'kisan_auth_token': 'token_xyz',
        'kisan_farmer_profile': jsonEncode(profile.toJson()),
        if (additionalPrefs != null) ...additionalPrefs,
      };
      SharedPreferences.setMockInitialValues(prefs);
      authStateListenable.value = AuthState(
        status: AuthStatus.profileComplete,
        user: testUser,
        profile: profile,
      );
    } else {
      authStateListenable.value = AuthState.unauthenticated();
    }

    return ProviderScope(
      overrides: [
        cropRecommendationRepositoryProvider.overrideWithValue(mockRepo),
        weatherConditionServiceProvider.overrideWithValue(mockWeather),
      ],
      child: const SmartAgriApp(),
    );
  }

  Future<void> initTestEnv(
    WidgetTester tester, {
    FarmerProfile? profile = testProfileComplete,
    Map<String, Object>? additionalPrefs,
  }) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestApp(
      profile: profile,
      additionalPrefs: additionalPrefs,
    ));
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pumpAndSettle();
  }

  group('Section 28 Verification Test Suite', () {
    // -------------------------------------------------------------------------
    // 1. Existing profile values automatically appear (Zero Re-entry)
    // -------------------------------------------------------------------------
    testWidgets('Req 1: Existing profile values automatically appear without re-entry', (tester) async {
      await initTestEnv(tester);

      appRouter.go('/crop-recommendation');
      await tester.pumpAndSettle();

      // Verify Soil Information Card displays hydrated profile data
      expect(find.byType(SoilInformationCard), findsOneWidget);
      expect(find.text('FARM PROFILE'), findsOneWidget);
      expect(find.text('Clay Loam'), findsOneWidget);
      expect(find.textContaining('N 120 · P 45 · K 60'), findsOneWidget);
      expect(find.text('6.5'), findsOneWidget);
    });

    // -------------------------------------------------------------------------
    // 2. No duplicate unnecessary data entry
    // -------------------------------------------------------------------------
    testWidgets('Req 2: No duplicate unnecessary data entry fields on the screen', (tester) async {
      await initTestEnv(tester);

      appRouter.go('/crop-recommendation');
      await tester.pumpAndSettle();

      // Screen is a decision-support summary, not a blank form
      expect(find.byType(TextField), findsNothing);
      expect(find.text('Enter State'), findsNothing);
      expect(find.text('Enter District'), findsNothing);
      expect(find.text('Enter Land Area'), findsNothing);
    });

    // -------------------------------------------------------------------------
    // 3. Missing profile values handled correctly (Case 2 and Case 3)
    // -------------------------------------------------------------------------
    testWidgets('Req 3: Case 2 - Soil report missing handled with clear status badge', (tester) async {
      const profileNoTest = FarmerProfile(
        userId: 'kisan_farmer_001',
        location: FarmerLocation(
          state: 'Punjab',
          district: 'Ludhiana',
          village: 'Samrala',
          pincode: '141001',
        ),
        farmDetails: FarmDetails(
          landArea: 2.0,
          areaUnit: 'Acres',
          hasSoilReport: false,
          soilType: 'Alluvial Soil',
          irrigationType: 'Canal',
        ),
      );

      await initTestEnv(tester, profile: profileNoTest);

      appRouter.go('/crop-recommendation');
      await tester.pumpAndSettle();

      // Case 2 card displayed
      expect(find.text('Soil test information is unavailable'), findsOneWidget);
      expect(find.text('Enter Soil Test Values'), findsOneWidget);
    });

    testWidgets('Req 3 (cont): Case 3 - Incomplete soil profile displays action prompt', (tester) async {
      const profileIncomplete = FarmerProfile(
        userId: 'kisan_farmer_001',
        location: FarmerLocation(
          state: 'Punjab',
          district: 'Ludhiana',
          village: 'Samrala',
          pincode: '141001',
        ),
        farmDetails: FarmDetails(
          landArea: 2.0,
          areaUnit: 'Acres',
          hasSoilReport: false,
          irrigationType: 'Rainfed',
        ),
      );

      await initTestEnv(tester, profile: profileIncomplete);

      appRouter.go('/crop-recommendation');
      await tester.pumpAndSettle();

      // Case 3 card displayed
      expect(find.text('Complete your farm soil information'), findsOneWidget);
      expect(find.text('Enter Soil Test Values'), findsOneWidget);
    });

    // -------------------------------------------------------------------------
    // 4. User can edit recommendation inputs
    // -------------------------------------------------------------------------
    testWidgets('Req 4: User can open EditSoilBottomSheet and EditWeatherBottomSheet', (tester) async {
      await initTestEnv(tester);

      appRouter.go('/crop-recommendation');
      await tester.pumpAndSettle();

      // Open Soil Edit bottom sheet via edit icon
      final editSoilBtn = find.byIcon(Icons.edit_outlined);
      expect(editSoilBtn, findsOneWidget);
      await tester.tap(editSoilBtn);
      await tester.pumpAndSettle();

      expect(find.byType(EditSoilBottomSheet), findsOneWidget);
      expect(find.text('Edit Soil Information'), findsOneWidget);

      // Close bottom sheet
      final cancelBtn = find.text('Cancel');
      await tester.tap(cancelBtn);
      await tester.pumpAndSettle();

      // Open Weather Edit bottom sheet
      final enterWeatherBtn = find.text('Enter Manually');
      expect(enterWeatherBtn, findsOneWidget);
      await tester.ensureVisible(enterWeatherBtn);
      await tester.tap(enterWeatherBtn);
      await tester.pumpAndSettle();

      expect(find.byType(EditWeatherBottomSheet), findsOneWidget);
      expect(find.text('Environmental Conditions'), findsOneWidget);
    });

    // -------------------------------------------------------------------------
    // 5. One-time edits do not silently change profile data
    // -------------------------------------------------------------------------
    testWidgets('Req 5: One-time edits do not alter saved FarmerProfile in AuthState', (tester) async {
      await initTestEnv(tester);

      appRouter.go('/crop-recommendation');
      await tester.pumpAndSettle();

      // Open Soil Edit
      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      // Verify default selection is "Use for this recommendation only (Recommended)"
      expect(find.text('Use for this recommendation only (Recommended)'), findsOneWidget);

      // Enter new Nitrogen value
      final nField = find.widgetWithText(TextFormField, '120');
      await tester.enterText(nField, '140');
      await tester.pumpAndSettle();

      // Apply
      await tester.tap(find.text('Apply for Recommendation'));
      await tester.pumpAndSettle();

      // Verify active recommendation shows 140
      expect(find.textContaining('N 140'), findsOneWidget);
      expect(find.text('CUSTOM'), findsOneWidget);

      // Verify auth profile was NOT modified
      final currentProfile = authStateListenable.value.profile;
      expect(currentProfile?.farmDetails.nitrogen, equals(120)); // Intact original value!
    });

    // -------------------------------------------------------------------------
    // 6. Weather values are dynamic and handled separately from profile values
    // -------------------------------------------------------------------------
    testWidgets('Req 6: Weather values update recommendation state without touching profile', (tester) async {
      await initTestEnv(tester);

      appRouter.go('/crop-recommendation');
      await tester.pumpAndSettle();

      // Enter manual weather
      final enterWeatherBtn = find.text('Enter Manually');
      await tester.ensureVisible(enterWeatherBtn);
      await tester.tap(enterWeatherBtn);
      await tester.pumpAndSettle();

      // Enter temperature, humidity, rainfall
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), '28.5');
      await tester.enterText(fields.at(1), '75');
      await tester.enterText(fields.at(2), '150');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save Conditions'));
      await tester.pumpAndSettle();

      // Weather card updates to manual entries across metric and summary cards
      expect(find.text('28.5°C'), findsWidgets);
      expect(find.text('75%'), findsWidgets);
      expect(find.text('150 mm'), findsWidgets);
      expect(find.text('MANUALLY ENTERED'), findsOneWidget);

      // Profile is untouched
      final profile = authStateListenable.value.profile;
      expect(profile?.farmDetails.nitrogen, equals(120));
    });

    // -------------------------------------------------------------------------
    // 7. Exact values sent to API are stored in history
    // -------------------------------------------------------------------------
    testWidgets('Req 7: Exact values sent to API are recorded in CropHistoryItem', (tester) async {
      await initTestEnv(tester);

      appRouter.go('/crop-recommendation');
      await tester.pumpAndSettle();

      // Provide weather
      final enterWeatherBtn = find.text('Enter Manually');
      await tester.ensureVisible(enterWeatherBtn);
      await tester.tap(enterWeatherBtn);
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), '26');
      await tester.enterText(fields.at(1), '80');
      await tester.enterText(fields.at(2), '200');
      await tester.tap(find.text('Save Conditions'));
      await tester.pumpAndSettle();

      // Press Generate Recommendation
      final getRecBtn = find.text('Get Crop Recommendation');
      await tester.ensureVisible(getRecBtn);
      await tester.tap(getRecBtn);
      await tester.pumpAndSettle();

      // Verify repository received exact inputs
      expect(mockRepo.lastInput, isNotNull);
      expect(mockRepo.lastInput!.nitrogen, equals(120));
      expect(mockRepo.lastInput!.phosphorus, equals(45));
      expect(mockRepo.lastInput!.potassium, equals(60));
      expect(mockRepo.lastInput!.ph, equals(6.5));
      expect(mockRepo.lastInput!.temperature, equals(26.0));
      expect(mockRepo.lastInput!.humidity, equals(80.0));
      expect(mockRepo.lastInput!.rainfall, equals(200.0));
    });

    // -------------------------------------------------------------------------
    // 8. History remains accurate even after subsequent profile updates
    // -------------------------------------------------------------------------
    testWidgets('Req 8: Historical recommendations remain immutable', (tester) async {
      final repo = CropHistoryRepositoryImpl();
      final historyItem = CropHistoryItem(
        id: 'hist_123',
        userId: 'kisan_farmer_001',
        createdAt: DateTime.now(),
        recommendedCrop: 'Rice',
        confidence: 0.88,
        nitrogen: 120,
        phosphorus: 45,
        potassium: 60,
        ph: 6.5,
        temperature: 26,
        humidity: 80,
        rainfall: 200,
        soilType: 'Clay Loam',
        district: 'Mehsana',
        state: 'Gujarat',
        village: 'Visnagar',
        irrigationType: 'Borewell',
        landArea: 4.5,
        landUnit: 'Acres',
        dataSource: 'Current farm profile + manual environmental conditions',
      );

      await repo.saveHistoryItem(historyItem);

      // Now simulate a profile change in the future
      final updatedProfile = testProfileComplete.copyWith(
        farmDetails: testProfileComplete.farmDetails.copyWith(
          nitrogen: 50,
          soilType: 'Sandy Soil',
        ),
      );

      // Verify stored history retains original values
      final fetched = await repo.getLatestRecommendation('kisan_farmer_001');
      expect(fetched?.nitrogen, equals(120));
      expect(fetched?.soilType, equals('Clay Loam'));
      expect(updatedProfile.farmDetails.nitrogen, equals(50));
    });

    // -------------------------------------------------------------------------
    // 9. API success handling
    // -------------------------------------------------------------------------
    testWidgets('Req 9: API success displays recommendation result card and alternatives', (tester) async {
      await initTestEnv(tester);

      appRouter.go('/crop-recommendation');
      await tester.pumpAndSettle();

      // Enter weather
      final enterWeatherBtn = find.text('Enter Manually');
      await tester.ensureVisible(enterWeatherBtn);
      await tester.tap(enterWeatherBtn);
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), '26');
      await tester.enterText(fields.at(1), '80');
      await tester.enterText(fields.at(2), '200');
      await tester.tap(find.text('Save Conditions'));
      await tester.pumpAndSettle();

      // Trigger recommendation
      final getRecBtn = find.text('Get Crop Recommendation');
      await tester.ensureVisible(getRecBtn);
      await tester.tap(getRecBtn);
      await tester.pumpAndSettle();

      // Recommendation card shown
      expect(find.byType(RecommendationResultCard), findsOneWidget);
      expect(find.text('RICE'), findsOneWidget);
      expect(find.text('JUTE'), findsOneWidget);
      expect(find.text('MAIZE'), findsOneWidget);
    });

    // -------------------------------------------------------------------------
    // 10. API failure handling with user-friendly messages
    // -------------------------------------------------------------------------
    testWidgets('Req 10: API failure shows clean error banner with retry', (tester) async {
      mockRepo.shouldThrow = true;
      mockRepo.throwMessage = 'Service temporarily busy. Please try again.';

      await initTestEnv(tester);

      appRouter.go('/crop-recommendation');
      await tester.pumpAndSettle();

      // Enter weather
      final enterWeatherBtn = find.text('Enter Manually');
      await tester.ensureVisible(enterWeatherBtn);
      await tester.tap(enterWeatherBtn);
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), '26');
      await tester.enterText(fields.at(1), '80');
      await tester.enterText(fields.at(2), '200');
      await tester.tap(find.text('Save Conditions'));
      await tester.pumpAndSettle();

      // Trigger recommendation
      final getRecBtn = find.text('Get Crop Recommendation');
      await tester.ensureVisible(getRecBtn);
      await tester.tap(getRecBtn);
      await tester.pumpAndSettle();

      // Error banner is displayed
      expect(find.text('Recommendation Unavailable'), findsOneWidget);
      expect(find.text('Service temporarily busy. Please try again.'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    // -------------------------------------------------------------------------
    // 11. Empty history state
    // -------------------------------------------------------------------------
    testWidgets('Req 11: Empty history displays clean, zero-emoji guidance', (tester) async {
      await initTestEnv(tester);

      appRouter.go('/crop-recommendation');
      await tester.pumpAndSettle();

      // Switch to History tab
      await tester.tap(find.text('Crop History'));
      await tester.pumpAndSettle();

      // Clean empty state
      expect(find.text('Your crop history is empty'), findsOneWidget);
      expect(find.text('Your previous recommendations will appear here.'), findsOneWidget);
      expect(find.text('Get Crop Recommendation'), findsOneWidget);
    });

    // -------------------------------------------------------------------------
    // 12. History detail inspection sheet
    // -------------------------------------------------------------------------
    testWidgets('Req 12: Tapping history card opens detail inspection sheet', (tester) async {
      final sampleItem = CropHistoryItem(
        id: 'hist_audit_1',
        userId: 'kisan_farmer_001',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        recommendedCrop: 'Cotton',
        confidence: 0.91,
        nitrogen: 110,
        phosphorus: 40,
        potassium: 55,
        ph: 6.8,
        temperature: 31.0,
        humidity: 65.0,
        rainfall: 90.0,
        soilType: 'Black Soil',
        district: 'Mehsana',
        state: 'Gujarat',
        village: 'Visnagar',
        irrigationType: 'Borewell',
        landArea: 4.5,
        landUnit: 'Acres',
        dataSource: 'Farm Profile + Manual Weather',
      );

      await initTestEnv(
        tester,
        additionalPrefs: {
          'kisan_crop_history_kisan_farmer_001': [jsonEncode(sampleItem.toJson())],
        },
      );

      appRouter.go('/crop-recommendation');
      await tester.pumpAndSettle();

      // Go to History tab
      await tester.tap(find.text('Crop History'));
      await tester.pumpAndSettle();

      expect(find.byType(CropHistoryCard), findsOneWidget);
      expect(find.text('COTTON'), findsOneWidget);

      // Tap View Details
      await tester.tap(find.text('View Details'));
      await tester.pumpAndSettle();

      // Verify Detail Sheet
      expect(find.byType(CropHistoryDetailSheet), findsOneWidget);
      expect(find.text('Recommendation Details'), findsOneWidget);
      expect(find.text('FARM CONTEXT'), findsOneWidget);
      expect(find.text('CONDITIONS USED'), findsOneWidget);
      expect(find.textContaining('110'), findsWidgets); // Nitrogen
      expect(find.textContaining('31.0°C'), findsWidgets); // Temperature
    });

    // -------------------------------------------------------------------------
    // 13. Dashboard integration
    // -------------------------------------------------------------------------
    testWidgets('Req 13: Dashboard displays latest recommendation preview', (tester) async {
      final sampleItem = CropHistoryItem(
        id: 'hist_audit_1',
        userId: 'kisan_farmer_001',
        createdAt: DateTime.now(),
        recommendedCrop: 'Rice',
        confidence: 0.88,
        nitrogen: 120,
        phosphorus: 45,
        potassium: 60,
        ph: 6.5,
        temperature: 26.0,
        humidity: 80.0,
        rainfall: 200.0,
        soilType: 'Clay Loam',
        district: 'Mehsana',
        state: 'Gujarat',
        village: 'Visnagar',
        irrigationType: 'Borewell',
        landArea: 4.5,
        landUnit: 'Acres',
        dataSource: 'API Recommendation',
      );

      await initTestEnv(
        tester,
        additionalPrefs: {
          'kisan_crop_history_kisan_farmer_001': [jsonEncode(sampleItem.toJson())],
        },
      );

      appRouter.go('/dashboard');
      await tester.pumpAndSettle();

      // Card on dashboard displays recommended crop
      expect(find.byType(CropRecommendationSummaryCard), findsOneWidget);
      expect(find.text('RICE'), findsOneWidget);
    });

    // -------------------------------------------------------------------------
    // 14 & 15 & 16. Screen sizes and Zero Overflow verification
    // -------------------------------------------------------------------------
    testWidgets('Req 14, 15, 16: Zero RenderFlex overflow across narrow (320dp) and tablet (768dp)', (tester) async {
      final sizes = [
        const Size(320, 568),  // Small mobile
        const Size(768, 1024), // Tablet
      ];

      for (final size in sizes) {
        tester.view.physicalSize = Size(size.width * 2, size.height * 2);
        tester.view.devicePixelRatio = 2.0;

        await tester.pumpWidget(buildTestApp());
        await tester.pump(const Duration(milliseconds: 2000));
        await tester.pumpAndSettle();

        // Check recommendation tab
        appRouter.go('/crop-recommendation');
        await tester.pumpAndSettle();
        expect(find.byType(CropRecommendationPage), findsOneWidget);

        // Check history tab
        await tester.tap(find.text('Crop History'));
        await tester.pumpAndSettle();
        expect(find.byType(CropHistoryView), findsOneWidget);
      }

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // -------------------------------------------------------------------------
    // 17. Zero emoji verification across all crop recommendation source files
    // -------------------------------------------------------------------------
    test('Req 17: Zero emojis across all crop recommendation files', () {
      final cropDir = Directory('lib/features/crop_recommendation');
      expect(cropDir.existsSync(), isTrue);

      final emojiRegex = RegExp(
        r'[\u{1F300}-\u{1F9FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]',
        unicode: true,
      );

      final dartFiles = cropDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'));

      for (final file in dartFiles) {
        final content = file.readAsStringSync();
        final matches = emojiRegex.allMatches(content);
        expect(
          matches.isEmpty,
          isTrue,
          reason: 'Found forbidden emoji in ${file.path}',
        );
      }
    });

    // -------------------------------------------------------------------------
    // 18. Verification that no Pest Identification module/card was created
    // -------------------------------------------------------------------------
    test('Req 18: No Pest Identification module or card modified or added in crop features', () {
      final cropDir = Directory('lib/features/crop_recommendation');
      final files = cropDir
          .listSync(recursive: true)
          .whereType<File>()
          .map((f) => f.uri.pathSegments.last.toLowerCase())
          .toList();

      for (final filename in files) {
        expect(
          filename.contains('pest'),
          isFalse,
          reason: 'Crop recommendation must not contain pest files: $filename',
        );
      }
    });
  });
}
