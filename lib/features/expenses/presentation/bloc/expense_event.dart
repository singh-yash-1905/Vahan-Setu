abstract class ExpenseEvent {}

class FetchExpenses extends ExpenseEvent {
  final int skip;
  final int limit;
  final int? vehicleId;
  final String? category;
  final int? tripId;
  final String? dateFrom;

  FetchExpenses({
    this.skip = 0,
    this.limit = 200,
    this.vehicleId,
    this.category,
    this.tripId,
    this.dateFrom,
  });
}

class FetchExpenseDetails extends ExpenseEvent {
  final int expenseId;
  FetchExpenseDetails(this.expenseId);
}
