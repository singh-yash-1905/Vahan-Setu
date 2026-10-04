import '../../data/audit_log_model.dart';

abstract class AuditLogState {}

class AuditLogInitial extends AuditLogState {}

class AuditLogLoading extends AuditLogState {}

class AuditLogsLoaded extends AuditLogState {
  final List<AuditLogModel> logs;
  AuditLogsLoaded(this.logs);
}

class AuditLogError extends AuditLogState {
  final String message;
  AuditLogError(this.message);
}
