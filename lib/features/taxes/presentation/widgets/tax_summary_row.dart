import 'package:flutter/material.dart';
import 'package:vahan_setu/features/dashboard/presentation/widgets/dashboard_metric_card.dart';

import '../../../../core/theme/app_colors.dart';

class TaxSummaryRow extends StatelessWidget {
  final num totalAmount;
  final int recordCount;
  final String filterName;

  const TaxSummaryRow({
    super.key,
    required this.totalAmount,
    required this.recordCount,
    required this.filterName,
  });

  @override
  Widget build(BuildContext context) {
    // Uses Expanded to dynamically split the screen 50/50 on any device size
    return Row(
      children: [
        Expanded(
          child: DashboardMetricCard(
            title: 'Total Amount (₹)',
            value: totalAmount,
            subtitle: 'In Current View',
            icon: Icons.account_balance_wallet_rounded,
            themeColor: AppColors.primary,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DashboardMetricCard(
            title: 'Total Records',
            value: recordCount,
            subtitle: filterName,
            icon: Icons.receipt_long_rounded,
            themeColor: AppColors.accent,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
