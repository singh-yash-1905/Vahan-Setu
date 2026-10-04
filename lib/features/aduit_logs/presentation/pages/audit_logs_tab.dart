import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/audit_log_bloc.dart';
import '../bloc/audit_log_event.dart';
import '../bloc/audit_log_state.dart';

class AuditLogsTab extends StatefulWidget {
  const AuditLogsTab({super.key});

  @override
  State<AuditLogsTab> createState() => _AuditLogsTabState();
}

class _AuditLogsTabState extends State<AuditLogsTab> {
  @override
  void initState() {
    super.initState();
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
          } else if (state is AuditLogError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  state.message,
                  style: const TextStyle(color: AppColors.error, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else if (state is AuditLogsLoaded) {
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

            return RefreshIndicator(
              color: AppColors.accent,
              onRefresh: () async {
                context.read<AuditLogBloc>().add(FetchAuditLogs());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  final isAuthAction =
                      log.action == 'LOGIN' || log.action == 'REGISTER';
                  final iconColor = isAuthAction
                      ? AppColors.success
                      : AppColors.primary;
                  final icon = log.action == 'LOGIN'
                      ? Icons.login_rounded
                      : log.action == 'REGISTER'
                      ? Icons.person_add_rounded
                      : Icons.history_rounded;

                  final formattedDate = DateFormat('MMM dd, yyyy - hh:mm a')
                      .format(log.createdAt.toLocal());

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                'Entity: ${log.entityType.toUpperCase()} (${log.entityId})\nUser ID: ${log.userId}',
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
                                  color: AppColors.primary.withValues(
                                    alpha: 0.08,
                                  ),
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
                  );
                },
              ),
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
