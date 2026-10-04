class TankerReportModel {
  final DateTime? reportDate;
  final int vehicleId;
  final int? driverId;
  final String ulPoint;
  final num rtkm;
  final num rate;
  final num freight;
  final String pump;
  final num hsdLtr;
  final num hsdRate;
  final num hsdAmount;
  final num khuraki;
  final int id;
  final int createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String vehicleNumber;
  final String? driverName;

  TankerReportModel({
    this.reportDate,
    required this.vehicleId,
    this.driverId,
    required this.ulPoint,
    required this.rtkm,
    required this.rate,
    required this.freight,
    required this.pump,
    required this.hsdLtr,
    required this.hsdRate,
    required this.hsdAmount,
    required this.khuraki,
    required this.id,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
    required this.vehicleNumber,
    this.driverName,
  });

  factory TankerReportModel.fromJson(Map<String, dynamic> json) {
    return TankerReportModel(
      reportDate: json['report_date'] != null
          ? DateTime.parse(json['report_date'].toString())
          : null,
      vehicleId: json['vehicle_id'] ?? 0,
      driverId: json['driver_id'],
      ulPoint: json['ul_point']?.toString() ?? '',
      rtkm: json['rtkm'] ?? 0,
      rate: json['rate'] ?? 0,
      freight: json['freight'] ?? 0,
      pump: json['pump']?.toString() ?? '',
      hsdLtr: json['hsd_ltr'] ?? 0,
      hsdRate: json['hsd_rate'] ?? 0,
      hsdAmount: json['hsd_amount'] ?? 0,
      khuraki: json['khuraki'] ?? 0,
      id: json['id'] ?? 0,
      createdBy: json['created_by'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'].toString())
          : null,
      vehicleNumber: json['vehicle_number']?.toString() ?? '',
      driverName: json['driver_name']?.toString(),
    );
  }
}
