import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../dashboard/presentation/widgets/dashboard_metric_card.dart';

class ExpenseSummarySection extends StatelessWidget {
  final num totalExpense;

  const ExpenseSummarySection({super.key, required this.totalExpense});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Financial Overview',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Current Period',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DashboardMetricCard(
                  title: 'Total Income',
                  value: 0,
                  subtitle: 'Current Period',
                  icon: Icons.arrow_downward_rounded,
                  themeColor: Colors.green,
                  onTap: () {},
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: DashboardMetricCard(
                  title: 'Total Expenses',
                  value: totalExpense,
                  subtitle: 'Current Period',
                  icon: Icons.arrow_upward_rounded,
                  themeColor: Colors.red,
                  onTap: () {},
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: DashboardMetricCard(
                  title: 'Net Profit',
                  value: 0,
                  subtitle: 'Margin: 0%',
                  icon: Icons.account_balance_wallet_rounded,
                  themeColor: AppColors.primary,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
