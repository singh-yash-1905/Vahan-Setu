import 'dart:convert';

import 'package:vahan_setu/core/network/api_constants.dart';
import 'package:vahan_setu/core/network/custom_http_client.dart';
import 'package:vahan_setu/features/expenses/data/expense_model.dart';
import 'package:vahan_setu/features/expenses/data/financial_summary_model.dart';

class ExpenseRepository {
  final CustomHttpClient _httpClient;

  ExpenseRepository(this._httpClient);

  // --- EXISTING ENDPOINTS ---

  Future<List<ExpenseModel>> getExpenses({
    int skip = 0,
    int limit = 200,
    int? vehicleId,
    String? category,
    int? tripId,
    String? dateFrom,
  }) async {
    var url = Uri.parse('${ApiConstants.ngrokUrl}/expenses');

    final queryParams = <String, String>{
      'skip': skip.toString(),
      'limit': limit.toString(),
    };
    if (vehicleId != null) queryParams['vehicle_id'] = vehicleId.toString();
    if (category != null) queryParams['category'] = category;
    if (tripId != null) queryParams['trip_id'] = tripId.toString();
    if (dateFrom != null) queryParams['date_from'] = dateFrom;

    url = url.replace(queryParameters: queryParams);

    try {
      final response = await _httpClient.get(url);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = responseData['data'] ?? responseData;
        return data
            .map((json) => ExpenseModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      if (response.statusCode == 422) {
        throw Exception('Validation Error: ${responseData['detail']}');
      }

      throw Exception(
        responseData['message'] ??
            'Failed to fetch expenses: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<ExpenseModel> getExpenseById(int expenseId) async {
    final url = Uri.parse('${ApiConstants.ngrokUrl}/expenses/$expenseId');

    try {
      final response = await _httpClient.get(url);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            (responseData is Map &&
                responseData.containsKey('data') &&
                responseData['data'] != null)
            ? responseData['data'] as Map<String, dynamic>
            : responseData as Map<String, dynamic>;
        return ExpenseModel.fromJson(data);
      }

      if (response.statusCode == 422) {
        throw Exception('Validation Error: ${responseData['detail']}');
      }

      throw Exception(
        responseData['message'] ??
            'Failed to fetch expense details: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // --- NEW FINANCIALS ENDPOINTS ---

  Future<FinancialSummaryModel> getProfitAndLoss({
    String? dateFrom,
    String? dateTo,
    int? vehicleId,
    int? firmId,
  }) async {
    var url = Uri.parse('${ApiConstants.ngrokUrl}/financials/profit-loss');

    final queryParams = <String, String>{};
    if (dateFrom != null) queryParams['date_from'] = dateFrom;
    if (dateTo != null) queryParams['date_to'] = dateTo;
    if (vehicleId != null) queryParams['vehicle_id'] = vehicleId.toString();
    if (firmId != null) queryParams['firm_id'] = firmId.toString();

    if (queryParams.isNotEmpty) url = url.replace(queryParameters: queryParams);

    try {
      final response = await _httpClient.get(url);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = responseData['data'] ?? responseData;
        return FinancialSummaryModel.fromJson(data);
      }

      if (response.statusCode == 422) {
        throw Exception('Validation Error: ${responseData['detail']}');
      }

      throw Exception(
        responseData['message'] ??
            'Failed to fetch profit & loss: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<ExpenseModel>> getFinancialLogBook({
    String? dateFrom,
    String? dateTo,
    int? vehicleId,
    int? firmId,
  }) async {
    var url = Uri.parse('${ApiConstants.ngrokUrl}/financials/log-book');

    final queryParams = <String, String>{};
    if (dateFrom != null) queryParams['date_from'] = dateFrom;
    if (dateTo != null) queryParams['date_to'] = dateTo;
    if (vehicleId != null) queryParams['vehicle_id'] = vehicleId.toString();
    if (firmId != null) queryParams['firm_id'] = firmId.toString();

    if (queryParams.isNotEmpty) url = url.replace(queryParameters: queryParams);

    try {
      final response = await _httpClient.get(url);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = responseData['data'] ?? responseData;
        final List<dynamic> entries = data['entries'] ?? [];
        return entries
            .map((json) => ExpenseModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      if (response.statusCode == 422) {
        throw Exception('Validation Error: ${responseData['detail']}');
      }

      throw Exception(
        responseData['message'] ??
            'Failed to fetch log book: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> exportFinancialLogBook({
    String? dateFrom,
    String? dateTo,
    int? vehicleId,
    int? firmId,
  }) async {
    var url = Uri.parse('${ApiConstants.ngrokUrl}/financials/export');

    final queryParams = <String, String>{};
    if (dateFrom != null) queryParams['date_from'] = dateFrom;
    if (dateTo != null) queryParams['date_to'] = dateTo;
    if (vehicleId != null) queryParams['vehicle_id'] = vehicleId.toString();
    if (firmId != null) queryParams['firm_id'] = firmId.toString();

    if (queryParams.isNotEmpty) url = url.replace(queryParameters: queryParams);

    try {
      final response = await _httpClient.get(url);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return (responseData['data'] ?? responseData).toString();
      }

      if (response.statusCode == 422) {
        throw Exception('Validation Error: ${responseData['detail']}');
      }

      throw Exception(
        responseData['message'] ??
            'Failed to export financials: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
