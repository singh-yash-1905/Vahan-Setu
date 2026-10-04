import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/document_bloc.dart';
import '../bloc/document_event.dart';

class DocumentCard extends StatelessWidget {
  final dynamic document;
  final bool isReuploadTab;

  const DocumentCard({
    super.key,
    required this.document,
    required this.isReuploadTab,
  });

  String _formatDocumentType(String value) {
    return value
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? ''
              : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not available';

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Color _statusColor() {
    final status = document.status.toString().toLowerCase();

    if (status.contains('expired')) {
      return AppColors.error;
    }

    if (status.contains('active') ||
        status.contains('valid') ||
        status.contains('approved')) {
      return AppColors.success;
    }

    return AppColors.warning;
  }

  IconData _documentIcon() {
    final type = document.documentType.toString().toLowerCase();

    if (type.contains('insurance')) {
      return Icons.security_rounded;
    }

    if (type.contains('permit')) {
      return Icons.assignment_rounded;
    }

    if (type.contains('fitness')) {
      return Icons.health_and_safety_rounded;
    }

    if (type.contains('pollution') || type.contains('puc')) {
      return Icons.eco_rounded;
    }

    if (type.contains('rc') || type.contains('registration')) {
      return Icons.directions_car_rounded;
    }

    if (type.contains('tax')) {
      return Icons.receipt_long_rounded;
    }

    return Icons.description_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.55)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(_documentIcon(), size: 21, color: statusColor),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDocumentType(document.documentType.toString()),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        document.vehicleNumber.toString(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _StatusBadge(
                  text: document.status.toString(),
                  color: statusColor,
                ),
              ],
            ),

            const SizedBox(height: 13),

            Container(
              height: 1,
              color: AppColors.border.withValues(alpha: 0.4),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    icon: Icons.numbers_rounded,
                    label: 'Document No.',
                    value: document.documentNumber.toString(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _InfoItem(
                    icon: Icons.event_rounded,
                    label: 'Expiry',
                    value: _formatDate(document.expiryDate),
                  ),
                ),
              ],
            ),

            if (document.reuploadReason != null &&
                document.reuploadReason.toString().trim().isNotEmpty) ...[
              const SizedBox(height: 11),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        document.reuploadReason.toString(),
                        style: const TextStyle(
                          fontSize: 11,
                          height: 1.35,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (isReuploadTab) ...[
              const SizedBox(height: 13),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<DocumentBloc>().add(
                          RejectReuploadEvent(document.id),
                        );
                      },
                      icon: const Icon(Icons.close_rounded, size: 16),
                      label: const Text('Reject'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: BorderSide(
                          color: AppColors.error.withValues(alpha: 0.35),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<DocumentBloc>().add(
                          AllowReuploadEvent(document.id),
                        );
                      },
                      icon: const Icon(Icons.check_rounded, size: 16),
                      label: const Text('Allow'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 90),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
