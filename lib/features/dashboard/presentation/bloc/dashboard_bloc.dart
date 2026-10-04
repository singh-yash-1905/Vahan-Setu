import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vahan_setu/core/repository/dashboard_repo/dashboard_repository.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repository;

  DashboardBloc(this._repository) : super(DashboardInitial()) {
    on<FetchDashboardMetrics>((event, emit) async {
      emit(DashboardLoading());
      try {
        final metrics = await _repository.getDashboardMetrics();
        emit(DashboardLoaded(metrics));
      } catch (e) {
        emit(DashboardError(e.toString()));
      }
    });
  }
}
