import 'dart:convert';

import 'package:vahan_setu/core/network/api_constants.dart';
import 'package:vahan_setu/core/network/custom_http_client.dart';
import 'package:vahan_setu/features/dashboard/data/dashboard_model.dart';

class DashboardRepository {
  final CustomHttpClient _httpClient;

  DashboardRepository(this._httpClient);

  Future<DashboardModel> getDashboardMetrics() async {
    final url = Uri.parse('${ApiConstants.ngrokUrl}/admin/dashboard');

    try {
      final response = await _httpClient.get(url);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Unwrap the {"success": true, "data": {...}} envelope
        if (responseData['success'] == true) {
          return DashboardModel.fromJson(
            responseData['data'] as Map<String, dynamic>,
          );
        }

        throw Exception(
          responseData['message'] ?? 'Failed to fetch dashboard metrics',
        );
      }

      throw Exception(
        responseData['message'] ??
            'Failed to fetch dashboard metrics: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
