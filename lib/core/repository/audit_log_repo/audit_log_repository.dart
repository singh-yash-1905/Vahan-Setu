import 'dart:convert';

import 'package:vahan_setu/core/network/api_constants.dart';
import 'package:vahan_setu/core/network/custom_http_client.dart';
import 'package:vahan_setu/features/aduit_logs/data/audit_log_model.dart';

class AuditLogRepository {
  final CustomHttpClient _httpClient;

  AuditLogRepository(this._httpClient);

  Future<List<AuditLogModel>> getAuditLogs({
    int skip = 0,
    int limit = 100,
    String? action,
  }) async {
    var url = Uri.parse('${ApiConstants.ngrokUrl}/reports/audit-logs');

    final queryParams = <String, String>{
      'skip': skip.toString(),
      'limit': limit.toString(),
    };
    if (action != null && action.isNotEmpty) {
      queryParams['action'] = action;
    }

    url = url.replace(queryParameters: queryParams);

    try {
      final response = await _httpClient.get(url);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = responseData['data'] ?? responseData;
        return data
            .map((json) => AuditLogModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      if (response.statusCode == 422) {
        throw Exception(
          'Validation Error: ${responseData['detail'] ?? 'Unprocessable Entity'}',
        );
      }

      throw Exception(
        responseData['message'] ??
            'Failed to fetch audit logs: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
