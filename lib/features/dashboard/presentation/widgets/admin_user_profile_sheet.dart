import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/data/user_model.dart';
import '../../../auth/presentation/widgets/user_details_card.dart';
import '../widgets/profile_image_section.dart';

class AdminUserProfileSheet extends StatelessWidget {
  final UserModel user;
  final File? profileImage;
  final VoidCallback? onPickImage;

  const AdminUserProfileSheet({
    super.key,
    required this.user,
    this.profileImage,
    this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 450),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ------------------------------------------------------------
            // DIALOG HEADER
            // ------------------------------------------------------------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'User Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textLight,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textLight,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // ------------------------------------------------------------
            // SCROLLABLE CONTENT
            // ------------------------------------------------------------
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ProfileImageSection(
                      profileImage: profileImage,
                      onChangeImage: onPickImage,
                    ),

                    const SizedBox(height: 22),

                    Text(
                      user.name.isEmpty ? 'Administrator' : user.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      user.email.isEmpty ? 'No email available' : user.email,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          user.role.isEmpty
                              ? 'ADMINISTRATOR'
                              : user.role.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.7,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      'ACCOUNT INFORMATION',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),

                    const SizedBox(height: 10),

                    UserDetailCard(user: user),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
