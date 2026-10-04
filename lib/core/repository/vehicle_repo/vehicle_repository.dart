import 'dart:convert';

import 'package:vahan_setu/core/network/api_constants.dart';
import 'package:vahan_setu/core/network/custom_http_client.dart';
import 'package:vahan_setu/features/taxes/data/tax_model.dart';
import 'package:vahan_setu/features/vehicles/data/fast_tag_model.dart';

import '../../../features/vehicles/data/vehicle_model.dart';
import '../../../features/vehicles/data/challan_model.dart';
import '../../../features/vehicles/data/government_charge_model.dart';
import '../../../features/vehicles/data/vehicle_document_model.dart';

class VehicleRepository {
  final CustomHttpClient _httpClient;

  VehicleRepository(this._httpClient);

  Future<List<VehicleModel>> getVehicles() async {
    final url = Uri.parse('${ApiConstants.ngrokUrl}/vehicles')
        .replace(queryParameters: {'skip': '0', 'limit': '100'});

    try {
      final response = await _httpClient.get(url);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = responseData['data'] ?? responseData;
        return data
            .map((json) => VehicleModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      if (response.statusCode == 422) {
        throw Exception(
          'Validation Error: ${responseData['detail'] ?? 'Unprocessable Entity'}',
        );
      }

      throw Exception(
        responseData['message'] ??
            'Failed to fetch vehicles: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<VehicleModel> getVehicleById(int vehicleId) async {
    final url = Uri.parse('${ApiConstants.ngrokUrl}/vehicles/$vehicleId');

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
        return VehicleModel.fromJson(data);
      }

      if (response.statusCode == 404) {
        throw Exception('Vehicle not found (404)');
      }

      if (response.statusCode == 422) {
        throw Exception(
          'Validation Error: ${responseData['detail'] ?? 'Unprocessable Entity'}',
        );
      }

      throw Exception(
        responseData['message'] ??
            'Failed to fetch vehicle details: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<ChallanModel>> getVehicleChallans(int vehicleId) async {
    final url = Uri.parse(
      '${ApiConstants.ngrokUrl}/vehicles/$vehicleId/challans',
    );

    try {
      final response = await _httpClient.get(url);
      if (response.statusCode == 404) return [];

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = responseData['data'] ?? responseData;
        return data
            .map((json) => ChallanModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      if (response.statusCode == 422) {
        throw Exception(
          'Validation Error: ${responseData['detail'] ?? 'Unprocessable Entity'}',
        );
      }

      throw Exception(
        responseData['message'] ??
            'Failed to fetch challans: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<FastagModel?> getVehicleFastag(int vehicleId) async {
    final url = Uri.parse(
      '${ApiConstants.ngrokUrl}/vehicles/$vehicleId/fastag',
    );

    try {
      final response = await _httpClient.get(url);
      if (response.statusCode == 404) return null;

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = responseData['data'] ?? responseData;
        if (data == null || (data is Map && data.isEmpty)) return null;
        return FastagModel.fromJson(data as Map<String, dynamic>);
      }

      if (response.statusCode == 422) {
        throw Exception(
          'Validation Error: ${responseData['detail'] ?? 'Unprocessable Entity'}',
        );
      }

      throw Exception(responseData['message'] ?? 'Failed to fetch fastag');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<GovernmentChargeModel>> getVehicleGovernmentCharges(
    int vehicleId,
  ) async {
    final url = Uri.parse(
      '${ApiConstants.ngrokUrl}/vehicles/$vehicleId/government-charges',
    );

    try {
      final response = await _httpClient.get(url);
      if (response.statusCode == 404) return [];

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = responseData['data'] ?? responseData;
        return data
            .map(
              (json) =>
                  GovernmentChargeModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      }

      if (response.statusCode == 422) {
        throw Exception(
          'Validation Error: ${responseData['detail'] ?? 'Unprocessable Entity'}',
        );
      }

      throw Exception(
        responseData['message'] ??
            'Failed to fetch government charges: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<VehicleDocumentModel>> getVehicleDocuments(int vehicleId) async {
    final url = Uri.parse(
      '${ApiConstants.ngrokUrl}/documents/vehicle/$vehicleId',
    );

    try {
      final response = await _httpClient.get(url);
      if (response.statusCode == 404) return [];

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = responseData['data'] ?? responseData;
        return data
            .map(
              (json) =>
                  VehicleDocumentModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      }

      if (response.statusCode == 422) {
        throw Exception(
          'Validation Error: ${responseData['detail'] ?? 'Unprocessable Entity'}',
        );
      }

      throw Exception(
        responseData['message'] ??
            'Failed to fetch vehicle documents: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<TaxModel?> getVehicleTaxById(int vehicleId, int taxId) async {
    final url = Uri.parse(
      '${ApiConstants.ngrokUrl}/vehicles/$vehicleId/taxes/$taxId',
    );

    try {
      final response = await _httpClient.get(url);
      if (response.statusCode == 404) return null;

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            (responseData is Map &&
                responseData.containsKey('data') &&
                responseData['data'] != null)
            ? responseData['data'] as Map<String, dynamic>
            : responseData as Map<String, dynamic>;
        return TaxModel.fromJson(data);
      }

      if (response.statusCode == 422) {
        throw Exception(
          'Validation Error: ${responseData['detail'] ?? 'Unprocessable Entity'}',
        );
      }

      throw Exception(
        responseData['message'] ??
            'Failed to fetch tax details: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
