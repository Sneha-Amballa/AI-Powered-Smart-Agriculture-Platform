import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../authentication/domain/models/farmer_profile_model.dart';
import '../../../authentication/domain/models/user_model.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../domain/models/dashboard_data.dart';
import 'dashboard_state.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl();
});

class DashboardNotifier extends Notifier<DashboardState> {
  DashboardData? _cachedData;

  DashboardRepository get _repository => ref.read(dashboardRepositoryProvider);

  @override
  DashboardState build() {
    // Watch authState so when user logs in or updates profile, dashboard updates automatically
    final authState = ref.watch(authNotifierProvider);

    // Initial load
    Future.microtask(() {
      _loadDashboard(
        user: authState.user,
        profile: authState.profile,
      );
    });

    return DashboardState(
      status: _cachedData != null ? DashboardStatus.success : DashboardStatus.loading,
      data: _cachedData,
    );
  }

  Future<void> _loadDashboard({
    UserModel? user,
    FarmerProfile? profile,
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      state = state.copyWith(isRefreshing: true, errorMessage: null);
    } else if (state.data == null) {
      state = state.copyWith(status: DashboardStatus.loading, errorMessage: null);
    }

    try {
      final authState = ref.read(authNotifierProvider);
      final currentUser = user ?? authState.user;
      final currentProfile = profile ?? authState.profile;

      final data = await _repository.getDashboardData(
        user: currentUser,
        profile: currentProfile,
      );

      _cachedData = data;
      state = DashboardState(
        status: DashboardStatus.success,
        data: data,
        isRefreshing: false,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: state.data != null ? DashboardStatus.success : DashboardStatus.error,
        isRefreshing: false,
        errorMessage: 'Some information couldn’t be updated. Tap to retry.',
      );
    }
  }

  Future<void> refresh() async {
    await _loadDashboard(isRefresh: true);
  }

  Future<void> retry() async {
    await _loadDashboard(isRefresh: false);
  }
}

final dashboardNotifierProvider =
    NotifierProvider<DashboardNotifier, DashboardState>(DashboardNotifier.new);
