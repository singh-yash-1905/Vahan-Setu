import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vahan_setu/core/network/api_constants.dart';
import 'package:vahan_setu/core/network/custom_http_client.dart';
import 'package:vahan_setu/features/auth/data/user_model.dart';

class AuthRepository {
  final CustomHttpClient _httpClient;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthRepository(this._httpClient);

  Future<void> register({
    required String accessCode,
    required String email,
    required String name,
    required String password,
    required String phone,
    required String role,
  }) async {
    final url = Uri.parse('${ApiConstants.ngrokUrl}/auth/register');

    final body = {
      "access_code": accessCode,
      "email": email,
      "name": name,
      "password": password,
      "phone": phone,
      "role": role,
    };

    try {
      final response = await _httpClient.post(url, body: jsonEncode(body));
      log('📥 REGISTER RESPONSE: ${response.body}', name: 'AuthRepository');
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['success'] == false) {
          throw Exception(responseData['message'] ?? 'Registration failed');
        }
        return;
      }

      if (response.statusCode == 422) {
        throw Exception(
          'Validation Error: ${responseData['detail'] ?? 'Unprocessable Entity'}',
        );
      }

      throw Exception(
        responseData['message'] ?? 'Failed to register: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> login({required String email, required String password}) async {
    final url = Uri.parse('${ApiConstants.ngrokUrl}/auth/login');

    final body = {"email": email, "password": password};

    try {
      final response = await _httpClient.post(url, body: jsonEncode(body));
      log('📥 LOGIN RESPONSE: ${response.body}', name: 'AuthRepository');
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['success'] == true) {
          final String accessToken = responseData['data']['access_token'];
          final String refreshToken = responseData['data']['refresh_token'];

          // Save tokens securely
          await _storage.write(key: 'auth_token', value: accessToken);
          await _storage.write(key: 'refresh_token', value: refreshToken);

          // Show tokens in debug console
          log('🔐 ACCESS TOKEN: $accessToken', name: 'AuthRepository');
          log('🔄 REFRESH TOKEN: $refreshToken', name: 'AuthRepository');

          return;
        } else {
          throw Exception(responseData['message'] ?? 'Login failed');
        }
      }

      if (response.statusCode == 401 || response.statusCode == 404) {
        throw Exception(responseData['message'] ?? 'Invalid credentials');
      }

      if (response.statusCode == 422) {
        throw Exception(
          'Validation Error: ${responseData['detail'] ?? 'Unprocessable Entity'}',
        );
      }

      throw Exception(
        responseData['message'] ?? 'Failed to login: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> refreshToken() async {
    try {
      // Get saved refresh token
      final storedRefreshToken = await _storage.read(key: 'refresh_token');

      log(
        '🔄 OLD REFRESH TOKEN: ${storedRefreshToken ?? "No refresh token found"}',
        name: 'AuthRepository',
      );

      if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
        throw Exception('No refresh token available. Please log in again.');
      }

      // Send refresh token as query parameter
      final url = Uri.parse(
        '${ApiConstants.ngrokUrl}/auth/refresh?refresh_token=$storedRefreshToken',
      );

      final response = await _httpClient.post(url);
      log('📥 REFRESH RESPONSE: ${response.body}', name: 'AuthRepository');
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['success'] == true) {
          final String newAccessToken = responseData['data']['access_token'];
          final String newRefreshToken = responseData['data']['refresh_token'];

          // Update stored tokens
          await _storage.write(key: 'auth_token', value: newAccessToken);
          await _storage.write(key: 'refresh_token', value: newRefreshToken);

          log('🔐 NEW ACCESS TOKEN: $newAccessToken', name: 'AuthRepository');
          log('🔄 NEW REFRESH TOKEN: $newRefreshToken', name: 'AuthRepository');

          return;
        } else {
          throw Exception(responseData['message'] ?? 'Token refresh failed');
        }
      }

      if (response.statusCode == 401) {
        throw Exception(
          responseData['message'] ?? 'Unauthorized: Please log in again.',
        );
      }

      if (response.statusCode == 422) {
        throw Exception(
          'Validation Error: ${responseData['detail'] ?? 'Invalid refresh token format'}',
        );
      }

      throw Exception(
        responseData['message'] ??
            'Failed to refresh token: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserModel> getCurrentUser() async {
    final url = Uri.parse('${ApiConstants.ngrokUrl}/auth/me');

    try {
      final response = await _httpClient.get(url);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = responseData['data'] ?? responseData;
        return UserModel.fromJson(data as Map<String, dynamic>);
      }

      if (response.statusCode == 401) {
        throw Exception(
          responseData['message'] ?? 'Unauthorized: Please log in again.',
        );
      }

      if (response.statusCode == 422) {
        throw Exception(
          'Validation Error: ${responseData['detail'] ?? 'Unprocessable Entity'}',
        );
      }

      throw Exception(
        responseData['message'] ??
            'Failed to fetch user profile: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _storage.delete(key: 'auth_token');
      await _storage.delete(key: 'refresh_token');

      log('🚪 ACCESS TOKEN DELETED', name: 'AuthRepository');
      log('🚪 REFRESH TOKEN DELETED', name: 'AuthRepository');
    } catch (e) {
      throw Exception('Failed to logout: ${e.toString()}');
    }
  }

  // Maps to POST /api/v1/auth/change-password
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse('${ApiConstants.ngrokUrl}/auth/change-password');
    final body = {"old_password": oldPassword, "new_password": newPassword};

    try {
      final response = await _httpClient.post(url, body: jsonEncode(body));
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return; // Success
      } else if (response.statusCode == 422) {
        // Validation Error
        throw Exception(
          'Validation Error: ${responseData['detail'] ?? 'Invalid input'}',
        );
      } else {
        throw Exception(
          responseData['message'] ??
              'Failed to change password: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserModel> getUserById(int userId) async {
    final url = Uri.parse('${ApiConstants.ngrokUrl}/users/$userId');

    try {
      log('👤 FETCHING USER: $userId', name: 'AuthRepository');

      log('🌐 USER URL: $url', name: 'AuthRepository');

      final response = await _httpClient.get(url);

      log(
        '📥 USER RESPONSE [${response.statusCode}]: ${response.body}',
        name: 'AuthRepository',
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = responseData['data'] ?? responseData;

        if (data is! Map<String, dynamic>) {
          throw Exception('Invalid user response format.');
        }

        return UserModel.fromJson(data);
      }

      if (response.statusCode == 401) {
        throw Exception(
          responseData['message'] ?? 'Unauthorized. Please log in again.',
        );
      }

      if (response.statusCode == 404) {
        throw Exception(
          responseData['message'] ?? 'User with ID $userId was not found.',
        );
      }

      if (response.statusCode == 422) {
        throw Exception(
          'Validation Error: '
          '${responseData['detail'] ?? 'Unprocessable Entity'}',
        );
      }

      throw Exception(
        responseData['message'] ??
            'Failed to fetch user details: '
                '${response.statusCode}',
      );
    } catch (e) {
      log('❌ GET USER ERROR: $e', name: 'AuthRepository');

      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
