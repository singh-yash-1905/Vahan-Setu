import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vahan_setu/core/repository/audit_log_repo/audit_log_repository.dart';

import 'audit_log_event.dart';
import 'audit_log_state.dart';

class AuditLogBloc extends Bloc<AuditLogEvent, AuditLogState> {
  final AuditLogRepository _repository;

  AuditLogBloc(this._repository) : super(AuditLogInitial()) {
    on<FetchAuditLogs>((event, emit) async {
      emit(AuditLogLoading());
      try {
        final logs = await _repository.getAuditLogs(
          skip: event.skip,
          limit: event.limit,
          action: event.action,
        );
        emit(AuditLogsLoaded(logs));
      } catch (e) {
        emit(AuditLogError(e.toString()));
      }
    });
  }
}
