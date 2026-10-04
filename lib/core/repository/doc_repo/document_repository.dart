import 'dart:convert';

import 'package:vahan_setu/core/network/api_constants.dart';
import 'package:vahan_setu/core/network/custom_http_client.dart';
import 'package:vahan_setu/features/documents/data/document_model.dart';

class DocumentRepository {
  final CustomHttpClient _httpClient;

  DocumentRepository(this._httpClient);

  Future<List<DocumentModel>> getExpiringSoonDocuments({int days = 30}) async {
    final url = Uri.parse('${ApiConstants.ngrokUrl}/documents/expiring-soon')
        .replace(queryParameters: {'days': days.toString()});
    return _fetchDocumentsList(url);
  }

  // Maps to GET /api/v1/documents/reupload-requests
  Future<List<DocumentModel>> getReuploadRequests() async {
    final url = Uri.parse(
      '${ApiConstants.ngrokUrl}/documents/reupload-requests',
    );
    return _fetchDocumentsList(url);
  }

  // Maps to POST /api/v1/documents/{document_id}/allow-reupload
  Future<void> allowReupload(int documentId) async {
    final url = Uri.parse(
      '${ApiConstants.ngrokUrl}/documents/$documentId/allow-reupload',
    );

    try {
      final response = await _httpClient.post(url);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return;
      }

      if (response.statusCode == 422) {
        throw Exception(
          'Validation Error: ${responseData['detail'] ?? 'Unprocessable Entity'}',
        );
      }

      throw Exception(
        responseData['message'] ??
            'Failed to allow reupload: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Maps to POST /api/v1/documents/{document_id}/reject-reupload
  Future<void> rejectReupload(int documentId) async {
    final url = Uri.parse(
      '${ApiConstants.ngrokUrl}/documents/$documentId/reject-reupload',
    );

    try {
      final response = await _httpClient.post(url);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return;
      }

      if (response.statusCode == 422) {
        throw Exception(
          'Validation Error: ${responseData['detail'] ?? 'Unprocessable Entity'}',
        );
      }

      throw Exception(
        responseData['message'] ??
            'Failed to reject reupload: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<DocumentModel>> _fetchDocumentsList(Uri url) async {
    try {
      final response = await _httpClient.get(url);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = responseData['data'] ?? responseData;
        return data
            .map((json) => DocumentModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      if (response.statusCode == 422) {
        throw Exception(
          'Validation Error: ${responseData['detail'] ?? 'Unprocessable Entity'}',
        );
      }

      throw Exception(
        responseData['message'] ??
            'Failed to fetch documents: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
