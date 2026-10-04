class DashboardModel {
  final int totalVehicles;
  final int activeVehicles;
  final int totalDrivers;
  final int pendingReuploadRequests;
  final int expiredDocuments;
  final int documentsExpiringSoon;
  final int totalTankerEntriesThisMonth;
  final num totalFreightThisMonth; // Changed from int to num
  final int activeTaxes;
  final int taxesDueSoon;
  final int taxesOverdue;
  final int taxesExpired;

  DashboardModel({
    required this.totalVehicles,
    required this.activeVehicles,
    required this.totalDrivers,
    required this.pendingReuploadRequests,
    required this.expiredDocuments,
    required this.documentsExpiringSoon,
    required this.totalTankerEntriesThisMonth,
    required this.totalFreightThisMonth,
    required this.activeTaxes,
    required this.taxesDueSoon,
    required this.taxesOverdue,
    required this.taxesExpired,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalVehicles: json['total_vehicles'] ?? 0,
      activeVehicles: json['active_vehicles'] ?? 0,
      totalDrivers: json['total_drivers'] ?? 0,
      pendingReuploadRequests: json['pending_reupload_requests'] ?? 0,
      expiredDocuments: json['expired_documents'] ?? 0,
      documentsExpiringSoon: json['documents_expiring_soon'] ?? 0,
      totalTankerEntriesThisMonth: json['total_tanker_entries_this_month'] ?? 0,
      totalFreightThisMonth:
          json['total_freight_this_month'] ?? 0, // Now safely accepts decimals
      activeTaxes: json['active_taxes'] ?? 0,
      taxesDueSoon: json['taxes_due_soon'] ?? 0,
      taxesOverdue: json['taxes_overdue'] ?? 0,
      taxesExpired: json['taxes_expired'] ?? 0,
    );
  }
}
