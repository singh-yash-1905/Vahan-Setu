import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // 1. Get the token from local storage
    final token = await _storage.read(key: 'auth_token');

    // 2. Default headers
    request.headers['Content-Type'] = 'application/json';
    request.headers['Accept'] = 'application/json';

    // 3. Inject Authorization header if a token exists
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // 4. Log network activity
    log(
      '🌍 API CALL: ${request.method} ${request.url}',
      name: 'CustomHttpClient',
    );

    log(
      '🔑 TOKEN INJECTED: ${token != null ? "Yes" : "No"}',
      name: 'CustomHttpClient',
    );

    // 5. Print actual access token
    log(
      '🔐 ACCESS TOKEN: ${token ?? "No token found"}',
      name: 'CustomHttpClient',
    );

    // 6. Send request
    return _inner.send(request);
  }
}
