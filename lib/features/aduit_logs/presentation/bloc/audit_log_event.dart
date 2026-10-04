abstract class AuditLogEvent {}

class FetchAuditLogs extends AuditLogEvent {
  final int skip;
  final int limit;
  final String? action;

  FetchAuditLogs({this.skip = 0, this.limit = 100, this.action});
}
