class GovernmentChargeModel {
  final String chargeType;
  final String state;
  final String authority;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final num amount;
  final DateTime? paymentDate;
  final DateTime? dueDate;
  final DateTime? validFrom;
  final DateTime? validUntil;
  final String? paymentReference;
  final String? notes;
  final int id;
  final int vehicleId;
  final String status;
  final String? receiptFileUrl;
  final int createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  GovernmentChargeModel({
    required this.chargeType,
    required this.state,
    required this.authority,
    this.periodStart,
    this.periodEnd,
    required this.amount,
    this.paymentDate,
    this.dueDate,
    this.validFrom,
    this.validUntil,
    this.paymentReference,
    this.notes,
    required this.id,
    required this.vehicleId,
    required this.status,
    this.receiptFileUrl,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory GovernmentChargeModel.fromJson(Map<String, dynamic> json) {
    return GovernmentChargeModel(
      chargeType: json['charge_type']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      authority: json['authority']?.toString() ?? '',
      periodStart: json['period_start'] != null
          ? DateTime.parse(json['period_start'].toString())
          : null,
      periodEnd: json['period_end'] != null
          ? DateTime.parse(json['period_end'].toString())
          : null,
      amount: json['amount'] ?? 0,
      paymentDate: json['payment_date'] != null
          ? DateTime.parse(json['payment_date'].toString())
          : null,
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'].toString())
          : null,
      validFrom: json['valid_from'] != null
          ? DateTime.parse(json['valid_from'].toString())
          : null,
      validUntil: json['valid_until'] != null
          ? DateTime.parse(json['valid_until'].toString())
          : null,
      paymentReference: json['payment_reference']?.toString(),
      notes: json['notes']?.toString(),
      id: json['id'] ?? 0,
      vehicleId: json['vehicle_id'] ?? 0,
      status: json['status']?.toString() ?? '',
      receiptFileUrl: json['receipt_file_url']?.toString(),
      createdBy: json['created_by'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'].toString())
          : null,
    );
  }
}
