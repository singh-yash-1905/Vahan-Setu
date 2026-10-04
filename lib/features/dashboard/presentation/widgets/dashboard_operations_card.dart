import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:vahan_setu/features/dashboard/data/dashboard_model.dart';

import '../../../../core/theme/app_colors.dart';

import 'dashboard_section_header.dart';

class DashboardOperationsCard extends StatelessWidget {
  final DashboardModel metrics;
  final VoidCallback onTap;

  const DashboardOperationsCard({
    super.key,
    required this.metrics,
    required this.onTap,
  });

  String _formatFreight(num value) {
    if (value >= 10000000) {
      return '₹${(value / 10000000).toStringAsFixed(2)} Cr';
    }

    if (value >= 100000) {
      return '₹${(value / 100000).toStringAsFixed(2)} L';
    }

    if (value >= 1000) {
      return '₹${(value / 1000).toStringAsFixed(1)} K';
    }

    return '₹${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(22),
            splashColor: AppColors.accent.withValues(alpha: 0.05),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.45),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.035),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardSectionHeader(
                    title: 'Monthly Operations',
                    subtitle: 'Current month tanker activity',
                    icon: Icons.insights_rounded,
                    color: AppColors.accent,
                  ),

                  const SizedBox(height: 18),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final bool wide = constraints.maxWidth >= 650;

                      final entries = _OperationMetric(
                        title: 'Tanker Entries',
                        value: metrics.totalTankerEntriesThisMonth.toString(),
                        subtitle: 'This month',
                        icon: Icons.local_shipping_rounded,
                        color: AppColors.primary,
                      );

                      final freight = _OperationMetric(
                        title: 'Total Freight',
                        value: _formatFreight(metrics.totalFreightThisMonth),
                        subtitle: 'This month',
                        icon: Icons.currency_rupee_rounded,
                        color: AppColors.success,
                      );

                      if (wide) {
                        return Row(
                          children: [
                            Expanded(child: entries),
                            const SizedBox(width: 12),
                            Expanded(child: freight),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          entries,
                          const SizedBox(height: 12),
                          freight,
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 14),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Open Tanker Reports',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accent,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 15,
                        color: AppColors.accent,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 550.ms)
        .scale(
          begin: const Offset(0.98, 0.98),
          end: const Offset(1, 1),
          duration: 550.ms,
        );
  }
}

class _OperationMetric extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _OperationMetric({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.6,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
