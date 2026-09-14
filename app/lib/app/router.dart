import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/splash/screens/splash_screen.dart';
import '../features/landing/screens/landing_screen.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/authentication/screens/login_screen.dart';
import '../features/authentication/screens/register_screen.dart';
import '../features/authentication/screens/forgot_password_screen.dart';
import '../features/authentication/screens/profile_setup_screen.dart';
import '../features/authentication/presentation/providers/auth_provider.dart';
import '../features/authentication/presentation/providers/auth_state.dart';

import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/crop_recommendation/presentation/crop_recommendation_page.dart';
import '../features/disease_detection/screens/disease_detection_screen.dart';
import '../features/weather/screens/weather_screen.dart';
import '../features/market/screens/market_screen.dart';
import '../features/market/screens/price_prediction_screen.dart';
import '../features/schemes/screens/schemes_screen.dart';
import '../features/assistant/screens/assistant_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/settings/screens/settings_screen.dart';

import '../shared/layouts/main_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Centralized GoRouter configuration with reactive route guards and session management.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  refreshListenable: authStateListenable,
  redirect: (BuildContext context, GoRouterState state) {
    final authState = authStateListenable.value;
    final location = state.matchedLocation;

    final isSplash = location == '/splash';
    final isLanding = location == '/';
    final isOnboarding = location == '/onboarding';
    final isLogin = location == '/login';
    final isRegister = location == '/register';
    final isForgotPassword = location == '/forgot-password';
    final isProfileSetup = location == '/profile-setup';

    final isPublicRoute =
        isSplash || isLanding || isOnboarding || isLogin || isRegister || isForgotPassword;

    // 1. Initializing state: allow splash or public routes during boot
    if (authState.status == AuthStatus.initial) {
      return null;
    }

    // 2. Unauthenticated: protect private routes
    if (authState.status == AuthStatus.unauthenticated) {
      if (isPublicRoute) {
        return null;
      }
      return '/login';
    }

    // 3. Authenticated but incomplete profile: enforce setup wizard
    if (authState.status == AuthStatus.profileIncomplete) {
      if (isProfileSetup || isSplash) {
        return null;
      }
      if (isLogin || isRegister || !isPublicRoute) {
        return '/profile-setup';
      }
      return null;
    }

    // 4. Authenticated with complete profile: redirect away from auth pages
    if (authState.status == AuthStatus.profileComplete) {
      if (isLogin || isRegister || isProfileSetup) {
        return '/dashboard';
      }
      return null;
    }

    return null;
  },
  routes: [
    // Splash
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // Public Landing Page
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingScreen(),
    ),

    // Onboarding
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    // Authentication Routes
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/profile-setup',
      builder: (context, state) => const ProfileSetupScreen(),
    ),


    // Main Authenticated Shell (Preserves BottomNav & Drawer)
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/crop-recommendation',
          builder: (context, state) => const CropRecommendationPage(),
        ),
        GoRoute(
          path: '/disease-detection',
          builder: (context, state) => const DiseaseDetectionScreen(),
        ),
        GoRoute(
          path: '/pest-detection',
          redirect: (context, state) => '/disease-detection',
        ),
        GoRoute(
          path: '/weather',
          builder: (context, state) => const WeatherScreen(),
        ),
        GoRoute(
          path: '/market',
          builder: (context, state) => const MarketScreen(),
        ),
        GoRoute(
          path: '/price-prediction',
          builder: (context, state) => const PricePredictionScreen(),
        ),
        GoRoute(
          path: '/government-schemes',
          builder: (context, state) => const SchemesScreen(),
        ),
        GoRoute(
          path: '/assistant',
          builder: (context, state) => const AssistantScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);
