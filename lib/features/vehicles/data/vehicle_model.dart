class ActiveDriver {
  final String name;
  final String email;
  final String phone;
  final String role;
  final bool isActive;
  final int id;
  final DateTime? createdAt;
  final DateTime? lastLoginAt; // Frequently null if the driver hasn't logged in

  ActiveDriver({
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.isActive,
    required this.id,
    this.createdAt,
    this.lastLoginAt,
  });

  factory ActiveDriver.fromJson(Map<String, dynamic> json) {
    return ActiveDriver(
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      isActive: json['is_active'] ?? false,
      id: json['id'] ?? 0,
      // Safely parse DateTimes only if they are not null
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : null,
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'].toString())
          : null,
    );
  }
}

class VehicleModel {
  final String vehicleNumber;
  final String vehicleClass;
  final int firmId;
  final String make;
  final String model;
  final int? manufactureYear;
  final String chassisNumber;
  final String? engineNumber;
  final String status;
  final int id;
  final String firmName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ActiveDriver? activeDriver;

  VehicleModel({
    required this.vehicleNumber,
    required this.vehicleClass,
    required this.firmId,
    required this.make,
    required this.model,
    this.manufactureYear,
    required this.chassisNumber,
    this.engineNumber,
    required this.status,
    required this.id,
    required this.firmName,
    this.createdAt,
    this.updatedAt,
    this.activeDriver,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      // Appended .toString() to safeguard against unexpected nulls from the backend
      vehicleNumber: json['vehicle_number']?.toString() ?? '',
      vehicleClass: json['vehicle_class']?.toString() ?? '',
      firmId: json['firm_id'] ?? 0,
      make: json['make']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      manufactureYear: json['manufacture_year'],
      chassisNumber: json['chassis_number']?.toString() ?? '',
      engineNumber: json['engine_number']?.toString(),
      status: json['status']?.toString() ?? '',
      id: json['id'] ?? 0,
      firmName: json['firm_name']?.toString() ?? '',
      // Safely parse DateTimes
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'].toString())
          : null,
      // Safely parse the nested object
      activeDriver: json['active_driver'] != null
          ? ActiveDriver.fromJson(json['active_driver'] as Map<String, dynamic>)
          : null,
    );
  }
}
