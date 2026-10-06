import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vahan_setu/features/aduit_logs/presentation/widgets/user_details_bottom_sheet.dart';
import 'package:vahan_setu/features/auth/presentation/bloc/register_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/audit_log_bloc.dart';
import '../bloc/audit_log_event.dart';
import '../bloc/audit_log_state.dart';
import '../widgets/audit_log_card.dart';

class AuditLogsScreen extends StatefulWidget {
  const AuditLogsScreen({super.key});

  @override
  State<AuditLogsScreen> createState() => _AuditLogsScreenState();
}

class _AuditLogsScreenState extends State<AuditLogsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<AuditLogBloc>().add(FetchAuditLogs());
    });
  }

  void _showUserDetails(int userId) {
    debugPrint('AUDIT LOG SCREEN: Opening user details');
    debugPrint('AUDIT LOG SCREEN: User ID = $userId');

    final authBloc = context.read<AuthBloc>();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        return BlocProvider.value(
          value: authBloc,
          child: UserDetailBottomSheet(userId: userId),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Audit Logs'),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.textLight,
        elevation: 0,
      ),
      body: BlocBuilder<AuditLogBloc, AuditLogState>(
        builder: (context, state) {
          if (state is AuditLogLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }

          if (state is AuditLogError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  state.message,
                  style: const TextStyle(color: AppColors.error, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state is AuditLogsLoaded) {
            final logs = state.logs;

            if (logs.isEmpty) {
              return const Center(
                child: Text(
                  'No Audit Logs Found',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];

                return AuditLogCard(
                  log: log,
                  onTap: () {
                    _showUserDetails(log.userId);
                  },
                );
              },
            );
          }

          return const Center(
            child: Text(
              'Initializing...',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          );
        },
      ),
    );
  }
}
