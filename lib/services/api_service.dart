import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/child_user.dart';

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;

  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
  });
}

class LoginResponse {
  final ChildUser user;
  final String token;

  const LoginResponse({
    required this.user,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: ChildUser.fromJson(json['user'] ?? json['data'] ?? {}),
      token: json['token'] ?? json['access_token'] ?? '',
    );
  }
}

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // Login method
  Future<ApiResponse<LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse(ApiConstants.loginEndpoint),
            headers: ApiConstants.defaultHeaders,
            body: json.encode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(ApiConstants.connectTimeout);

      return _handleLoginResponse(response);
    } on SocketException {
      return const ApiResponse(
        success: false,
        message: 'No internet connection. Please check your network.',
      );
    } on HttpException {
      return const ApiResponse(
        success: false,
        message: 'Network error occurred. Please try again.',
      );
    } on FormatException {
      return const ApiResponse(
        success: false,
        message: 'Invalid response format from server.',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  // Register method
  Future<ApiResponse<LoginResponse>> register({
    required String name,
    required String email,
    required String password,
    required int age,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse(ApiConstants.registerEndpoint),
            headers: ApiConstants.defaultHeaders,
            body: json.encode({
              'name': name,
              'email': email,
              'password': password,
              'age': age,
            }),
          )
          .timeout(ApiConstants.connectTimeout);

      return _handleLoginResponse(response);
    } on SocketException {
      return const ApiResponse(
        success: false,
        message: 'No internet connection. Please check your network.',
      );
    } on HttpException {
      return const ApiResponse(
        success: false,
        message: 'Network error occurred. Please try again.',
      );
    } on FormatException {
      return const ApiResponse(
        success: false,
        message: 'Invalid response format from server.',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  // Logout method
  Future<ApiResponse<void>> logout(String token) async {
    try {
      final response = await _client.post(
        Uri.parse(ApiConstants.logoutEndpoint),
        headers: {
          ...ApiConstants.defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      ).timeout(ApiConstants.connectTimeout);

      if (response.statusCode == 200) {
        return const ApiResponse(success: true);
      } else {
        return const ApiResponse(
          success: false,
          message: 'Logout failed. Please try again.',
        );
      }
    } catch (e) {
      // Even if logout API fails, we consider it successful for local logout
      return const ApiResponse(success: true);
    }
  }

  // Private method to handle login/register responses
  ApiResponse<LoginResponse> _handleLoginResponse(http.Response response) {
    try {
      final responseData = json.decode(response.body);

      switch (response.statusCode) {
        case 200:
        case 201:
          final loginResponse = LoginResponse.fromJson(responseData);
          return ApiResponse(
            success: true,
            data: loginResponse,
            statusCode: response.statusCode,
          );

        case 401:
          return ApiResponse(
            success: false,
            message: responseData['message'] ?? 'Invalid email or password.',
            statusCode: response.statusCode,
          );

        case 422:
          String errorMessage = 'Validation failed.';

          // Handle Laravel validation errors
          if (responseData['errors'] != null) {
            final errors = responseData['errors'] as Map<String, dynamic>;
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              errorMessage = firstError.first.toString();
            }
          } else if (responseData['message'] != null) {
            errorMessage = responseData['message'];
          }

          return ApiResponse(
            success: false,
            message: errorMessage,
            statusCode: response.statusCode,
          );

        case 429:
          return const ApiResponse(
            success: false,
            message: 'Too many requests. Please try again later.',
          );

        case 500:
          return const ApiResponse(
            success: false,
            message: 'Server error. Please try again later.',
          );

        default:
          return ApiResponse(
            success: false,
            message:
                responseData['message'] ?? 'Request failed. Please try again.',
            statusCode: response.statusCode,
          );
      }
    } catch (e) {
      return const ApiResponse(
        success: false,
        message: 'Failed to parse server response.',
      );
    }
  }

  // Dispose method for cleanup
  void dispose() {
    _client.close();
  }
}
