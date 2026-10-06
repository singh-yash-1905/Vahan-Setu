import 'package:vahan_setu/features/taxes/data/tax_model.dart';
import 'package:vahan_setu/features/vehicles/data/fast_tag_model.dart';
import 'package:vahan_setu/features/vehicles/data/vehicle_document_model.dart';

import '../../data/vehicle_model.dart';
import '../../data/challan_model.dart';
import '../../data/government_charge_model.dart';

abstract class VehicleState {}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehiclesLoaded extends VehicleState {
  final List<VehicleModel> vehicles;
  VehiclesLoaded(this.vehicles);
}

class VehicleDetailLoaded extends VehicleState {
  final VehicleModel vehicleDetail;
  final List<ChallanModel>? challans;
  final bool isChallansLoading;
  final FastagModel? fastag;
  final bool isFastagLoading;
  final List<GovernmentChargeModel>? governmentCharges;
  final bool isGovChargesLoading;
  final List<VehicleDocumentModel>? documents;
  final bool isDocumentsLoading;
  final bool isSpecificTaxLoading;
  final TaxModel? specificTax;
  final bool isFastagUpdating;

  VehicleDetailLoaded({
    required this.vehicleDetail,
    this.challans,
    this.isChallansLoading = false,
    this.fastag,
    this.isFastagLoading = false,
    this.governmentCharges,
    this.isGovChargesLoading = false,
    this.documents,
    this.isDocumentsLoading = false,
    this.specificTax,
    this.isSpecificTaxLoading = false,
    this.isFastagUpdating = false,
  });

  VehicleDetailLoaded copyWith({
    VehicleModel? vehicleDetail,
    List<ChallanModel>? challans,
    bool? isChallansLoading,
    FastagModel? fastag,
    bool? isFastagLoading,
    List<GovernmentChargeModel>? governmentCharges,
    bool? isGovChargesLoading,
    List<VehicleDocumentModel>? documents,
    bool? isDocumentsLoading,
    TaxModel? specificTax,
    bool? isSpecificTaxLoading,
    bool? isFastagUpdating,
  }) {
    return VehicleDetailLoaded(
      vehicleDetail: vehicleDetail ?? this.vehicleDetail,
      challans: challans ?? this.challans,
      isChallansLoading: isChallansLoading ?? this.isChallansLoading,
      fastag: fastag ?? this.fastag,
      isFastagLoading: isFastagLoading ?? this.isFastagLoading,
      governmentCharges: governmentCharges ?? this.governmentCharges,
      isGovChargesLoading: isGovChargesLoading ?? this.isGovChargesLoading,
      documents: documents ?? this.documents,
      isDocumentsLoading: isDocumentsLoading ?? this.isDocumentsLoading,
      specificTax: specificTax ?? this.specificTax,
      isSpecificTaxLoading: isSpecificTaxLoading ?? this.isSpecificTaxLoading,
      isFastagUpdating: isFastagUpdating ?? this.isFastagUpdating,
    );
  }
}

class VehicleError extends VehicleState {
  final String message;
  VehicleError(this.message);
}
