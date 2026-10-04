abstract class TaxEvent {}

class FetchFleetTaxes extends TaxEvent {
  final int? vehicleId;
  final String? taxType;
  final String? state;
  final String? status;

  FetchFleetTaxes({this.vehicleId, this.taxType, this.state, this.status});
}

class FetchDueSoonTaxes extends TaxEvent {}

class FetchOverdueTaxes extends TaxEvent {}

class FetchExpiredTaxes extends TaxEvent {}

class ExportTaxesEvent extends TaxEvent {
  final int? vehicleId;
  final String? taxType;
  final String? state;
  final String? status;

  ExportTaxesEvent({this.vehicleId, this.taxType, this.state, this.status});
}
