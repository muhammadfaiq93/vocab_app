class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://appapi.tutorselevenplus.co.uk/api';
  static const String avatarBaseUrl =
      'https://appapi.tutorselevenplus.co.uk/storage/avatar';

  // Auth endpoints
  static const String loginEndpoint = '$baseUrl/children/login';
  static const String registerEndpoint = '$baseUrl/children/register';
  static const String logoutEndpoint = '$baseUrl/children/logout';
  static const String refreshTokenEndpoint = '$baseUrl/children/refresh';

  // Helper method to get full avatar URL
  static String getAvatarUrl(String? avatarPath) {
    if (avatarPath == null || avatarPath.isEmpty) return '';

    // If it's already a full URL, return as is
    if (avatarPath.startsWith('https')) {
      return avatarPath;
    }

    // If it starts with /storage, append to base URL
    if (avatarPath.startsWith('/storage')) {
      return '$baseUrl$avatarPath';
    }

    // Otherwise, append to avatar base URL
    return '$avatarBaseUrl/$avatarPath';
  }

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
