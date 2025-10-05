import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/child_user.dart';
import '../models/vocabulary_card.dart';
import '../models/exam_question.dart';
import '../models/exam_result.dart';
import '../models/quiz_result.dart';
import '../models/quiz_session.dart';
import '../models/dashboard_data.dart';
import 'storage_service.dart';

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
      user: ChildUser.fromJson(
          json['child'] ?? json['user'] ?? json['data'] ?? {}),
      token: json['token'] ?? json['access_token'] ?? '',
    );
  }
}

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // ==================== AUTH METHODS ====================

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

  // ==================== LEARNING METHODS ====================

  /// Get vocabulary cards for learning - returns typed VocabularyCard objects
  Future<List<VocabularyCard>> getVocabularyCards({
    required String token,
    String? category,
    int? difficulty,
    int? limit,
    int? page,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (category != null) queryParams['category'] = category;
      if (difficulty != null) queryParams['difficulty'] = difficulty.toString();
      if (limit != null) queryParams['limit'] = limit.toString();
      if (page != null) queryParams['page'] = page.toString();

      final uri = Uri.parse('${ApiConstants.baseUrl}/api/vocabulary').replace(
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      final response = await _client.get(
        uri,
        headers: {
          ...ApiConstants.defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      ).timeout(ApiConstants.connectTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> cardsJson = data['data'] ?? [];
        return cardsJson.map((json) => VocabularyCard.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load vocabulary cards: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('Network error occurred');
    } catch (e) {
      throw Exception('Error fetching vocabulary cards: $e');
    }
  }

  /// Get all categories - returns list of category names
  Future<List<String>> getCategories({
    required String token,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}/api/categories'),
        headers: {
          ...ApiConstants.defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      ).timeout(ApiConstants.connectTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final categoriesData = data['data'] ?? [];

        // If the API returns a list of category objects, extract the names
        if (categoriesData is List) {
          return categoriesData
              .map((category) {
                if (category is Map<String, dynamic>) {
                  return category['name']?.toString() ??
                      category['category']?.toString() ??
                      '';
                }
                return category.toString();
              })
              .where((name) => name.isNotEmpty)
              .toList();
        }

        return [];
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('Network error occurred');
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  /// Mark a vocabulary card as learned - accepts both String and int
  Future<Map<String, dynamic>> markVocabularyAsLearned({
    required String token,
    required dynamic
        vocabularyId, // Changed to dynamic to accept both String and int
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(
            '${ApiConstants.baseUrl}/api/vocabulary/$vocabularyId/learned'),
        headers: {
          ...ApiConstants.defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      ).timeout(ApiConstants.connectTimeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to mark vocabulary as learned: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('Network error occurred');
    } catch (e) {
      throw Exception('Error marking vocabulary as learned: $e');
    }
  }

  /// Get learning progress
  Future<Map<String, dynamic>> getLearningProgress({
    required String token,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}/api/progress'),
        headers: {
          ...ApiConstants.defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      ).timeout(ApiConstants.connectTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] ?? {};
      } else {
        throw Exception(
            'Failed to load learning progress: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('Network error occurred');
    } catch (e) {
      throw Exception('Error fetching learning progress: $e');
    }
  }

  // ==================== EXAM METHODS ====================

  /// Generate an exam - returns typed ExamQuestion objects
  Future<List<ExamQuestion>> generateExam({
    required String token,
    String? category,
    int? difficulty,
    int? questionCount,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (category != null) body['category'] = category;
      if (difficulty != null) body['difficulty'] = difficulty.toString();
      if (questionCount != null) body['question_count'] = questionCount;

      final response = await _client
          .post(
            Uri.parse('${ApiConstants.baseUrl}/api/exam/generate'),
            headers: {
              ...ApiConstants.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
            body: json.encode(body),
          )
          .timeout(ApiConstants.connectTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final List<dynamic> questionsJson = data['data'] ?? [];
        return questionsJson
            .map((json) => ExamQuestion.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to generate exam: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('Network error occurred');
    } catch (e) {
      throw Exception('Error generating exam: $e');
    }
  }

  /// Submit exam answers - accepts UserAnswer objects and returns ExamResult
  Future<ExamResult> submitExam({
    required String token,
    required dynamic examId, // Accept both String and int
    required List<UserAnswer> answers,
    int? timeSpent,
  }) async {
    try {
      // Convert UserAnswer objects to JSON
      final answersJson = answers.map((answer) => answer.toJson()).toList();

      final body = <String, dynamic>{
        'answers': answersJson,
      };
      if (timeSpent != null) body['time_spent'] = timeSpent;

      // Convert examId to int if it's a String
      final examIdInt = examId is String
          ? int.tryParse(examId.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0
          : examId;

      final response = await _client
          .post(
            Uri.parse('${ApiConstants.baseUrl}/api/exam/$examIdInt/submit'),
            headers: {
              ...ApiConstants.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
            body: json.encode(body),
          )
          .timeout(ApiConstants.connectTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ExamResult.fromJson(data['data'] ?? {});
      } else {
        throw Exception('Failed to submit exam: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('Network error occurred');
    } catch (e) {
      throw Exception('Error submitting exam: $e');
    }
  }

  /// Get exam history with pagination - returns typed ExamResult objects
  Future<List<ExamResult>> getExamHistory({
    required String token,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (page != null) queryParams['page'] = page.toString();
      if (limit != null) queryParams['limit'] = limit.toString();

      final uri = Uri.parse('${ApiConstants.baseUrl}/api/exam/history').replace(
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      final response = await _client.get(
        uri,
        headers: {
          ...ApiConstants.defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      ).timeout(ApiConstants.connectTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> historyJson = data['data'] ?? [];
        return historyJson.map((json) => ExamResult.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load exam history: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('Network error occurred');
    } catch (e) {
      throw Exception('Error fetching exam history: $e');
    }
  }

  // ==================== PRIVATE HELPER METHODS ====================

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

  /// Get vocabulary by range
  Future<List<VocabularyCard>> getVocabularyByRange({
    required String token,
    required int start,
    required int end,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/vocabulary-range').replace(
        queryParameters: {
          'start': start.toString(),
          'end': end.toString(),
        },
      );

      final response = await _client.get(
        uri,
        headers: {
          ...ApiConstants.defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      ).timeout(ApiConstants.connectTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> vocabularyJson = data['data'] ?? [];
        return vocabularyJson
            .map((json) => VocabularyCard.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load vocabulary: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('Network error occurred');
    } catch (e) {
      throw Exception('Error fetching vocabulary: $e');
    }
  }

  /// Get vocabulary by difficulty level and count
  Future<List<VocabularyCard>> getVocabularyByDifficulty({
    required int difficulty,
    required int count,
  }) async {
    try {
      String token = StorageService().authToken!;
      final uri = Uri.parse('${ApiConstants.baseUrl}/vocabulary').replace(
        queryParameters: {
          'difficulty': difficulty.toString(),
          'limit': count.toString(),
        },
      );

      final response = await _client.get(
        uri,
        headers: {
          ...ApiConstants.defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      ).timeout(ApiConstants.connectTimeout);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> vocabularyJson = data['data'] ?? [];
        return vocabularyJson
            .map((json) => VocabularyCard.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load vocabulary: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching vocabulary: $e');
    }
  }

  // Save quiz result
  Future<QuizResultResponse> saveQuizResult(QuizResult quizResult) async {
    try {
      String token = StorageService().authToken!;
      final uri = Uri.parse('${ApiConstants.baseUrl}/quiz-results');
      print('Posting to $uri with body: ${jsonEncode(quizResult.toJson())}');
      final response = await _client
          .post(
            uri,
            headers: {
              ...ApiConstants.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(quizResult.toJson()),
          )
          .timeout(ApiConstants.connectTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        return QuizResultResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to save quiz result: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saving quiz result: $e');
    }
  }

  // Batch save quiz results
  Future<List<QuizResultResponse>> saveQuizResults(
      List<QuizResult> quizResults) async {
    List<QuizResultResponse> responses = [];

    for (var result in quizResults) {
      try {
        final response = await saveQuizResult(result);
        responses.add(response);
      } catch (e) {
        print('Error saving result for word ${result.wordId}: $e');
      }
    }

    return responses;
  }

  // ==================== DASHBOARD METHODS ====================

  /// Get complete dashboard data
  Future<DashboardData> getDashboardData({
    required String token,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}/dashboard'),
        headers: {
          ...ApiConstants.defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      ).timeout(ApiConstants.connectTimeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return DashboardData.fromJson(jsonData['data'] ?? {});
      } else {
        throw Exception(
            'Failed to load dashboard data: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('Network error occurred');
    } catch (e) {
      throw Exception('Error fetching dashboard data: $e');
    }
  }

  /// Get words that need practice
  Future<List<WeakWord>> getWeakWords({
    required String token,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}/dashboard/weak-words'),
        headers: {
          ...ApiConstants.defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      ).timeout(ApiConstants.connectTimeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> wordsJson = jsonData['data'] ?? [];
        return wordsJson.map((json) => WeakWord.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load weak words: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('Network error occurred');
    } catch (e) {
      throw Exception('Error fetching weak words: $e');
    }
  }

  // ==================== PROFILE METHODS ====================

  /// Get user profile
  Future<ChildUser> getProfile({required String token}) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}/profile'),
        headers: {
          ...ApiConstants.defaultHeaders,
          'Authorization': 'Bearer $token',
        },
      ).timeout(ApiConstants.connectTimeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ChildUser.fromJson(jsonData['data'] ?? {});
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }

  /// Update user profile
  Future<ApiResponse<ChildUser>> updateProfile({
    required String token,
    String? name,
    String? email,
    int? age,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (email != null) body['email'] = email;
      if (age != null) body['age'] = age;

      final response = await _client
          .put(
            Uri.parse('${ApiConstants.baseUrl}/profile'),
            headers: {
              ...ApiConstants.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
            body: json.encode(body),
          )
          .timeout(ApiConstants.connectTimeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ApiResponse(
          success: true,
          data: ChildUser.fromJson(jsonData['data'] ?? {}),
          message: jsonData['message'],
        );
      } else {
        final jsonData = json.decode(response.body);
        return ApiResponse(
          success: false,
          message: jsonData['message'] ?? 'Update failed',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Error updating profile: $e',
      );
    }
  }

  /// Update avatar (image upload)
  Future<ApiResponse<String>> updateAvatar({
    required String token,
    required String imagePath,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConstants.baseUrl}/profile/avatar'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.files.add(
        await http.MultipartFile.fromPath('avatar', imagePath),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ApiResponse(
          success: true,
          data: jsonData['data']['avatar'],
          message: jsonData['message'],
        );
      } else {
        final jsonData = json.decode(response.body);
        return ApiResponse(
          success: false,
          message: jsonData['message'] ?? 'Avatar update failed',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Error updating avatar: $e',
      );
    }
  }

  /// Change password
  Future<ApiResponse<void>> changePassword({
    required String token,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse('${ApiConstants.baseUrl}/profile/change-password'),
            headers: {
              ...ApiConstants.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
            body: json.encode({
              'current_password': currentPassword,
              'new_password': newPassword,
              'new_password_confirmation': confirmPassword,
            }),
          )
          .timeout(ApiConstants.connectTimeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ApiResponse(
          success: true,
          message: jsonData['message'],
        );
      } else {
        final jsonData = json.decode(response.body);
        return ApiResponse(
          success: false,
          message: jsonData['message'] ?? 'Password change failed',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Error changing password: $e',
      );
    }
  }

  /// Delete account
  Future<ApiResponse<void>> deleteAccount({
    required String token,
    required String password,
  }) async {
    try {
      final response = await _client
          .delete(
            Uri.parse('${ApiConstants.baseUrl}/profile'),
            headers: {
              ...ApiConstants.defaultHeaders,
              'Authorization': 'Bearer $token',
            },
            body: json.encode({'password': password}),
          )
          .timeout(ApiConstants.connectTimeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ApiResponse(
          success: true,
          message: jsonData['message'],
        );
      } else {
        final jsonData = json.decode(response.body);
        return ApiResponse(
          success: false,
          message: jsonData['message'] ?? 'Account deletion failed',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Error deleting account: $e',
      );
    }
  }

  /// Start a new quiz session
  Future<int> startQuizSession({
    required String testType,
    required int difficulty,
    required int totalQuestions,
  }) async {
    try {
      String token = StorageService().authToken!;

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/quiz-sessions/start'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'test_type': testType,
          'difficulty': difficulty,
          'total_questions': totalQuestions,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        //print('Started quiz session: ${data['data']}');
        return data['data']['session_id'];
      } else {
        throw Exception('Failed to start quiz session');
      }
    } catch (e) {
      print('Error starting quiz session: $e');
      rethrow;
    }
  }

  /// Finish quiz session with results
  Future<void> finishQuizSession({
    required int sessionId,
    required int correctCount,
    required int incorrectCount,
    required int totalTimeSeconds,
  }) async {
    try {
      String token = StorageService().authToken!;

      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/quiz-sessions/$sessionId/finish'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'correct_count': correctCount,
          'incorrect_count': incorrectCount,
          'total_time_seconds': totalTimeSeconds,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to finish quiz session');
      }
    } catch (e) {
      print('Error finishing quiz session: $e');
      rethrow;
    }
  }

  /// Abandon quiz session
  Future<void> abandonQuizSession(int sessionId) async {
    try {
      String token = StorageService().authToken!;

      await http.put(
        Uri.parse('${ApiConstants.baseUrl}/quiz-sessions/$sessionId/abandon'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      print('Error abandoning quiz session: $e');
      // Don't throw - this is best effort
    }
  }

  /// Get quiz statistics for dashboard
  Future<QuizStats> getQuizStats() async {
    try {
      String token = StorageService().authToken!;

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/quiz-sessions/stats'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return QuizStats.fromJson(data['data']);
      } else {
        throw Exception('Failed to get quiz stats');
      }
    } catch (e) {
      print('Error getting quiz stats: $e');
      rethrow;
    }
  }

  /// Get quiz history
  Future<List<QuizSession>> getQuizHistory({int page = 1}) async {
    try {
      String token = StorageService().authToken!;

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/quiz-sessions/history?page=$page'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final sessions = (data['data']['data'] as List)
            .map((session) => QuizSession.fromJson(session))
            .toList();
        return sessions;
      } else {
        throw Exception('Failed to get quiz history');
      }
    } catch (e) {
      print('Error getting quiz history: $e');
      rethrow;
    }
  }

  // ==================== CLEANUP ====================

  // Dispose method for cleanup
  void dispose() {
    _client.close();
  }
}
