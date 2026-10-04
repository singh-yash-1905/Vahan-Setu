import '../../data/tanker_report_model.dart';

abstract class TankerReportState {}

class TankerReportInitial extends TankerReportState {}

class TankerReportLoading extends TankerReportState {}

class TankerReportsLoaded extends TankerReportState {
  final List<TankerReportModel> reports;
  TankerReportsLoaded(this.reports);
}

class TankerReportDetailLoaded extends TankerReportState {
  final TankerReportModel report;
  TankerReportDetailLoaded(this.report);
}

class TankerReportExportSuccess extends TankerReportState {
  final String downloadUrl;
  TankerReportExportSuccess(this.downloadUrl);
}

class TankerReportError extends TankerReportState {
  final String message;
  TankerReportError(this.message);
}
