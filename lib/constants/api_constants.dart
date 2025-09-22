class ApiConstants {
  // Base Configuration
  static const String baseUrl = 'https://appapi.tutorselevenplus.co.uk/api';
  static const bool offlineMode = false; // Set to true for offline testing
  static const int timeoutDuration = 30; // seconds

  // Authentication Endpoints
  static const String loginEndpoint = '/children/login';
  static const String registerEndpoint = '/children/register';
  static const String logoutEndpoint = '/children/logout';
  static const String profileEndpoint = '/children/profile';
  static const String refreshTokenEndpoint = '/children/refresh-token';

  // Vocabulary Endpoints
  static const String vocabularyEndpoint = '/vocabulary';
  static const String vocabularyRangeEndpoint = '/vocabulary-range';
  static const String vocabularySearchEndpoint = '/vocabulary/search';
  static const String vocabularyByIdEndpoint = '/vocabulary'; // + /{id}

  // Learning Session Endpoints
  static const String learningSessionEndpoint = '/learning-sessions';
  static const String childSessionsEndpoint =
      '/children'; // + /{childId}/sessions
  static const String updateSessionEndpoint = '/learning-sessions'; // + /{id}
  static const String completeSessionEndpoint =
      '/learning-sessions'; // + /{id}/complete

  // Quiz Result Endpoints
  static const String quizResultEndpoint = '/quiz-results';
  static const String batchQuizResultEndpoint = '/quiz-results/batch';
  static const String childProgressEndpoint =
      '/children'; // + /{childId}/progress
  static const String quizStatisticsEndpoint = '/quiz-results/statistics';

  // Progress & Analytics Endpoints
  static const String progressEndpoint = '/children'; // + /{id}/progress
  static const String statisticsEndpoint = '/children'; // + /{id}/statistics
  static const String leaderboardEndpoint = '/leaderboard';
  static const String achievementsEndpoint =
      '/children'; // + /{id}/achievements

  // Content Endpoints
  static const String wordOfTheDayEndpoint = '/word-of-the-day';
  static const String categoriesEndpoint = '/categories';
  static const String difficultiesEndpoint = '/difficulties';

  // Vocabulary endpoints
  static const String vocabulary = '/vocabulary';
  static const String vocabularyCategories = '/vocabulary/categories';

  // Learning endpoints
  static const String learningProgress = '/learning/progress';
  static const String markAsLearned = '/learning/mark-learned';

  // Exam endpoints
  static const String examGenerate = '/exam/generate';
  static const String examSubmit = '/exam/submit';
  static const String examHistory = '/exam/history';
  static const String examStatistics = '/exam/statistics';

  // File upload endpoints
  static const String uploadImage = '/upload/image';
  static const String uploadAudio = '/upload/audio';

  // HTTP Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const Map<String, String> multipartHeaders = {
    'Content-Type': 'multipart/form-data',
    'Accept': 'application/json',
  };

  // Request Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Cache Settings
  static const Duration cacheExpiration = Duration(hours: 24);
  static const String cacheKeyPrefix = 'wordwise_cache_';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Rate Limiting
  static const int maxRequestsPerMinute = 60;
  static const Duration rateLimitWindow = Duration(minutes: 1);

  // Error Codes
  static const int unauthorizedCode = 401;
  static const int forbiddenCode = 403;
  static const int notFoundCode = 404;
  static const int validationErrorCode = 422;
  static const int serverErrorCode = 500;
  static const int networkErrorCode = -1;

  // Local Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String userDataKey = 'user_data';
  static const String settingsKey = 'app_settings';
  static const String cacheVersionKey = 'cache_version';

  // API Versions
  static const String apiVersion = 'v1';
  static const String currentApiVersion = '1.0';

  // Response Status Messages
  static const String successMessage = 'success';
  static const String errorMessage = 'error';
  static const String validationErrorMessage = 'validation_error';
  static const String authErrorMessage = 'authentication_error';
  static const String notFoundMessage = 'not_found';

  // Helper Methods
  static String getFullUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }

  static Map<String, String> getAuthHeaders(String token) {
    return {
      ...defaultHeaders,
      'Authorization': 'Bearer $token',
    };
  }

  static Map<String, String> getMultipartAuthHeaders(String token) {
    return {
      ...multipartHeaders,
      'Authorization': 'Bearer $token',
    };
  }

  // Environment Configuration
  static bool get isProduction =>
      !baseUrl.contains('localhost') && !baseUrl.contains('127.0.0.1');
  static bool get isDevelopment => !isProduction;

  // Feature Flags
  static const bool enableCaching = true;
  static const bool enableLogging = true;
  static const bool enableAnalytics = true;
  static const bool enableOfflineMode = true;
}
