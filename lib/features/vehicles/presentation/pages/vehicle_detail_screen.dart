import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
                        const Text(
                          'Vehicle Specifications',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryDark.withValues(
                                  alpha: 0.04,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
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
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppColors.accentDark,
                                      AppColors.primary,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.accentDark.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Current Balance',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        '₹${state.fastag!.lastBalance}',
                                        style: const TextStyle(
                                          color: AppColors.textLight,
                                          fontSize: 36,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.border),
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
                            return Card(
                              color: AppColors.surface,
                              elevation: 2,
                              shadowColor: AppColors.primaryDark.withValues(
                                alpha: 0.08,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: const BorderSide(color: AppColors.border),
                              ),
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            challan.challanNumber,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '₹${challan.amount}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.error,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Authority: ${challan.authority}',
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Reason: ${challan.reason}',
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 13,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryDark.withValues(
                                      alpha: 0.05,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          charge.chargeType.replaceAll(
                                            '_',
                                            ' ',
                                          ),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isActive
                                              ? AppColors.success.withValues(
                                                  alpha: 0.1,
                                                )
                                              : AppColors.warning.withValues(
                                                  alpha: 0.1,
                                                ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          charge.status,
                                          style: TextStyle(
                                            color: isActive
                                                ? AppColors.success
                                                : AppColors.warning,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  _buildDetailRow(
                                    'Authority',
                                    charge.authority,
                                  ),
                                  _buildDetailRow(
                                    'Amount',
                                    '₹${charge.amount}',
                                    isLast: true,
                                  ),
                                ],
                              ),
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

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryDark.withValues(
                                      alpha: 0.05,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          doc.documentType.replaceAll('_', ' '),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isValid
                                              ? AppColors.success.withValues(
                                                  alpha: 0.1,
                                                )
                                              : AppColors.error.withValues(
                                                  alpha: 0.1,
                                                ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          doc.status,
                                          style: TextStyle(
                                            color: isValid
                                                ? AppColors.success
                                                : AppColors.error,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  _buildDetailRow(
                                    'Doc Number',
                                    doc.documentNumber,
                                    isLast: true,
                                  ),
                                ],
                              ),
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
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
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
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
