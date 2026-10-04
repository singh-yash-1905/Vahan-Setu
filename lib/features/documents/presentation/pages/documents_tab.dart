import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/document_bloc.dart';
import '../bloc/document_event.dart';
import '../bloc/document_state.dart';
import '../widgets/document_card.dart';
import '../widgets/document_header.dart';
import '../widgets/document_summary.dart';
import '../widgets/document_tab_switcher.dart';

class DocumentsTab extends StatefulWidget {
  final int initialTabIndex;

  const DocumentsTab({super.key, this.initialTabIndex = 0});

  @override
  State<DocumentsTab> createState() => _DocumentsTabState();
}

class _DocumentsTabState extends State<DocumentsTab> {
  late int _currentTabIndex;

  @override
  void initState() {
    super.initState();

    _currentTabIndex = widget.initialTabIndex.clamp(0, 1);

    _fetchCurrentTab();
  }

  void _fetchCurrentTab() {
    if (_currentTabIndex == 0) {
      context.read<DocumentBloc>().add(FetchExpiringDocuments());
    } else {
      context.read<DocumentBloc>().add(FetchReuploadRequests());
    }
  }

  void _changeTab(int index) {
    if (_currentTabIndex == index) return;

    setState(() {
      _currentTabIndex = index;
    });

    if (index == 0) {
      context.read<DocumentBloc>().add(FetchExpiringDocuments());
    } else {
      context.read<DocumentBloc>().add(FetchReuploadRequests());
    }
  }

  void _refresh() {
    _fetchCurrentTab();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<DocumentBloc, DocumentState>(
        listener: (context, state) {
          if (state is DocumentActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }

          if (state is DocumentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        buildWhen: (previous, current) {
          return current is! DocumentActionSuccess;
        },
        builder: (context, state) {
          if (state is DocumentLoading) {
            return const _DocumentLoading();
          }

          if (state is DocumentError) {
            return _DocumentError(message: state.message, onRetry: _refresh);
          }

          if (state is DocumentsLoaded) {
            return _buildContent(state.documents);
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

  Widget _buildContent(List<dynamic> documents) {
    final expiringCount = documents.length;

    final pendingReuploadCount = documents.where((doc) {
      return doc.reuploadRequested == true;
    }).length;

    final approvedCount = documents.where((doc) {
      final status = doc.status.toString().toLowerCase();
      return status.contains('approved') ||
          status.contains('active') ||
          status.contains('valid');
    }).length;

    return RefreshIndicator(
      color: AppColors.accent,
      backgroundColor: AppColors.surface,
      onRefresh: () async {
        _refresh();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: DocumentHeader(onRefresh: _refresh)),

          SliverToBoxAdapter(
            child: DocumentSummary(
              currentTabIndex: _currentTabIndex,
              total: expiringCount,
              pending: pendingReuploadCount,
              approved: approvedCount,
            ),
          ),

          SliverToBoxAdapter(
            child: DocumentTabSwitcher(
              selectedIndex: _currentTabIndex,
              onChanged: _changeTab,
            ),
          ),

          if (documents.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _DocumentEmptyState(isReuploadTab: _currentTabIndex == 1),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(14, 6, 14, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final document = documents[index];

                  return DocumentCard(
                    document: document,
                    isReuploadTab: _currentTabIndex == 1,
                  );
                }, childCount: documents.length),
              ),
            ),
        ],
      ),
    );
  }
}

class _DocumentLoading extends StatelessWidget {
  const _DocumentLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.accent),
    );
  }
}

class _DocumentError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _DocumentError({required this.message, required this.onRetry});

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
                Icons.description_outlined,
                size: 40,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load documents',
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

class _DocumentEmptyState extends StatelessWidget {
  final bool isReuploadTab;

  const _DocumentEmptyState({required this.isReuploadTab});

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
                color: AppColors.success.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isReuploadTab ? Icons.task_alt_rounded : Icons.verified_rounded,
                size: 42,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              isReuploadTab
                  ? 'No pending requests'
                  : 'No documents expiring soon',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isReuploadTab
                  ? 'All document reupload requests are handled.'
                  : 'Your fleet documents are currently up to date.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
