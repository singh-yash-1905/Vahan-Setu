import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class DocumentSummary extends StatelessWidget {
  final int currentTabIndex;
  final int total;
  final int pending;
  final int approved;

  const DocumentSummary({
    super.key,
    required this.currentTabIndex,
    required this.total,
    required this.pending,
    required this.approved,
  });

  @override
  Widget build(BuildContext context) {
    final isReupload = currentTabIndex == 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 4),
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(
              value: total,
              label: isReupload ? 'Requests' : 'Expiring',
              icon: isReupload
                  ? Icons.upload_file_rounded
                  : Icons.warning_amber_rounded,
              color: isReupload ? AppColors.warning : AppColors.error,
            ),
          ),
          _Divider(),
          Expanded(
            child: _SummaryItem(
              value: pending,
              label: 'Pending',
              icon: Icons.pending_actions_rounded,
              color: AppColors.warning,
            ),
          ),
          _Divider(),
          Expanded(
            child: _SummaryItem(
              value: approved,
              label: 'Handled',
              icon: Icons.verified_rounded,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final int value;
  final String label;
  final IconData icon;
  final Color color;

  const _SummaryItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 4),
        Text(
          '$value',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: AppColors.border.withValues(alpha: 0.5),
    );
  }
}
