import '../../data/tax_model.dart';

abstract class TaxState {}

class TaxInitial extends TaxState {}

class TaxLoading extends TaxState {}

class TaxListLoaded extends TaxState {
  final List<TaxModel> taxes;
  TaxListLoaded(this.taxes);
}

class TaxExportSuccess extends TaxState {
  final String downloadUrl;
  TaxExportSuccess(this.downloadUrl);
}

class TaxError extends TaxState {
  final String message;
  TaxError(this.message);
}
