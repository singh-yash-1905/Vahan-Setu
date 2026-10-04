import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../core/theme/app_colors.dart';

import '../bloc/tax_bloc.dart';
import '../bloc/tax_event.dart';
import '../bloc/tax_state.dart';

class TaxesTab extends StatefulWidget {
  final int initialFilterIndex;

  const TaxesTab({super.key, this.initialFilterIndex = 0});

  @override
  State<TaxesTab> createState() => _TaxesTabState();
}

class _TaxesTabState extends State<TaxesTab> {
  late int _selectedFilterIndex;

  final List<String> _filters = ['All Taxes', 'Due Soon', 'Overdue', 'Expired'];

  @override
  void initState() {
    super.initState();

    _selectedFilterIndex = widget.initialFilterIndex.clamp(
      0,
      _filters.length - 1,
    );

    // Fetch the correct filter immediately
    // when TaxesTab is opened from the dashboard.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fetchDataForIndex(_selectedFilterIndex);
      }
    });
  }

  void _fetchDataForIndex(int index) {
    final bloc = context.read<TaxBloc>();

    switch (index) {
      case 0:
        bloc.add(FetchFleetTaxes());
        break;

      case 1:
        bloc.add(FetchDueSoonTaxes());
        break;

      case 2:
        bloc.add(FetchOverdueTaxes());
        break;

      case 3:
        bloc.add(FetchExpiredTaxes());
        break;
    }
  }

  void _handleExport() {
    context.read<TaxBloc>().add(ExportTaxesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Fleet Taxes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export Taxes',
            onPressed: _handleExport,
          ),
        ],
      ),
      body: Column(
        children: [
          // ------------------------------------------------------------
          // TAX FILTERS
          // ------------------------------------------------------------
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.surface,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedFilterIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_filters[index]),
                    selected: isSelected,
                    selectedColor: AppColors.accent.withValues(alpha: 0.2),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.accentDark
                          : AppColors.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      if (!selected || _selectedFilterIndex == index) {
                        return;
                      }

                      setState(() {
                        _selectedFilterIndex = index;
                      });

                      _fetchDataForIndex(index);
                    },
                  ),
                );
              },
            ),
          ),

          // ------------------------------------------------------------
          // TAX LIST
          // ------------------------------------------------------------
          Expanded(
            child: BlocConsumer<TaxBloc, TaxState>(
              listener: (context, state) async {
                if (state is TaxExportSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tax report saved! Opening...'),
                    ),
                  );

                  try {
                    final result = await OpenFilex.open(state.downloadUrl);

                    if (result.type != ResultType.done) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Could not open file: ${result.message}',
                            ),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error opening tax report.'),
                        ),
                      );
                    }
                  }

                  if (mounted) {
                    _fetchDataForIndex(_selectedFilterIndex);
                  }
                }

                if (state is TaxError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },

              buildWhen: (previous, current) {
                return current is! TaxExportSuccess;
              },

              builder: (context, state) {
                if (state is TaxLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  );
                }

                if (state is TaxListLoaded) {
                  final taxes = state.taxes;

                  if (taxes.isEmpty) {
                    return Center(
                      child: Text(
                        'No ${_filters[_selectedFilterIndex].toLowerCase()} found.',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: AppColors.accent,
                    onRefresh: () async {
                      _fetchDataForIndex(_selectedFilterIndex);
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: taxes.length,
                      itemBuilder: (context, index) {
                        final tax = taxes[index];

                        final isOverdue = tax.status.toUpperCase() == 'OVERDUE';

                        final isExpired = tax.status.toUpperCase() == 'EXPIRED';

                        Color badgeBg = AppColors.success.withValues(
                          alpha: 0.1,
                        );

                        Color badgeText = AppColors.success;

                        if (isOverdue) {
                          badgeBg = AppColors.error.withValues(alpha: 0.1);
                          badgeText = AppColors.error;
                        } else if (isExpired) {
                          badgeBg = AppColors.warning.withValues(alpha: 0.1);
                          badgeText = AppColors.warning;
                        }

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
                                children: [
                                  Expanded(
                                    child: Text(
                                      tax.taxType.replaceAll('_', ' '),
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
                                      color: badgeBg,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      tax.status,
                                      style: TextStyle(
                                        color: badgeText,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              Text(
                                'Authority: ${tax.taxAuthority} (${tax.state})',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                ),
                              ),

                              if (tax.validUntil != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    'Valid Until: ${DateFormat('dd MMM yyyy').format(tax.validUntil!)}',
                                    style: TextStyle(
                                      color:
                                          tax.validUntil!.isBefore(
                                            DateTime.now(),
                                          )
                                          ? AppColors.error
                                          : AppColors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),

                              const SizedBox(height: 12),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '₹${tax.amount}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),

                                  Text(
                                    'Vehicle ID: ${tax.vehicleId}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
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
          ),
        ],
      ),
    );
  }
}
