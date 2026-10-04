class FinancialSummaryModel {
  final String? dateFrom;
  final String? dateTo;
  final int? vehicleId;
  final int? firmId;
  final num totalIncome;
  final num totalExpenditure;
  final num netProfit;
  final num profitMarginPercent;
  final String profitStatus;
  final int totalTrips;
  final num totalRtkm;

  FinancialSummaryModel({
    this.dateFrom,
    this.dateTo,
    this.vehicleId,
    this.firmId,
    required this.totalIncome,
    required this.totalExpenditure,
    required this.netProfit,
    required this.profitMarginPercent,
    required this.profitStatus,
    required this.totalTrips,
    required this.totalRtkm,
  });

  factory FinancialSummaryModel.fromJson(Map<String, dynamic> json) {
    return FinancialSummaryModel(
      dateFrom: json['date_from']?.toString(),
      dateTo: json['date_to']?.toString(),
      vehicleId: json['vehicle_id'],
      firmId: json['firm_id'],
      totalIncome: json['total_income'] ?? 0,
      totalExpenditure: json['total_expenditure'] ?? 0,
      netProfit: json['net_profit'] ?? 0,
      profitMarginPercent:
          json['profit_margin_percent'] ?? json['profit_margin_pct'] ?? 0,
      profitStatus: json['profit_status'] ?? 'UNKNOWN',
      totalTrips: json['total_trips'] ?? 0,
      totalRtkm: json['total_rtkm'] ?? 0,
    );
  }
}
