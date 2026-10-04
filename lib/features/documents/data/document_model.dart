class DocumentModel {
  final String documentType;
  final String documentNumber;
  final DateTime? issueDate;
  final DateTime? expiryDate;
  final int id;
  final int vehicleId;
  final String fileName;
  final String fileUrl;
  final String mimeType;
  final int fileSize;
  final int uploadedBy;
  final String status;
  final bool canReupload;
  final bool reuploadRequested;
  final String? reuploadReason;
  final String vehicleNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  DocumentModel({
    required this.documentType,
    required this.documentNumber,
    this.issueDate,
    this.expiryDate,
    required this.id,
    required this.vehicleId,
    required this.fileName,
    required this.fileUrl,
    required this.mimeType,
    required this.fileSize,
    required this.uploadedBy,
    required this.status,
    required this.canReupload,
    required this.reuploadRequested,
    this.reuploadReason,
    required this.vehicleNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      documentType: json['document_type'] ?? '',
      documentNumber: json['document_number'] ?? '',
      issueDate: json['issue_date'] != null
          ? DateTime.parse(json['issue_date'])
          : null,
      expiryDate: json['expiry_date'] != null
          ? DateTime.parse(json['expiry_date'])
          : null,
      id: json['id'] ?? 0,
      vehicleId: json['vehicle_id'] ?? 0,
      fileName: json['file_name'] ?? '',
      fileUrl: json['file_url'] ?? '',
      mimeType: json['mime_type'] ?? '',
      fileSize: json['file_size'] ?? 0,
      uploadedBy: json['uploaded_by'] ?? 0,
      status: json['status'] ?? '',
      canReupload: json['can_reupload'] ?? false,
      reuploadRequested: json['reupload_requested'] ?? false,
      reuploadReason: json['reupload_reason'],
      vehicleNumber: json['vehicle_number'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
