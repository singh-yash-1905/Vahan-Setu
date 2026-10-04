import '../../data/dashboard_model.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardModel metrics;
  DashboardLoaded(this.metrics);
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}
