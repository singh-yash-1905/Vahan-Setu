import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/vehicle_model.dart';
import '../bloc/vehicle_bloc.dart';
import '../bloc/vehicle_event.dart';
import '../bloc/vehicle_state.dart';

class VehicleDetailScreen extends StatefulWidget {
  final VehicleModel vehicle;

  const VehicleDetailScreen({super.key, required this.vehicle});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VehicleBloc>().add(FetchVehicleDetails(widget.vehicle.id));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            widget.vehicle.vehicleNumber,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          backgroundColor: AppColors.primaryDark,
          foregroundColor: AppColors.textLight,
          elevation: 0,
          bottom: TabBar(
            isScrollable: true,
            labelColor: AppColors.accent,
            unselectedLabelColor: AppColors.textLight.withValues(alpha: 0.7),
            indicatorColor: AppColors.accent,
            indicatorWeight: 4,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(icon: Icon(Icons.info_outline, size: 20), text: 'Details'),
              Tab(icon: Icon(Icons.toll, size: 20), text: 'Fastag'),
              Tab(icon: Icon(Icons.receipt_long, size: 20), text: 'Challans'),
              Tab(
                icon: Icon(Icons.account_balance, size: 20),
                text: 'Gov Charges',
              ),
              Tab(icon: Icon(Icons.folder_open, size: 20), text: 'Documents'),
            ],
          ),
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
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            } else if (state is VehicleDetailLoaded) {
              final details = state.vehicleDetail;

              return TabBarView(
                children: [
                  // Tab 1: Details
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 12),
                          child: Text(
                            'Vehicle Specifications',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: AppColors.border.withValues(alpha: 0.55),
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildDetailRow('Class', details.vehicleClass),
                              _buildDetailRow('Make', details.make),
                              _buildDetailRow('Model', details.model),
                              _buildDetailRow(
                                'Year',
                                details.manufactureYear?.toString() ?? 'N/A',
                              ),
                              _buildDetailRow(
                                'Chassis No.',
                                details.chassisNumber,
                              ),
                              _buildDetailRow(
                                'Engine No.',
                                details.engineNumber ?? 'N/A',
                              ),
                              _buildDetailRow(
                                'Status',
                                details.status,
                                isLast: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tab 2: Fastag
                  state.isFastagLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.accent,
                          ),
                        )
                      : state.fastag == null
                      ? const Center(
                          child: Text(
                            'No Fastag Details Found',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Replaced Heavy Gradient with Modern Tinted Card
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.cardGreenBg,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: AppColors.success.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: AppColors.success.withValues(
                                          alpha: 0.15,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.toll,
                                        color: AppColors.success,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Current Balance',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        '₹${state.fastag!.lastBalance}',
                                        style: const TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 34,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: AppColors.border.withValues(
                                      alpha: 0.55,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    _buildDetailRow(
                                      'Tag Number',
                                      state.fastag!.tagNumber,
                                    ),
                                    _buildDetailRow(
                                      'Provider',
                                      state.fastag!.tagProvider,
                                    ),
                                    _buildDetailRow(
                                      'Status',
                                      state.fastag!.tagStatus,
                                      isLast: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                  // Tab 3: Challans
                  state.isChallansLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.accent,
                          ),
                        )
                      : (state.challans == null || state.challans!.isEmpty)
                      ? const Center(
                          child: Text(
                            'No Challans Found',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.challans!.length,
                          itemBuilder: (context, index) {
                            final challan = state.challans![index];
                            return _buildModernListCard(
                              icon: Icons.receipt_long,
                              iconColor: AppColors.error,
                              title: challan.challanNumber,
                              subtitle:
                                  'Authority: ${challan.authority}\nReason: ${challan.reason}',
                              trailingValue: '₹${challan.amount}',
                              status: 'UNPAID', // Or derive from data
                              statusColor: AppColors.error,
                            );
                          },
                        ),

                  // Tab 4: Government Charges
                  state.isGovChargesLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.accent,
                          ),
                        )
                      : (state.governmentCharges == null ||
                            state.governmentCharges!.isEmpty)
                      ? const Center(
                          child: Text(
                            'No Government Charges Found',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.governmentCharges!.length,
                          itemBuilder: (context, index) {
                            final charge = state.governmentCharges![index];
                            final bool isActive =
                                charge.status.toUpperCase() == 'ACTIVE';
                            final statusColor = isActive
                                ? AppColors.success
                                : AppColors.warning;

                            return _buildModernListCard(
                              icon: Icons.account_balance,
                              iconColor: AppColors.primary,
                              title: charge.chargeType.replaceAll('_', ' '),
                              subtitle: 'Authority: ${charge.authority}',
                              trailingValue: '₹${charge.amount}',
                              status: charge.status,
                              statusColor: statusColor,
                            );
                          },
                        ),

                  // Tab 5: Documents
                  state.isDocumentsLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.accent,
                          ),
                        )
                      : (state.documents == null || state.documents!.isEmpty)
                      ? const Center(
                          child: Text(
                            'No Documents Found',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.documents!.length,
                          itemBuilder: (context, index) {
                            final doc = state.documents![index];
                            final bool isValid =
                                doc.status.toUpperCase() == 'VALID';
                            final statusColor = isValid
                                ? AppColors.success
                                : AppColors.error;

                            return _buildModernListCard(
                              icon: Icons.folder,
                              iconColor: AppColors.accentDark,
                              title: doc.documentType.replaceAll('_', ' '),
                              subtitle: 'Doc Number: ${doc.documentNumber}',
                              trailingValue: '',
                              status: doc.status,
                              statusColor: statusColor,
                            );
                          },
                        ),
                ],
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
      ),
    );
  }

  /// Perfectly balanced layout ensuring both label and value utilize Expanded proportions without spacing gaps.
  Widget _buildDetailRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Modern List Card matching the styling found in VehicleListCard
  Widget _buildModernListCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String trailingValue,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.55)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tinted Icon Container
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
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (trailingValue.isNotEmpty)
                      Text(
                        trailingValue,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: iconColor, // Use the primary theme color of the card for the value
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                // Modern Status Pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
