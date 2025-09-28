class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://appapi.tutorselevenplus.co.uk/api';

  // Auth endpoints
  static const String loginEndpoint = '$baseUrl/children/login';
  static const String registerEndpoint = '$baseUrl/children/register';
  static const String logoutEndpoint = '$baseUrl/children/logout';
  static const String refreshTokenEndpoint = '$baseUrl/children/refresh';

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
