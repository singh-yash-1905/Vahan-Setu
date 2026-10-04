import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:vahan_setu/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:vahan_setu/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:vahan_setu/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:vahan_setu/features/dashboard/presentation/widgets/dashboard_document_summary.dart';
import 'package:vahan_setu/features/dashboard/presentation/widgets/dashboard_fleet_overview.dart';
import 'package:vahan_setu/features/dashboard/presentation/widgets/dashboard_tax_summary.dart';

import '../../../../core/theme/app_colors.dart';

import '../widgets/dashboard_operations_card.dart';

class DashboardOverviewTab extends StatefulWidget {
  final void Function(int destinationIndex, {int? subFilterIndex})? onNavigate;

  const DashboardOverviewTab({super.key, this.onNavigate});

  @override
  State<DashboardOverviewTab> createState() => _DashboardOverviewTabState();
}

class _DashboardOverviewTabState extends State<DashboardOverviewTab> {
  @override
  void initState() {
    super.initState();

    context.read<DashboardBloc>().add(FetchDashboardMetrics());
  }

  void _navigate(int destinationIndex, {int? subFilterIndex}) {
    widget.onNavigate?.call(destinationIndex, subFilterIndex: subFilterIndex);
  }

  Future<void> _refreshDashboard() async {
    context.read<DashboardBloc>().add(FetchDashboardMetrics());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.accent,
        onRefresh: _refreshDashboard,
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              );
            }

            if (state is DashboardError) {
              return _buildErrorState(state.message);
            }

            if (state is DashboardLoaded) {
              return _buildDashboard(state);
            }

            return const Center(
              child: Text(
                'Initializing...',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDashboard(DashboardLoaded state) {
    final metrics = state.metrics;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth >= 850;

        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 28 : 16,
            vertical: 20,
          ),
          children: [
            _buildHeader(isWide),

            const SizedBox(height: 24),

            DashboardFleetOverview(
                  metrics: metrics,
                  onFleetTap: () => _navigate(1),
                )
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.06, end: 0, duration: 600.ms),

            const SizedBox(height: 20),

            DashboardDocumentSummary(
                  metrics: metrics,

                  // Documents → Expiring Soon
                  onExpiringTap: () => _navigate(4, subFilterIndex: 0),

                  // Documents → Reupload Requests
                  onReuploadTap: () => _navigate(4, subFilterIndex: 1),
                )
                .animate()
                .fadeIn(delay: 100.ms, duration: 600.ms)
                .slideY(begin: 0.06, end: 0, delay: 100.ms, duration: 600.ms),

            const SizedBox(height: 20),

            DashboardTaxSummary(
                  metrics: metrics,

                  // Taxes → All Taxes
                  onActiveTap: () => _navigate(3, subFilterIndex: 0),

                  // Taxes → Due Soon
                  onDueSoonTap: () => _navigate(3, subFilterIndex: 1),

                  // Taxes → Overdue
                  onOverdueTap: () => _navigate(3, subFilterIndex: 2),

                  // Taxes → Expired
                  onExpiredTap: () => _navigate(3, subFilterIndex: 3),
                )
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms)
                .slideY(begin: 0.06, end: 0, delay: 200.ms, duration: 600.ms),

            const SizedBox(height: 20),

            DashboardOperationsCard(metrics: metrics, onTap: () => _navigate(5))
                .animate()
                .fadeIn(delay: 300.ms, duration: 600.ms)
                .slideY(begin: 0.06, end: 0, delay: 300.ms, duration: 600.ms),

            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildHeader(bool isWide) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fleet Overview',
                style: TextStyle(
                  fontSize: isWide ? 28 : 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Monitor your fleet, documents, taxes and operations.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
          ),
          child: const Icon(
            Icons.analytics_rounded,
            color: AppColors.accent,
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.55,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Unable to load dashboard',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      context.read<DashboardBloc>().add(
                        FetchDashboardMetrics(),
                      );
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
