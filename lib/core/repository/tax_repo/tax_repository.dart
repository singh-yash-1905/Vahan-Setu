import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:vahan_setu/core/network/api_constants.dart';
import 'package:vahan_setu/core/network/custom_http_client.dart';
import 'package:vahan_setu/features/taxes/data/tax_model.dart';

class TaxRepository {
  final CustomHttpClient _httpClient;

  TaxRepository(this._httpClient);

  Future<List<TaxModel>> getFleetTaxes({
    int? vehicleId,
    String? taxType,
    String? state,
    String? status,
  }) async {
    var url = Uri.parse('${ApiConstants.ngrokUrl}/admin/taxes');

    final queryParams = <String, String>{};

    if (vehicleId != null) {
      queryParams['vehicle_id'] = vehicleId.toString();
    }

    if (taxType != null) {
      queryParams['tax_type'] = taxType;
    }

    if (state != null) {
      queryParams['state'] = state;
    }

    if (status != null) {
      queryParams['status'] = status;
    }

    if (queryParams.isNotEmpty) {
      url = url.replace(queryParameters: queryParams);
    }

    // Passes the URL to the centralized helper method for error handling
    return _fetchTaxes(url);
  }

  Future<List<TaxModel>> getDueSoonTaxes() async {
    final url = Uri.parse('${ApiConstants.ngrokUrl}/admin/taxes/due-soon');

    return _fetchTaxes(url);
  }

  Future<List<TaxModel>> getOverdueTaxes() async {
    final url = Uri.parse('${ApiConstants.ngrokUrl}/admin/taxes/overdue');

    return _fetchTaxes(url);
  }

  Future<List<TaxModel>> getExpiredTaxes() async {
    final url = Uri.parse('${ApiConstants.ngrokUrl}/admin/taxes/expired');

    return _fetchTaxes(url);
  }

  Future<String> exportTaxes({
    int? vehicleId,
    String? taxType,
    String? state,
    String? status,
  }) async {
    var url = Uri.parse('${ApiConstants.ngrokUrl}/admin/taxes/export');

    final queryParams = <String, String>{};

    if (vehicleId != null) {
      queryParams['vehicle_id'] = vehicleId.toString();
    }

    if (taxType != null) {
      queryParams['tax_type'] = taxType;
    }

    if (state != null) {
      queryParams['state'] = state;
    }

    if (status != null) {
      queryParams['status'] = status;
    }

    if (queryParams.isNotEmpty) {
      url = url.replace(queryParameters: queryParams);
    }

    try {
      final response = await _httpClient.get(url);

      // Status Code Handling
      if (response.statusCode == 200) {
        // Handle raw binary Excel stream instead of JSON decoding
        // to prevent crashes
        final bytes = response.bodyBytes;
        final directory = await getTemporaryDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final file = File('${directory.path}/Fleet_Taxes_$timestamp.xlsx');

        await file.writeAsBytes(bytes);

        return file.path;
      }

      // If not 200, backend returns JSON error messages
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 422) {
        throw Exception('Validation Error: ${responseData['detail']}');
      }

      throw Exception('Failed to export taxes: ${response.statusCode}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // CENTRALIZED TRY-CATCH & STATUS CODE HANDLING
  Future<List<TaxModel>> _fetchTaxes(Uri url) async {
    try {
      final response = await _httpClient.get(url);
      final responseData = jsonDecode(response.body);

      // Status Code Handling
      if (response.statusCode == 200) {
        if (responseData['success'] == true) {
          final List<dynamic> data = responseData['data'] ?? [];

          return data
              .map((json) => TaxModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }

        throw Exception(responseData['message'] ?? 'Failed to fetch taxes');
      }

      if (response.statusCode == 422) {
        throw Exception('Validation Error: ${responseData['detail']}');
      }

      throw Exception(
        responseData['message'] ??
            'Failed to fetch taxes: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
