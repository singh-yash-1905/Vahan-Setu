import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:vahan_setu/features/dashboard/data/dashboard_model.dart';

import '../../../../core/theme/app_colors.dart';

import 'dashboard_section_header.dart';

class DashboardTaxSummary extends StatelessWidget {
  final DashboardModel metrics;

  final VoidCallback onActiveTap;
  final VoidCallback onDueSoonTap;
  final VoidCallback onOverdueTap;
  final VoidCallback onExpiredTap;

  const DashboardTaxSummary({
    super.key,
    required this.metrics,
    required this.onActiveTap,
    required this.onDueSoonTap,
    required this.onOverdueTap,
    required this.onExpiredTap,
  });

  @override
  Widget build(BuildContext context) {
    final total =
        metrics.activeTaxes +
        metrics.taxesDueSoon +
        metrics.taxesOverdue +
        metrics.taxesExpired;

    return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.45)),
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
                title: 'Tax Health',
                subtitle: 'Current tax compliance overview',
                icon: Icons.account_balance_rounded,
                color: AppColors.success,
              ),

              const SizedBox(height: 20),

              if (total == 0)
                const _EmptyTaxState()
              else
                Column(
                  children: [
                    _TaxBar(
                      title: 'Active',
                      value: metrics.activeTaxes,
                      total: total,
                      color: AppColors.success,
                      onTap: onActiveTap,
                    ),

                    const SizedBox(height: 14),

                    _TaxBar(
                      title: 'Due Soon',
                      value: metrics.taxesDueSoon,
                      total: total,
                      color: Colors.amber.shade800,
                      onTap: onDueSoonTap,
                    ),

                    const SizedBox(height: 14),

                    _TaxBar(
                      title: 'Overdue',
                      value: metrics.taxesOverdue,
                      total: total,
                      color: AppColors.error,
                      onTap: onOverdueTap,
                    ),

                    const SizedBox(height: 14),

                    _TaxBar(
                      title: 'Expired',
                      value: metrics.taxesExpired,
                      total: total,
                      color: Colors.deepOrange,
                      onTap: onExpiredTap,
                    ),
                  ],
                ),

              const SizedBox(height: 20),

              // Total tax records
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: onActiveTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.summarize_rounded,
                          color: AppColors.textSecondary,
                          size: 18,
                        ),

                        const SizedBox(width: 8),

                        const Expanded(
                          child: Text(
                            'Total tax records',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        Text(
                          total.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        const SizedBox(width: 6),

                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 13,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.04, end: 0, duration: 600.ms);
  }
}

class _TaxBar extends StatelessWidget {
  final String title;
  final int value;
  final int total;
  final Color color;
  final VoidCallback onTap;

  const _TaxBar({
    required this.title,
    required this.value,
    required this.total,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : (value / total).clamp(0.0, 1.0);

    final percentage = (ratio * 100).round();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              SizedBox(
                width: 70,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              const SizedBox(width: 4),

              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: ratio),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutCubic,
                    builder: (context, animatedValue, child) {
                      return LinearProgressIndicator(
                        value: animatedValue,
                        minHeight: 10,
                        backgroundColor: color.withValues(alpha: 0.08),
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 10),

              SizedBox(
                width: 42,
                child: Text(
                  '$value',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              SizedBox(
                width: 38,
                child: Text(
                  '$percentage%',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyTaxState extends StatelessWidget {
  const _EmptyTaxState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.success,
            size: 34,
          ),

          SizedBox(height: 8),

          Text(
            'No tax records available',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
