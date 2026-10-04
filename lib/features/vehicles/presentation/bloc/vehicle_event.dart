abstract class VehicleEvent {}

class FetchVehicles extends VehicleEvent {}

class FetchVehicleDetails extends VehicleEvent {
  final int vehicleId;
  FetchVehicleDetails(this.vehicleId);
}

class FetchVehicleChallans extends VehicleEvent {
  final int vehicleId;
  FetchVehicleChallans(this.vehicleId);
}

class FetchVehicleFastag extends VehicleEvent {
  final int vehicleId;
  FetchVehicleFastag(this.vehicleId);
}

class FetchVehicleGovernmentCharges extends VehicleEvent {
  final int vehicleId;
  FetchVehicleGovernmentCharges(this.vehicleId);
}

class FetchVehicleDocuments extends VehicleEvent {
  final int vehicleId;
  FetchVehicleDocuments(this.vehicleId);
}

class FetchVehicleTax extends VehicleEvent {
  final int vehicleId;
  final int taxId;
  FetchVehicleTax(this.vehicleId, this.taxId);
}
