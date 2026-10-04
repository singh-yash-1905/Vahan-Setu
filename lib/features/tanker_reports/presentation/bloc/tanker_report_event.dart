abstract class TankerReportEvent {}

class FetchTankerReports extends TankerReportEvent {
  final int skip;
  final int limit;
  final int? month;
  final int? year;
  final int? vehicleId;

  FetchTankerReports({
    this.skip = 0,
    this.limit = 100,
    this.month,
    this.year,
    this.vehicleId,
  });
}

class FetchTankerReportDetails extends TankerReportEvent {
  final int reportId;
  FetchTankerReportDetails(this.reportId);
}

class ExportTankerReportsEvent extends TankerReportEvent {
  final int? month;
  final int? year;
  final int? vehicleId;
  final String? ulPoint;

  ExportTankerReportsEvent({
    this.month,
    this.year,
    this.vehicleId,
    this.ulPoint,
  });
}
