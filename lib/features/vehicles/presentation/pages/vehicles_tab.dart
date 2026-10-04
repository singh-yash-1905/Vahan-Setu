import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vahan_setu/core/repository/vehicle_repo/vehicle_repository.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/vehicle_bloc.dart';
import '../bloc/vehicle_event.dart';
import '../bloc/vehicle_state.dart';
import '../widgets/vehicle_category_filter.dart';
import '../widgets/vehicle_header.dart';
import '../widgets/vehicle_list_card.dart';
import '../widgets/vehicle_stats.dart';
import 'vehicle_detail_screen.dart';

class VehiclesTab extends StatefulWidget {
  const VehiclesTab({super.key});

  @override
  State<VehiclesTab> createState() => _VehiclesTabState();
}

class _VehiclesTabState extends State<VehiclesTab> {
  String _selectedCategory = 'ALL';

  @override
  void initState() {
    super.initState();
    context.read<VehicleBloc>().add(FetchVehicles());
  }

  void _refreshVehicles() {
    context.read<VehicleBloc>().add(FetchVehicles());
  }

  void _openVehicleDetails(dynamic vehicle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<VehicleBloc>(
          create: (context) => VehicleBloc(context.read<VehicleRepository>()),
          child: VehicleDetailScreen(vehicle: vehicle),
        ),
      ),
    );
  }

  String _getVehicleCategory(dynamic vehicle) {
    final vehicleClass = vehicle.vehicleClass.toString().trim().toLowerCase();

    if (vehicleClass.contains('tanker')) {
      return 'TANKER';
    }

    if (vehicleClass.contains('trailer')) {
      return 'TRAILER';
    }

    if (vehicleClass.contains('truck')) {
      return 'TRUCK';
    }

    return 'OTHER';
  }

  List<dynamic> _getFilteredVehicles(List<dynamic> vehicles) {
    if (_selectedCategory == 'ALL') {
      return vehicles;
    }

    return vehicles.where((vehicle) {
      return _getVehicleCategory(vehicle) == _selectedCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) {
          if (state is VehicleLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }

          if (state is VehicleError) {
            return _VehicleErrorState(
              message: state.message,
              onRetry: _refreshVehicles,
            );
          }

          if (state is VehiclesLoaded) {
            return _buildContent(state.vehicles);
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

  Widget _buildContent(List<dynamic> vehicles) {
    final totalCount = vehicles.length;

    final truckCount = vehicles
        .where((vehicle) => _getVehicleCategory(vehicle) == 'TRUCK')
        .length;

    final trailerCount = vehicles
        .where((vehicle) => _getVehicleCategory(vehicle) == 'TRAILER')
        .length;

    final tankerCount = vehicles
        .where((vehicle) => _getVehicleCategory(vehicle) == 'TANKER')
        .length;

    final filteredVehicles = _getFilteredVehicles(vehicles);

    return RefreshIndicator(
      color: AppColors.accent,
      backgroundColor: AppColors.surface,
      onRefresh: () async {
        _refreshVehicles();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: VehicleHeader(onRefresh: _refreshVehicles)),

          SliverToBoxAdapter(
            child: VehicleStats(
              total: totalCount,
              truck: truckCount,
              trailer: trailerCount,
              tanker: tankerCount,
            ),
          ),

          SliverToBoxAdapter(
            child: VehicleCategoryFilter(
              selectedCategory: _selectedCategory,
              onCategoryChanged: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
          ),

          if (filteredVehicles.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: _VehicleEmptyState(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final vehicle = filteredVehicles[index];

                  return VehicleListCard(
                    vehicle: vehicle,
                    onTap: () => _openVehicleDetails(vehicle),
                  );
                }, childCount: filteredVehicles.length),
              ),
            ),
        ],
      ),
    );
  }
}

class _VehicleErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _VehicleErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 40,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load vehicles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textLight,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VehicleEmptyState extends StatelessWidget {
  const _VehicleEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_shipping_outlined,
                size: 42,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'No vehicles found',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'No vehicles are available in this category.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
