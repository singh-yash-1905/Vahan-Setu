import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/tanker_report_model.dart';

class TankerDetailSheet extends StatelessWidget {
  final TankerReportModel report;
  const TankerDetailSheet({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              report.vehicleNumber,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryDark,
              ),
            ),
            if (report.driverName != null && report.driverName!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Driver: ${report.driverName}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            const SizedBox(height: 24),

            _buildDetailRow('UL Point', report.ulPoint, isCurrency: false),
            _buildDetailRow('Pump', report.pump, isCurrency: false),
            _buildDetailRow('RTKM', report.rtkm.toString(), isCurrency: false),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(height: 1, thickness: 1, color: AppColors.border),
            ),

            _buildDetailRow(
              'HSD Amount',
              report.hsdAmount.toString(),
              isCurrency: true,
            ),
            _buildDetailRow(
              'Khuraki',
              report.khuraki.toString(),
              isCurrency: true,
            ),

            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.3),
                ),
              ),
              child: _buildDetailRow(
                'Freight Revenue',
                report.freight.toString(),
                isCurrency: true,
                isTotal: true,
              ),
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close Details'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    required bool isCurrency,
    bool isTotal = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isTotal ? 0 : 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? AppColors.success : AppColors.textSecondary,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            isCurrency ? '₹$value' : value,
            style: TextStyle(
              fontSize: isTotal ? 20 : 15,
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.w700,
              color: isTotal ? AppColors.success : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
