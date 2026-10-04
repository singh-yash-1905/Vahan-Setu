import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/bloc/register_bloc.dart';
import '../../../auth/presentation/bloc/register_state.dart';
import '../../../auth/presentation/pages/change_password_screen.dart';
import '../../../auth/presentation/widgets/logout_confirmation_dialog.dart';

class AdminAppDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavigate;
  final File? profileImage;
  final VoidCallback onPickImage;

  const AdminAppDrawer({
    super.key,
    required this.currentIndex,
    required this.onNavigate,
    this.profileImage,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    // Keeps the drawer comfortable on tablets while preventing
    // excessive width on larger screens.
    final drawerWidth = screenWidth < 600
        ? screenWidth * 0.82
        : 360.0.clamp(0.0, screenWidth * 0.85);

    return Drawer(
      width: drawerWidth,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(32)),
      ),
      child: Column(
        children: [
          _buildProfileHeader(context),

          Expanded(child: _buildNavigation()),

          _buildBottomActions(context),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PROFILE HEADER
  // ---------------------------------------------------------------------------

  Widget _buildProfileHeader(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) => current is AuthProfileLoaded,
      builder: (context, state) {
        String displayName = 'Fleet Administrator';
        String displayEmail = 'Fetching profile...';

        if (state is AuthProfileLoaded) {
          displayName = state.user.name;
          displayEmail = state.user.email;
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: MediaQuery.paddingOf(context).top + 24,
            bottom: 28,
            left: 24,
            right: 24,
          ),
          decoration: const BoxDecoration(
            color: AppColors.primaryDark,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(32)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileImage(),
              const SizedBox(height: 18),
              Text(
                displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  height: 1.2,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                displayEmail,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textLight.withValues(alpha: 0.72),
                  fontSize: 13,
                  height: 1.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: onPickImage,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 76,
        height: 76,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accent, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                image: profileImage != null
                    ? DecorationImage(
                        image: FileImage(profileImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: profileImage == null
                  ? const Icon(
                      Icons.person_rounded,
                      color: AppColors.primary,
                      size: 38,
                    )
                  : null,
            ),

            // Camera button
            Positioned(
              right: -1,
              bottom: -1,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryDark, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 12,
                  color: AppColors.textLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // NAVIGATION
  // ---------------------------------------------------------------------------

  Widget _buildNavigation() {
    return ListView(
      padding: const EdgeInsets.only(top: 18, bottom: 12),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildDrawerItem(
          null,
          Icons.dashboard_rounded,
          'Dashboard',
          0,
          isBottomNav: true,
        ),
        _buildDrawerItem(
          null,
          Icons.local_shipping_rounded,
          'Fleet Vehicles',
          1,
          isBottomNav: true,
        ),
        _buildDrawerItem(
          null,
          Icons.account_balance_wallet_rounded,
          'Expenses Logs',
          2,
          isBottomNav: true,
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Divider(
            height: 1,
            thickness: 1,
            color: AppColors.border.withValues(alpha: 0.5),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 24, right: 20, bottom: 8),
          child: Text(
            'COMPLIANCE & REPORTS',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.8),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
              height: 1.2,
            ),
          ),
        ),

        _buildDrawerItem(null, Icons.receipt_long_rounded, 'Tax & Charges', 3),
        _buildDrawerItem(null, Icons.folder_copy_rounded, 'Fleet Documents', 4),
        _buildDrawerItem(null, Icons.water_drop_rounded, 'Tanker Entries', 5),
      ],
    );
  }

  Widget _buildDrawerItem(
    BuildContext? context,
    IconData icon,
    String title,
    int index, {
    bool isBottomNav = false,
  }) {
    final isSelected = isBottomNav && currentIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        minVerticalPadding: 0,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        visualDensity: const VisualDensity(vertical: -1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Icon(
          icon,
          size: 23,
          color: isSelected
              ? AppColors.accent
              : AppColors.textSecondary.withValues(alpha: 0.72),
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            height: 1.2,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
            letterSpacing: 0.15,
          ),
        ),
        selected: isSelected,
        selectedTileColor: AppColors.accent.withValues(alpha: 0.12),
        hoverColor: AppColors.accent.withValues(alpha: 0.05),
        onTap: () {
          // Same navigation flow as before.
          if (context != null) {
            Navigator.pop(context);
          }
          onNavigate(index);
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BOTTOM ACTIONS
  // ---------------------------------------------------------------------------

  Widget _buildBottomActions(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildChangePasswordTile(context),
            const SizedBox(height: 2),
            _buildLogoutTile(context),
          ],
        ),
      ),
    );
  }

  Widget _buildChangePasswordTile(BuildContext context) {
    return ListTile(
      minVerticalPadding: 0,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      visualDensity: const VisualDensity(vertical: -1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      leading: const Icon(
        Icons.lock_reset_rounded,
        color: AppColors.textSecondary,
        size: 23,
      ),
      title: const Text(
        'Change Password',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      hoverColor: AppColors.primaryDark.withValues(alpha: 0.05),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
        );
      },
    );
  }

  Widget _buildLogoutTile(BuildContext context) {
    return ListTile(
      minVerticalPadding: 0,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      visualDensity: const VisualDensity(vertical: -1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      leading: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(9),
        ),
        child: const Icon(
          Icons.logout_rounded,
          color: AppColors.error,
          size: 19,
        ),
      ),
      title: const Text(
        'Logout',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: AppColors.error,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (_) => const LogoutConfirmationDialog(),
        );
      },
    );
  }
}
