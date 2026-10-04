import 'dart:convert';

import 'package:vahan_setu/core/network/api_constants.dart';
import 'package:vahan_setu/core/network/custom_http_client.dart';
import 'package:vahan_setu/features/tanker_reports/data/tanker_report_model.dart';

import 'dart:io'; // ADD THIS

import 'package:path_provider/path_provider.dart';

class TankerReportRepository {
  final CustomHttpClient _httpClient;

  TankerReportRepository(this._httpClient);

  Future<List<TankerReportModel>> getTankerReports({
    int skip = 0,
    int limit = 100,
    int? month,
    int? year,
    int? vehicleId,
  }) async {
    var url = Uri.parse('${ApiConstants.ngrokUrl}/tanker-reports');

    final queryParams = <String, String>{
      'skip': skip.toString(),
      'limit': limit.toString(),
    };
    if (month != null) queryParams['month'] = month.toString();
    if (year != null) queryParams['year'] = year.toString();
    if (vehicleId != null) queryParams['vehicle_id'] = vehicleId.toString();

    url = url.replace(queryParameters: queryParams);

    try {
      final response = await _httpClient.get(url);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = responseData['data'] ?? responseData;
        return data
            .map(
              (json) =>
                  TankerReportModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      }

      if (response.statusCode == 422) {
        throw Exception('Validation Error: ${responseData['detail']}');
      }

      throw Exception(
        responseData['message'] ??
            'Failed to fetch tanker reports: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<TankerReportModel> getTankerReportById(int reportId) async {
    final url = Uri.parse('${ApiConstants.ngrokUrl}/tanker-reports/$reportId');

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
        return TankerReportModel.fromJson(data);
      }

      if (response.statusCode == 422) {
        throw Exception('Validation Error: ${responseData['detail']}');
      }

      throw Exception(
        responseData['message'] ??
            'Failed to fetch report details: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> exportTankerReports({
    int? month,
    int? year,
    int? vehicleId,
    String? ulPoint,
  }) async {
    var url = Uri.parse('${ApiConstants.ngrokUrl}/tanker-reports/export');

    final queryParams = <String, String>{};
    if (month != null) queryParams['month'] = month.toString();
    if (year != null) queryParams['year'] = year.toString();
    if (vehicleId != null) queryParams['vehicle_id'] = vehicleId.toString();
    if (ulPoint != null) queryParams['ul_point'] = ulPoint;

    if (queryParams.isNotEmpty) {
      url = url.replace(queryParameters: queryParams);
    }

    try {
      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        // CHANGED: Use Temporary Directory (Cache) so external Excel apps can read it
        final directory = await getTemporaryDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final file = File('${directory.path}/Tanker_Reports_$timestamp.xlsx');

        await file.writeAsBytes(bytes);

        return file.path;
      }

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 422) {
        final errorDetail = responseData is Map
            ? responseData['detail']
            : responseData;
        throw Exception('Validation Error: $errorDetail');
      }

      throw Exception('Failed to export reports: ${response.statusCode}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
