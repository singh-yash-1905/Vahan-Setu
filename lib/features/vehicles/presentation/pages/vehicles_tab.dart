import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vahan_setu/core/repository/vehicle_repo/vehicle_repository.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/vehicle_bloc.dart';
import '../bloc/vehicle_event.dart';
import '../bloc/vehicle_state.dart';
import 'vehicle_detail_screen.dart';

class VehiclesTab extends StatefulWidget {
  const VehiclesTab({super.key});

  @override
  State<VehiclesTab> createState() => _VehiclesTabState();
}

class _VehiclesTabState extends State<VehiclesTab> {
  String _selectedFilter = 'ALL';

  @override
  void initState() {
    super.initState();
    context.read<VehicleBloc>().add(FetchVehicles());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Fleet Vehicles',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5),
        ),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Vehicles',
            onPressed: () => context.read<VehicleBloc>().add(FetchVehicles()),
          ),
        ],
      ),
      body: BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) {
          if (state is VehicleLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          } else if (state is VehicleError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 54,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () =>
                          context.read<VehicleBloc>().add(FetchVehicles()),
                      child: const Text(
                        'Try Again',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is VehiclesLoaded) {
            final allVehicles = state.vehicles;

            // Dynamic computations directly from the API response
            final totalCount = allVehicles.length;
            final activeCount = allVehicles
                .where((v) => v.status.trim().toUpperCase() == 'ACTIVE')
                .length;
            final inactiveCount = totalCount - activeCount;

            // Apply selected filter tab
            final filteredVehicles = _selectedFilter == 'ALL'
                ? allVehicles
                : _selectedFilter == 'ACTIVE'
                ? allVehicles
                      .where((v) => v.status.trim().toUpperCase() == 'ACTIVE')
                      .toList()
                : allVehicles
                      .where((v) => v.status.trim().toUpperCase() != 'ACTIVE')
                      .toList();

            return RefreshIndicator(
              color: AppColors.accent,
              onRefresh: () async {
                context.read<VehicleBloc>().add(FetchVehicles());
              },
              child: Column(
                children: [
                  // 1. Dynamic Live Status Number Ribbon
                  _buildLiveStatusHeader(
                    total: totalCount,
                    active: activeCount,
                    inactive: inactiveCount,
                  ),

                  // 2. Interactive Vehicle Cards List
                  Expanded(
                    child: filteredVehicles.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(height: 100),
                              Center(
                                child: Text(
                                  'No vehicles found in this category.',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            itemCount: filteredVehicles.length,
                            itemBuilder: (context, index) {
                              final vehicle = filteredVehicles[index];
                              final bool isActive =
                                  vehicle.status.trim().toUpperCase() ==
                                  'ACTIVE';

                              return _buildVehicleCard(
                                context,
                                vehicle,
                                isActive,
                              );
                            },
                          ),
                  ),
                ],
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

  /// Dynamic top-level status bar displaying live API counts
  Widget _buildLiveStatusHeader({
    required int total,
    required int active,
    required int inactive,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
      child: Row(
        children: [
          _buildStatusRibbonItem(
            'ALL',
            total,
            'Total Fleet',
            AppColors.textLight,
          ),
          Container(width: 1, height: 36, color: Colors.white24),
          _buildStatusRibbonItem('ACTIVE', active, 'Active', AppColors.accent),
          Container(width: 1, height: 36, color: Colors.white24),
          _buildStatusRibbonItem(
            'INACTIVE',
            inactive,
            'Inactive/Maint.',
            AppColors.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRibbonItem(
    String key,
    int count,
    String label,
    Color accentColor,
  ) {
    final bool isSelected = _selectedFilter == key;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedFilter = key;
          });
        },
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: isSelected
                ? Border.all(
                    color: accentColor.withValues(alpha: 0.6),
                    width: 1.2,
                  )
                : Border.all(color: Colors.transparent),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: accentColor,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.textLight
                      : AppColors.textLight.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Modern custom vehicle card with routing isolation
  Widget _buildVehicleCard(
    BuildContext context,
    dynamic vehicle,
    bool isActive,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.border.withValues(alpha: 0.8)),
      ),
      color: AppColors.surface,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: AppColors.accent.withValues(alpha: 0.08),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider<VehicleBloc>(
                // Isolated BLoC state instance preventing race conditions
                create: (context) =>
                    VehicleBloc(context.read<VehicleRepository>()),
                child: VehicleDetailScreen(vehicle: vehicle),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (isActive ? AppColors.accent : AppColors.warning)
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      vehicle.vehicleClass.toString().toLowerCase().contains(
                            'tanker',
                          )
                          ? Icons.local_shipping_rounded
                          : Icons.directions_car_filled_rounded,
                      color: isActive ? AppColors.accent : AppColors.warning,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle.vehicleNumber,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                            color: AppColors.textPrimary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${vehicle.make} ${vehicle.model} • ${vehicle.vehicleClass}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.success.withValues(alpha: 0.12)
                          : AppColors.error.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive
                            ? AppColors.success.withValues(alpha: 0.3)
                            : AppColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      vehicle.status,
                      style: TextStyle(
                        color: isActive ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(height: 1, thickness: 0.8),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.business_rounded,
                          size: 15,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            vehicle.firmName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Row(
                    children: [
                      Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accent,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12,
                        color: AppColors.accent,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
