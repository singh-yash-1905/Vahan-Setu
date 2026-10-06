import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vahan_setu/features/aduit_logs/presentation/widgets/user_details_bottom_sheet.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/bloc/register_bloc.dart';
import '../bloc/audit_log_bloc.dart';
import '../bloc/audit_log_event.dart';
import '../bloc/audit_log_state.dart';
import '../widgets/audit_log_card.dart';

class AuditLogsTab extends StatefulWidget {
  const AuditLogsTab({super.key});

  @override
  State<AuditLogsTab> createState() => _AuditLogsTabState();
}

class _AuditLogsTabState extends State<AuditLogsTab> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<AuditLogBloc>().add(FetchAuditLogs());
    });
  }

  void _showUserDetails(int userId) {
    debugPrint('AUDIT LOG: Opening user details for ID: $userId');

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

  Future<void> _refreshLogs() async {
    context.read<AuditLogBloc>().add(FetchAuditLogs());
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
            return _ErrorView(message: state.message, onRetry: _refreshLogs);
          }

          if (state is AuditLogsLoaded) {
            if (state.logs.isEmpty) {
              return const _EmptyLogsView();
            }

            return RefreshIndicator(
              color: AppColors.accent,
              onRefresh: _refreshLogs,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: state.logs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final log = state.logs[index];

                  return AuditLogCard(
                    log: log,
                    onTap: () {
                      debugPrint('AUDIT LOG TAB → Opening user ${log.userId}');

                      _showUserDetails(log.userId);
                    },
                  );
                },
              ),
            );
          }

          return const _InitialView();
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 44,
            ),
            const SizedBox(height: 12),
            const Text(
              'Unable to load audit logs',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textLight,
                elevation: 0,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyLogsView extends StatelessWidget {
  const _EmptyLogsView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No Audit Logs Found',
        style: TextStyle(
          fontSize: 16,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _InitialView extends StatelessWidget {
  const _InitialView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Initializing...',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
