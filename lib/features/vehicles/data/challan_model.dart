class ChallanModel {
  final String challanNumber;
  final String authority;
  final String reason;
  final DateTime? issueDate; // Made nullable
  final num amount;
  final DateTime? dueDate; // Made nullable
  final DateTime? paymentDate;
  final String status;
  final String? notes;
  final int id;
  final int vehicleId;
  final String? receiptFileUrl;
  final int createdBy;
  final DateTime? createdAt; // Made nullable
  final DateTime? updatedAt; // Made nullable

  ChallanModel({
    required this.challanNumber,
    required this.authority,
    required this.reason,
    this.issueDate,
    required this.amount,
    this.dueDate,
    this.paymentDate,
    required this.status,
    this.notes,
    required this.id,
    required this.vehicleId,
    this.receiptFileUrl,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory ChallanModel.fromJson(Map<String, dynamic> json) {
    return ChallanModel(
      challanNumber: json['challan_number']?.toString() ?? '',
      authority: json['authority']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
      issueDate: json['issue_date'] != null
          ? DateTime.parse(json['issue_date'].toString())
          : null,
      amount: json['amount'] ?? 0,
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'].toString())
          : null,
      paymentDate: json['payment_date'] != null
          ? DateTime.parse(json['payment_date'].toString())
          : null,
      status: json['status']?.toString() ?? '',
      notes: json['notes']?.toString(),
      id: json['id'] ?? 0,
      vehicleId: json['vehicle_id'] ?? 0,
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
