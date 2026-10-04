class FastagModel {
  final String tagNumber;
  final String tagProvider;
  final String tagStatus;
  final String? linkedAccountRef;
  final num lastBalance;
  final String? notes;
  final int id;
  final int vehicleId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FastagModel({
    required this.tagNumber,
    required this.tagProvider,
    required this.tagStatus,
    this.linkedAccountRef,
    required this.lastBalance,
    this.notes,
    required this.id,
    required this.vehicleId,
    this.createdAt,
    this.updatedAt,
  });

  factory FastagModel.fromJson(Map<String, dynamic> json) {
    return FastagModel(
      // Safely handle nulls from the API response
      tagNumber: json['tag_number']?.toString() ?? 'N/A',
      tagProvider: json['tag_provider']?.toString() ?? 'N/A',
      tagStatus: json['tag_status']?.toString() ?? 'INACTIVE',
      linkedAccountRef: json['linked_account_ref']?.toString(),
      lastBalance: json['last_balance'] ?? 0,
      notes: json['notes']?.toString(),
      id: json['id'] ?? 0,
      vehicleId: json['vehicle_id'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'].toString())
          : null,
    );
  }
}
