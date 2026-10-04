import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vahan_setu/core/repository/expense_repo/expense_repository.dart';

import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository _repository;

  ExpenseBloc(this._repository) : super(ExpenseInitial()) {
    on<FetchExpenses>((event, emit) async {
      emit(ExpenseLoading());
      try {
        final expenses = await _repository.getExpenses(
          skip: event.skip,
          limit: event.limit,
          vehicleId: event.vehicleId,
          category: event.category,
          tripId: event.tripId,
          dateFrom: event.dateFrom,
        );
        emit(ExpensesLoaded(expenses));
      } catch (e) {
        emit(ExpenseError(e.toString()));
      }
    });

    on<FetchExpenseDetails>((event, emit) async {
      emit(ExpenseLoading());
      try {
        final expense = await _repository.getExpenseById(event.expenseId);
        emit(ExpenseDetailLoaded(expense));
      } catch (e) {
        emit(ExpenseError(e.toString()));
      }
    });
  }
}
