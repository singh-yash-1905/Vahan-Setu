import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vahan_setu/core/repository/tanker_repo/tanker_report_repository.dart';

import 'tanker_report_event.dart';
import 'tanker_report_state.dart';

class TankerReportBloc extends Bloc<TankerReportEvent, TankerReportState> {
  final TankerReportRepository _repository;

  TankerReportBloc(this._repository) : super(TankerReportInitial()) {
    on<FetchTankerReports>((event, emit) async {
      emit(TankerReportLoading());
      try {
        final reports = await _repository.getTankerReports(
          skip: event.skip,
          limit: event.limit,
          month: event.month,
          year: event.year,
          vehicleId: event.vehicleId,
        );
        emit(TankerReportsLoaded(reports));
      } catch (e) {
        emit(TankerReportError(e.toString()));
      }
    });

    on<FetchTankerReportDetails>((event, emit) async {
      emit(TankerReportLoading());
      try {
        final report = await _repository.getTankerReportById(event.reportId);
        emit(TankerReportDetailLoaded(report));
      } catch (e) {
        emit(TankerReportError(e.toString()));
      }
    });

    on<ExportTankerReportsEvent>((event, emit) async {
      emit(TankerReportLoading());
      try {
        final url = await _repository.exportTankerReports(
          month: event.month,
          year: event.year,
          vehicleId: event.vehicleId,
          ulPoint: event.ulPoint,
        );
        emit(TankerReportExportSuccess(url));
      } catch (e) {
        emit(TankerReportError(e.toString()));
      }
    });
  }
}
