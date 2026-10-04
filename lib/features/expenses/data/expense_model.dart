class ExpenseModel {
  final int vehicleId;
  final DateTime? expenseDate;
  final int? tripId;
  final String category;
  final num amount;
  final String? description;
  final String? vendorName;
  final String? receiptUrl;
  final int id;
  final String vehicleNumber;
  final String? firmName;
  final int createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ExpenseModel({
    required this.vehicleId,
    this.expenseDate,
    this.tripId,
    required this.category,
    required this.amount,
    this.description,
    this.vendorName,
    this.receiptUrl,
    required this.id,
    required this.vehicleNumber,
    this.firmName,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      vehicleId: json['vehicle_id'] ?? 0,
      expenseDate: json['expense_date'] != null
          ? DateTime.parse(json['expense_date'].toString())
          : null,
      tripId: json['trip_id'],
      category: json['category']?.toString() ?? 'unknown',
      amount: json['amount'] ?? 0,
      description: json['description']?.toString(),
      vendorName: json['vendor_name']?.toString(),
      receiptUrl: json['receipt_url']?.toString(),
      id: json['id'] ?? 0,
      vehicleNumber: json['vehicle_number']?.toString() ?? '',
      firmName: json['firm_name']?.toString(),
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
