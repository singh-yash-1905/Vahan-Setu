import '../../data/expense_model.dart';

abstract class ExpenseState {}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpensesLoaded extends ExpenseState {
  final List<ExpenseModel> expenses;
  ExpensesLoaded(this.expenses);
}

class ExpenseDetailLoaded extends ExpenseState {
  final ExpenseModel expense;
  ExpenseDetailLoaded(this.expense);
}

class ExpenseError extends ExpenseState {
  final String message;
  ExpenseError(this.message);
}
