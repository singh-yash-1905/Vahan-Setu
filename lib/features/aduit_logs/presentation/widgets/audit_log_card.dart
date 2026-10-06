import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/audit_log_model.dart';

class AuditLogCard extends StatelessWidget {
  final AuditLogModel log;
  final VoidCallback onTap;

  const AuditLogCard({super.key, required this.log, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isAuthAction = log.action == 'LOGIN' || log.action == 'REGISTER';

    final iconColor = isAuthAction ? AppColors.success : AppColors.warning;

    final icon = log.action == 'LOGIN'
        ? Icons.login
        : log.action == 'REGISTER'
        ? Icons.person_add
        : Icons.history;

    final formattedDate = DateFormat('MMM dd, yyyy - hh:mm a')
        .format(log.createdAt.toLocal());

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: () {
            debugPrint('AUDIT CARD TAP DETECTED');
            debugPrint('Log ID: ${log.id}');
            debugPrint('User ID: ${log.userId}');
            debugPrint('Action: ${log.action}');

            onTap();
          },
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.55),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 22, color: iconColor),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              log.action.replaceAll('_', ' '),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          Text(
                            'ID: ${log.id}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Entity: ${log.entityType.toUpperCase()} (${log.entityId})\n'
                        'User ID: ${log.userId}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
