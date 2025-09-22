// services/api_service.dart - Enhanced
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vocabulary_card.dart';
import '../models/exam_question.dart';
import '../models/exam_result.dart';
import '../constants/api_constants.dart';

class ApiService {
  static const String baseUrl = ApiConstants.baseUrl;

  // Headers with authentication
  Map<String, String> _getHeaders(String? token) {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // Learning API methods
  Future<List<VocabularyCard>> getVocabularyCards({
    required String token,
    String? category,
    int? difficulty,
    int page = 1,
    int limit = 10,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (category != null) queryParams['category'] = category;
    if (difficulty != null) queryParams['difficulty'] = difficulty.toString();

    final uri =
        Uri.parse('$baseUrl/vocabulary').replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: _getHeaders(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((item) => VocabularyCard.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load vocabulary cards');
    }
  }

  Future<List<String>> getCategories({required String token}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/vocabulary/categories'),
      headers: _getHeaders(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['categories'];
      return data.cast<String>();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> markVocabularyAsLearned({
    required String token,
    required String vocabularyId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/learning/progress'),
      headers: _getHeaders(token),
      body: json.encode({
        'vocabularyId': vocabularyId,
        'status': 'learned',
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark vocabulary as learned');
    }
  }

  Future<Map<String, dynamic>> getLearningProgress({
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/learning/progress'),
      headers: _getHeaders(token),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load learning progress');
    }
  }

  // Exam API methods
  Future<List<ExamQuestion>> generateExam({
    required String token,
    String? category,
    int? difficulty,
    int questionCount = 10,
  }) async {
    final body = <String, dynamic>{
      'questionCount': questionCount,
    };

    if (category != null) body['category'] = category;
    if (difficulty != null) body['difficulty'] = difficulty;

    final response = await http.post(
      Uri.parse('$baseUrl/exam/generate'),
      headers: _getHeaders(token),
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['questions'];
      return data.map((item) => ExamQuestion.fromJson(item)).toList();
    } else {
      throw Exception('Failed to generate exam');
    }
  }

  Future<ExamResult> submitExam({
    required String token,
    required String examId,
    required List<UserAnswer> answers,
    required int timeSpent,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/exam/submit'),
      headers: _getHeaders(token),
      body: json.encode({
        'examId': examId,
        'answers': answers.map((a) => a.toJson()).toList(),
        'timeSpent': timeSpent,
      }),
    );

    if (response.statusCode == 200) {
      return ExamResult.fromJson(json.decode(response.body)['result']);
    } else {
      throw Exception('Failed to submit exam');
    }
  }

  Future<List<ExamResult>> getExamHistory({
    required String token,
    int page = 1,
    int limit = 10,
  }) async {
    final uri = Uri.parse('$baseUrl/exam/history').replace(queryParameters: {
      'page': page.toString(),
      'limit': limit.toString(),
    });

    final response = await http.get(
      uri,
      headers: _getHeaders(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((item) => ExamResult.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load exam history');
    }
  }

  Future<Map<String, dynamic>> getExamStatistics({
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/exam/statistics'),
      headers: _getHeaders(token),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['statistics'];
    } else {
      throw Exception('Failed to load exam statistics');
    }
  }
}
