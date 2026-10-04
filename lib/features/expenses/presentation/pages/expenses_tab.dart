import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../widgets/expense_card_item.dart';
import '../widgets/expense_category_selector.dart';
import '../widgets/expense_summary_section.dart';

class ExpensesTab extends StatefulWidget {
  const ExpensesTab({super.key});

  @override
  State<ExpensesTab> createState() => _ExpensesTabState();
}

class _ExpensesTabState extends State<ExpensesTab> {
  String? _selectedCategory;

  final List<String> _categories = [
    'All',
    'tyre',
    'battery',
    'maintenance',
    'salary',
    'khuraki',
    'toll',
    'road_tax',
    'others',
  ];

  @override
  void initState() {
    super.initState();

    context.read<ExpenseBloc>().add(FetchExpenses());
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category == 'All' ? null : category;
    });

    context.read<ExpenseBloc>().add(FetchExpenses(category: _selectedCategory));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Fleet Expenses',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Financial overview
          BlocBuilder<ExpenseBloc, ExpenseState>(
            builder: (context, state) {
              num totalExpense = 0;

              if (state is ExpensesLoaded) {
                totalExpense = state.expenses.fold<num>(
                  0,
                  (sum, item) => sum + item.amount,
                );
              }

              return ExpenseSummarySection(totalExpense: totalExpense);
            },
          ),

          // Category filters
          ExpenseCategorySelector(
            categories: _categories,
            selectedCategory: _selectedCategory,
            onSelected: _filterByCategory,
          ),

          // Expense list
          Expanded(
            child: BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (context, state) {
                if (state is ExpenseLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  );
                }

                if (state is ExpenseError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ),
                  );
                }

                if (state is ExpensesLoaded) {
                  final expenses = state.expenses;

                  if (expenses.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Expenses Found',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: AppColors.accent,
                    onRefresh: () async {
                      context.read<ExpenseBloc>().add(
                        FetchExpenses(category: _selectedCategory),
                      );
                    },
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        return ExpenseCardItem(expense: expenses[index]);
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
