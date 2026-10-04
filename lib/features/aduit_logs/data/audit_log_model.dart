class AuditLogModel {
  final int id;
  final String action;
  final int entityId;
  final String entityType;
  final int userId;
  final DateTime createdAt;
  final dynamic details;

  AuditLogModel({
    required this.id,
    required this.action,
    required this.entityId,
    required this.entityType,
    required this.userId,
    required this.createdAt,
    this.details,
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) {
    return AuditLogModel(
      id: json['id'] ?? 0,
      action: json['action'] ?? '',
      entityId: json['entity_id'] ?? 0,
      entityType: json['entity_type'] ?? '',
      userId: json['user_id'] ?? 0,
      createdAt: DateTime.parse(json['created_at'].toString()),
      details: json['details'],
    );
  }
}
