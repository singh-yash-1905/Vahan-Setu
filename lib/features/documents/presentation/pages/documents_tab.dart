import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';

import '../bloc/document_bloc.dart';
import '../bloc/document_event.dart';
import '../bloc/document_state.dart';

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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: _currentTabIndex,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Document Management',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textLight,
          elevation: 0,
          bottom: TabBar(
            labelColor: AppColors.accent,
            unselectedLabelColor: AppColors.textLight.withValues(alpha: 0.7),
            indicatorColor: AppColors.accent,
            indicatorWeight: 4,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'Expiring Soon'),
              Tab(text: 'Reupload Requests'),
            ],
            onTap: (index) {
              setState(() {
                _currentTabIndex = index;
              });

              if (index == 0) {
                context.read<DocumentBloc>().add(FetchExpiringDocuments());
              } else {
                context.read<DocumentBloc>().add(FetchReuploadRequests());
              }
            },
          ),
        ),
        body: BlocConsumer<DocumentBloc, DocumentState>(
          listener: (context, state) {
            if (state is DocumentActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.success,
                ),
              );
            } else if (state is DocumentError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          buildWhen: (previous, current) => current is! DocumentActionSuccess,
          builder: (context, state) {
            if (state is DocumentLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              );
            }

            if (state is DocumentsLoaded) {
              final docs = state.documents;

              if (docs.isEmpty) {
                return Center(
                  child: Text(
                    _currentTabIndex == 0
                        ? 'No documents expiring soon.'
                        : 'No pending reupload requests.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: docs.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final doc = docs[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryDark.withValues(alpha: 0.05),
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
                                '${doc.documentType.replaceAll('_', ' ')} - ${doc.vehicleNumber}',
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
                                color: AppColors.warning.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                doc.status,
                                style: const TextStyle(
                                  color: AppColors.warning,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Doc Number: ${doc.documentNumber}',
                          style: const TextStyle(color: AppColors.textPrimary),
                        ),

                        if (doc.reuploadReason != null &&
                            doc.reuploadReason!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Reason: ${doc.reuploadReason}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),

                        if (_currentTabIndex == 1) ...[
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.error,
                                ),
                                icon: const Icon(Icons.close, size: 16),
                                label: const Text('Reject'),
                                onPressed: () {
                                  context.read<DocumentBloc>().add(
                                    RejectReuploadEvent(doc.id),
                                  );
                                },
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.success,
                                  foregroundColor: Colors.white,
                                ),
                                icon: const Icon(Icons.check, size: 16),
                                label: const Text('Allow Reupload'),
                                onPressed: () {
                                  context.read<DocumentBloc>().add(
                                    AllowReuploadEvent(doc.id),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  );
                },
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
}
