import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:vahan_setu/features/auth/data/user_model.dart';

import '../../../../core/theme/app_colors.dart';

class UserDetailCard extends StatelessWidget {
  final UserModel user;

  /// Shows the name + active/inactive header when true.
  ///
  /// Set to false when the card is being displayed inside
  /// the complete User Details profile window.
  final bool showHeader;

  const UserDetailCard({super.key, required this.user, this.showHeader = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHeader) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(width: 10),

                _buildStatusBadge(),
              ],
            ),

            const SizedBox(height: 12),
          ],

          // Show status separately when the header is hidden.
          if (!showHeader) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Account Status',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                _buildStatusBadge(),
              ],
            ),

            const Divider(height: 24, color: AppColors.border),
          ],

          _buildInfoRow(Icons.email_rounded, user.email),

          _buildInfoRow(
            Icons.phone_rounded,
            user.phone.isEmpty ? 'Not provided' : user.phone,
          ),

          _buildInfoRow(
            Icons.admin_panel_settings_rounded,
            user.role.isEmpty
                ? 'Role: Administrator'
                : 'Role: ${user.role.toUpperCase()}',
          ),

          const Divider(height: 24, color: AppColors.border),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Account Created: '
                  '${DateFormat('dd MMM yyyy, hh:mm a').format(user.createdAt.toLocal())}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.login_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  user.lastLoginAt != null
                      ? 'Last Login: '
                            '${DateFormat('dd MMM yyyy, hh:mm a').format(user.lastLoginAt!.toLocal())}'
                      : 'Last Login: Never',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: user.isActive
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        user.isActive ? 'ACTIVE' : 'INACTIVE',
        style: TextStyle(
          color: user.isActive ? AppColors.success : AppColors.error,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
