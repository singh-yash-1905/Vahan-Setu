import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/tanker_report_bloc.dart';
import '../bloc/tanker_report_event.dart';
import '../bloc/tanker_report_state.dart';
import '../widgets/tanker_summary_row.dart';
import '../widgets/tanker_report_card_item.dart';

class TankerReportsTab extends StatefulWidget {
  const TankerReportsTab({super.key});

  @override
  State<TankerReportsTab> createState() => _TankerReportsTabState();
}

class _TankerReportsTabState extends State<TankerReportsTab> {
  @override
  void initState() {
    super.initState();
    context.read<TankerReportBloc>().add(FetchTankerReports());
  }

  void _exportReports() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Generating Excel Report...'),
        backgroundColor: AppColors.accent,
        duration: Duration(seconds: 2),
      ),
    );
    context.read<TankerReportBloc>().add(ExportTankerReportsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tanker Entries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            tooltip: 'Export to Excel',
            onPressed: _exportReports,
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () =>
                context.read<TankerReportBloc>().add(FetchTankerReports()),
          ),
        ],
      ),
      body: BlocConsumer<TankerReportBloc, TankerReportState>(
        listener: (context, state) async {
          if (state is TankerReportExportSuccess) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Export successful. Opening file...'),
                backgroundColor: AppColors.success,
              ),
            );
            try {
              await OpenFilex.open(state.downloadUrl);
            } catch (_) {}
            if (context.mounted)
              context.read<TankerReportBloc>().add(FetchTankerReports());
          } else if (state is TankerReportError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        buildWhen: (previous, current) => current is! TankerReportExportSuccess,
        builder: (context, state) {
          if (state is TankerReportLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          } else if (state is TankerReportsLoaded) {
            final reports = state.reports;
            final num totalFreight = reports.fold<num>(
              0,
              (sum, item) => sum + item.freight,
            );
            final num totalHsd = reports.fold<num>(
              0,
              (sum, item) => sum + (item.hsdLtr ?? 0),
            );

            return RefreshIndicator(
              color: AppColors.accent,
              onRefresh: () async =>
                  context.read<TankerReportBloc>().add(FetchTankerReports()),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TankerSummaryRow(
                        totalFreight: totalFreight,
                        totalHsd: totalHsd,
                        recordCount: reports.length,
                      ),
                    ),
                  ),
                  reports.isEmpty
                      ? const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text(
                              'No tanker reports found.',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.all(16.0),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) =>
                                  TankerReportCardItem(report: reports[index]),
                              childCount: reports.length,
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
