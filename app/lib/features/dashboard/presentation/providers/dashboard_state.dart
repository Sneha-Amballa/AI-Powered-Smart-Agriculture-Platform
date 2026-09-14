import '../../domain/models/dashboard_data.dart';

/// Status enum for dashboard data lifecycle.
enum DashboardStatus {
  initial,
  loading,
  success,
  error,
}

/// State representation for the Farmer Dashboard.
class DashboardState {
  final DashboardStatus status;
  final DashboardData? data;
  final String? errorMessage;
  final bool isRefreshing;

  const DashboardState({
    required this.status,
    this.data,
    this.errorMessage,
    this.isRefreshing = false,
  });

  factory DashboardState.initial() => const DashboardState(
        status: DashboardStatus.initial,
      );

  factory DashboardState.loading({DashboardData? previousData}) => DashboardState(
        status: DashboardStatus.loading,
        data: previousData,
      );

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardData? data,
    String? errorMessage,
    bool? isRefreshing,
  }) {
    return DashboardState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  bool get isLoading => status == DashboardStatus.loading && data == null;
  bool get hasData => data != null;
  bool get hasError => status == DashboardStatus.error;
}
