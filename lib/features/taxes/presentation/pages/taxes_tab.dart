import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/tax_bloc.dart';
import '../bloc/tax_event.dart';
import '../bloc/tax_state.dart';
import '../widgets/tax_summary_row.dart';
import '../widgets/tax_filter_selector.dart';
import '../widgets/tax_card_item.dart';

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
    _selectedFilterIndex = widget.initialFilterIndex;
    _fetchDataForIndex(_selectedFilterIndex);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Fleet Taxes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () => context.read<TaxBloc>().add(ExportTaxesEvent()),
          ),
        ],
      ),
      body: BlocConsumer<TaxBloc, TaxState>(
        listener: (context, state) async {
          if (state is TaxExportSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tax report saved! Opening...')),
            );
            try {
              await OpenFilex.open(state.downloadUrl);
            } catch (_) {}
            _fetchDataForIndex(_selectedFilterIndex);
          } else if (state is TaxError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        buildWhen: (previous, current) => current is! TaxExportSuccess,
        builder: (context, state) {
          if (state is TaxLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          } else if (state is TaxListLoaded) {
            final taxes = state.taxes;
            final num totalTaxAmount = taxes.fold<num>(
              0,
              (sum, item) => sum + item.amount,
            );

            return RefreshIndicator(
              color: AppColors.accent,
              onRefresh: () async => _fetchDataForIndex(_selectedFilterIndex),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TaxSummaryRow(
                        totalAmount: totalTaxAmount,
                        recordCount: taxes.length,
                        filterName: _filters[_selectedFilterIndex],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: TaxFilterSelector(
                      filters: _filters,
                      selectedIndex: _selectedFilterIndex,
                      onSelected: (index) {
                        setState(() => _selectedFilterIndex = index);
                        _fetchDataForIndex(index);
                      },
                    ),
                  ),
                  taxes.isEmpty
                      ? SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text(
                              'No ${_filters[_selectedFilterIndex].toLowerCase()} found.',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.all(16.0),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) =>
                                  TaxCardItem(tax: taxes[index]),
                              childCount: taxes.length,
                            ),
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
}
