import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';

class TaxCardItem extends StatelessWidget {
  final dynamic tax;
  const TaxCardItem({super.key, required this.tax});

  @override
  Widget build(BuildContext context) {
    final isOverdue = tax.status.toUpperCase() == 'OVERDUE';
    final isExpired = tax.status.toUpperCase() == 'EXPIRED';

    Color badgeBg = AppColors.success.withValues(alpha: 0.1);
    Color badgeText = AppColors.success;

    if (isOverdue) {
      badgeBg = AppColors.error.withValues(alpha: 0.1);
      badgeText = AppColors.error;
    } else if (isExpired) {
      badgeBg = AppColors.warning.withValues(alpha: 0.1);
      badgeText = AppColors.warning;
    }

    final validUntilStr = tax.validUntil != null
        ? DateFormat('dd MMM yyyy').format(tax.validUntil!)
        : 'N/A';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  tax.taxType.replaceAll('_', ' ').toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tax.status,
                  style: TextStyle(
                    color: badgeText,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Authority: ${tax.taxAuthority}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '₹${tax.amount}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: badgeText == AppColors.success
                      ? AppColors.primary
                      : badgeText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vehicle ID: ${tax.vehicleId} • ${tax.state}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              Text(
                'Valid: $validUntilStr',
                style: TextStyle(
                  color:
                      (tax.validUntil != null &&
                          tax.validUntil!.isBefore(DateTime.now()))
                      ? AppColors.error
                      : AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
