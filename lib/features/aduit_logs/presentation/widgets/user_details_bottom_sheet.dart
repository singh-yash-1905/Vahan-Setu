import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vahan_setu/features/auth/presentation/bloc/register_bloc.dart';
import 'package:vahan_setu/features/auth/presentation/bloc/register_event.dart';
import 'package:vahan_setu/features/auth/presentation/bloc/register_state.dart';
import 'package:vahan_setu/features/auth/presentation/widgets/user_details_card.dart';

import '../../../../core/theme/app_colors.dart';

class UserDetailBottomSheet extends StatefulWidget {
  final int userId;

  const UserDetailBottomSheet({super.key, required this.userId});

  @override
  State<UserDetailBottomSheet> createState() => _UserDetailBottomSheetState();
}

class _UserDetailBottomSheetState extends State<UserDetailBottomSheet> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<AuthBloc>().add(FetchUserByIdEvent(widget.userId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Container(
      constraints: BoxConstraints(maxHeight: screenHeight * 0.50),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 6),
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 12, 10),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'User Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  color: AppColors.textSecondary,
                  tooltip: 'Close',
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.border),

          // Content
          Flexible(
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is UserDetailLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator(color: AppColors.accent),
                    ),
                  );
                }

                if (state is UserDetailError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }

                if (state is UserDetailLoaded) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: UserDetailCard(user: state.user),
                  );
                }

                return const Center(
                  child: Text(
                    'Loading user details...',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
