import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/theme/app_colors.dart';

import '../../../auth/presentation/bloc/register_bloc.dart';
import '../../../auth/presentation/bloc/register_event.dart';
import '../../../auth/presentation/bloc/register_state.dart';

import 'admin_user_profile_sheet.dart';

class AdminAppDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int destinationIndex, {int? subFilterIndex}) onNavigate;
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
    return Drawer(
      backgroundColor: AppColors.surface,
      elevation: 16,
      // Removed SafeArea here so the header color can bleed to the very top edge
      child: Column(
        children: [
          // =========================================================
          // PROFILE HEADER
          // =========================================================
          _buildProfileHeader(context),

          // =========================================================
          // HEADER DIVIDER
          // =========================================================
          Container(height: 1, color: AppColors.border.withValues(alpha: 0.65)),

          // =========================================================
          // MENU
          // =========================================================
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(10, 14, 10, 10),
              children: [
                _buildSectionTitle('MAIN'),

                _buildDrawerItem(
                  icon: Icons.dashboard_rounded,
                  title: 'Dashboard',
                  iconColor: const Color(0xFF3B82F6),
                  selected: currentIndex == 0,
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(0);
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.local_shipping_rounded,
                  title: 'Vehicles',
                  iconColor: const Color(0xFF10B981),
                  selected: currentIndex == 1,
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(1);
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.receipt_long_rounded,
                  title: 'Expenses',
                  iconColor: const Color(0xFFF59E0B),
                  selected: currentIndex == 2,
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(2);
                  },
                ),

                const SizedBox(height: 14),

                _buildSectionTitle('MANAGEMENT'),

                _buildDrawerItem(
                  icon: Icons.account_balance_wallet_rounded,
                  title: 'Taxes',
                  iconColor: const Color(0xFF8B5CF6),
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(3);
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.description_rounded,
                  title: 'Documents',
                  iconColor: const Color(0xFF06B6D4),
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(4);
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.local_shipping_rounded,
                  title: 'Tanker Reports',
                  iconColor: const Color(0xFF0EA5E9),
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(5);
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.history_rounded,
                  title: 'Audit Logs',
                  iconColor: const Color(0xFFEC4899),
                  onTap: () {
                    Navigator.pop(context);
                    onNavigate(6);
                  },
                ),

                const SizedBox(height: 14),

                _buildSectionTitle('SETTINGS'),

                _buildDrawerItem(
                  icon: Icons.person_rounded,
                  title: 'User Details',
                  iconColor: const Color(0xFF6366F1),
                  onTap: () => _openUserDetails(context),
                ),

                _buildDrawerItem(
                  icon: Icons.lock_reset_rounded,
                  title: 'Change Password',
                  iconColor: const Color(0xFFF97316),
                  onTap: () {
                    Navigator.pop(context);
                    // Keep your existing Change Password navigation here
                  },
                ),

                _buildDrawerItem(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  iconColor: AppColors.error,
                  onTap: () => _logout(context),
                ),
              ],
            ),
          ),

          // =========================================================
          // VERSION
          // =========================================================
          _buildAppVersion(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) {
        return current is AuthProfileLoaded ||
            current is AuthLoading ||
            current is AuthError;
      },
      builder: (context, state) {
        String name = 'Administrator';
        String email = 'Loading...';
        String role = 'ADMINISTRATOR';

        if (state is AuthProfileLoaded) {
          name = state.user.name.isNotEmpty ? state.user.name : 'Administrator';
          email = state.user.email.isNotEmpty ? state.user.email : 'No email';
          role = state.user.role.isNotEmpty
              ? state.user.role.toUpperCase()
              : 'ADMINISTRATOR';
        }

        return Container(
          width: double.infinity,
          // Use MediaQuery padding to clear the status bar perfectly
          padding: EdgeInsets.fromLTRB(
            18,
            MediaQuery.paddingOf(context).top + 20,
            18,
            18,
          ),
          decoration: const BoxDecoration(
            color: AppColors
                .primaryDark, // Updated to match the app theme[cite: 3]
          ),
          child: Row(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors
                        .accent, // Updated border to match dark theme[cite: 3]
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: profileImage != null
                      ? Image.file(profileImage!, fit: BoxFit.cover)
                      : const Icon(
                          Icons.person_rounded,
                          size: 34,
                          color: AppColors.primary,
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors
                            .textLight, // Updated for dark background[cite: 3]
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textLight.withValues(
                          alpha: 0.7,
                        ), // Updated for dark background[cite: 3]
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        role,
                        style: const TextStyle(
                          color: AppColors.accent, // Updated to pop on dark background[cite: 3]
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openUserDetails(BuildContext context) {
    final state = context.read<AuthBloc>().state;

    if (state is! AuthProfileLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User profile is still loading. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final user = state.user;

    // Close the drawer immediately
    Navigator.of(context).pop();

    // Show the user details as a floating dialog
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => AdminUserProfileSheet(
        user: user,
        profileImage: profileImage,
        onPickImage: onPickImage,
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
    bool selected = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        onTap: onTap,
        selected: selected,
        selectedTileColor: AppColors.primary.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: selected ? AppColors.primary : AppColors.textPrimary,
            fontSize: 14,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        trailing: selected
            ? const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.primary,
                size: 20,
              )
            : null,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    Navigator.pop(context);
    context.read<AuthBloc>().add(LogoutRequested());
  }

  Widget _buildAppVersion() {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final version = snapshot.hasData ? snapshot.data!.version : '1.0.0';
        return SafeArea(
          top: false,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.55),
                ),
              ),
            ),
            child: Text(
              'Vahan Setu  •  v$version',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }
}
