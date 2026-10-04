import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:vahan_setu/features/dashboard/data/dashboard_model.dart';

import '../../../../core/theme/app_colors.dart';

import 'dashboard_section_header.dart';

class DashboardDocumentSummary extends StatelessWidget {
  final DashboardModel metrics;
  final VoidCallback onReuploadTap;
  final VoidCallback onExpiringTap;

  const DashboardDocumentSummary({
    super.key,
    required this.metrics,
    required this.onReuploadTap,
    required this.onExpiringTap,
  });

  @override
  Widget build(BuildContext context) {
    return _DashboardPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DashboardSectionHeader(
            title: 'Document Compliance',
            subtitle: 'Monitor document health and pending actions',
            icon: Icons.description_rounded,
            color: AppColors.warning,
          ),

          const SizedBox(height: 18),

          LayoutBuilder(
            builder: (context, constraints) {
              final bool wide = constraints.maxWidth >= 650;

              final items = [
                _DocumentStatusItem(
                  title: 'Expiring Soon',
                  value: metrics.documentsExpiringSoon,
                  subtitle: 'Next 30 days',
                  icon: Icons.schedule_rounded,
                  color: Colors.deepOrange,
                  onTap: onExpiringTap,
                ),
                _DocumentStatusItem(
                  title: 'Expired',
                  value: metrics.expiredDocuments,
                  subtitle: 'Needs attention',
                  icon: Icons.event_busy_rounded,
                  color: AppColors.error,
                  onTap: null,
                ),
                _DocumentStatusItem(
                  title: 'Re-upload',
                  value: metrics.pendingReuploadRequests,
                  subtitle: 'Awaiting action',
                  icon: Icons.upload_file_rounded,
                  color: AppColors.warning,
                  onTap: onReuploadTap,
                ),
              ];

              if (wide) {
                return Row(
                  children: [
                    Expanded(child: items[0]),
                    const SizedBox(width: 10),
                    Expanded(child: items[1]),
                    const SizedBox(width: 10),
                    Expanded(child: items[2]),
                  ],
                );
              }

              return Column(
                children: [
                  items[0],
                  const SizedBox(height: 10),
                  items[1],
                  const SizedBox(height: 10),
                  items[2],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DocumentStatusItem extends StatelessWidget {
  final String title;
  final int value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _DocumentStatusItem({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) {
      return Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
        ),
        child: content,
      );
    }

    return Material(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: content,
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideX(begin: 0.04, end: 0, duration: 500.ms);
  }
}

class _DashboardPanel extends StatelessWidget {
  final Widget child;

  const _DashboardPanel({required this.child});

  @override
  Widget build(BuildContext context) {
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
      child: child,
    );
  }
}
