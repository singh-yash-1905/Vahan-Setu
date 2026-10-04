import 'package:flutter/material.dart';

import 'package:vahan_setu/features/dashboard/data/dashboard_model.dart';

import '../../../../core/theme/app_colors.dart';

import 'dashboard_metric_card.dart';
import 'dashboard_progress_card.dart';
import 'dashboard_section_header.dart';

class DashboardFleetOverview extends StatelessWidget {
  final DashboardModel metrics;
  final VoidCallback onFleetTap;

  const DashboardFleetOverview({
    super.key,
    required this.metrics,
    required this.onFleetTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DashboardSectionHeader(
          title: 'Fleet Overview',
          subtitle: 'Current fleet status',
          icon: Icons.local_shipping_rounded,
          color: AppColors.primary,
        ),

        const SizedBox(height: 12),

        LayoutBuilder(
          builder: (context, constraints) {
            final bool wide = constraints.maxWidth >= 650;

            if (wide) {
              return DashboardProgressCard(
                title: 'Active Fleet',
                current: metrics.activeVehicles,
                total: metrics.totalVehicles,
              );
            }

            return DashboardProgressCard(
              title: 'Active Fleet',
              current: metrics.activeVehicles,
              total: metrics.totalVehicles,
            );
          },
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: DashboardMetricCard(
            title: 'Total Vehicles',
            value: metrics.totalVehicles,
            subtitle: '${metrics.activeVehicles} Active Units',
            icon: Icons.directions_bus_filled_rounded,
            themeColor: AppColors.accent,
            onTap: onFleetTap,
          ),
        ),
      ],
    );
  }
}
