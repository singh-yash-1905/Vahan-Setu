import 'package:flutter/material.dart';
import 'package:vahan_setu/features/dashboard/presentation/widgets/dashboard_metric_card.dart';

import '../../../../core/theme/app_colors.dart';

class TankerSummaryRow extends StatelessWidget {
  final num totalFreight;
  final num totalHsd;
  final int recordCount;

  const TankerSummaryRow({
    super.key,
    required this.totalFreight,
    required this.totalHsd,
    required this.recordCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: DashboardMetricCard(
            title: 'Freight (₹)',
            value: totalFreight,
            subtitle: 'Period',
            icon: Icons.currency_rupee_rounded,
            themeColor: AppColors.success,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DashboardMetricCard(
            title: 'Fuel (L)',
            value: totalHsd,
            subtitle: 'Litres',
            icon: Icons.local_gas_station_rounded,
            themeColor: AppColors.warning,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DashboardMetricCard(
            title: 'Entries',
            value: recordCount,
            subtitle: 'Period',
            icon: Icons.receipt_long_rounded,
            themeColor: AppColors.primary,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
