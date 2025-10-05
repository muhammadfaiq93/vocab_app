class QuizSession {
  final int id;
  final int childId;
  final String testType;
  final int difficulty;
  final int totalQuestions;
  final String status;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int? totalTimeSeconds;
  final int correctCount;
  final int incorrectCount;
  final double? accuracyPercentage;
  final int score;

  QuizSession({
    required this.id,
    required this.childId,
    required this.testType,
    required this.difficulty,
    required this.totalQuestions,
    required this.status,
    required this.startedAt,
    this.completedAt,
    this.totalTimeSeconds,
    this.correctCount = 0,
    this.incorrectCount = 0,
    this.accuracyPercentage,
    this.score = 0,
  });

  factory QuizSession.fromJson(Map<String, dynamic> json) {
    return QuizSession(
      id: json['id'],
      childId: json['child_id'],
      testType: json['test_type'],
      difficulty: json['difficulty'],
      totalQuestions: json['total_questions'],
      status: json['status'],
      startedAt: DateTime.parse(json['started_at']),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      totalTimeSeconds: json['total_time_seconds'],
      correctCount: json['correct_count'] ?? 0,
      incorrectCount: json['incorrect_count'] ?? 0,
      accuracyPercentage: json['accuracy_percentage'] != null
          ? double.parse(json['accuracy_percentage'].toString())
          : null,
      score: json['score'] ?? 0,
    );
  }
}

class QuizStats {
  final int totalQuizzes;
  final int weeklyQuizzes;
  final double accuracy;
  final int wordsLearned;
  final int avgTimeSeconds;
  final List<WeeklyProgress> weeklyProgress;
  final List<PerformanceByType> performanceByType;

  QuizStats({
    required this.totalQuizzes,
    required this.weeklyQuizzes,
    required this.accuracy,
    required this.wordsLearned,
    required this.avgTimeSeconds,
    required this.weeklyProgress,
    required this.performanceByType,
  });

  factory QuizStats.fromJson(Map<String, dynamic> json) {
    return QuizStats(
      totalQuizzes: json['total_quizzes'] ?? 0,
      weeklyQuizzes: json['weekly_quizzes'] ?? 0,
      accuracy: (json['accuracy'] ?? 0.0).toDouble(),
      wordsLearned: json['words_learned'] ?? 0,
      avgTimeSeconds: json['avg_time_seconds'] ?? 0,
      weeklyProgress: (json['weekly_progress'] as List?)
              ?.map((e) => WeeklyProgress.fromJson(e))
              .toList() ??
          [],
      performanceByType: (json['performance_by_type'] as List?)
              ?.map((e) => PerformanceByType.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class WeeklyProgress {
  final String day;
  final String date;
  final int count;

  WeeklyProgress({
    required this.day,
    required this.date,
    required this.count,
  });

  factory WeeklyProgress.fromJson(Map<String, dynamic> json) {
    return WeeklyProgress(
      day: json['day'],
      date: json['date'],
      count: json['count'],
    );
  }
}

class PerformanceByType {
  final String testType;
  final int total;
  final double avgAccuracy;

  PerformanceByType({
    required this.testType,
    required this.total,
    required this.avgAccuracy,
  });

  factory PerformanceByType.fromJson(Map<String, dynamic> json) {
    return PerformanceByType(
      testType: json['test_type'],
      total: json['total'],
      avgAccuracy: double.parse(json['avg_accuracy'].toString()),
    );
  }

  String get displayName {
    switch (testType) {
      case 'synonyms':
        return 'Synonyms';
      case 'antonyms':
        return 'Antonyms';
      case 'meaning':
        return 'Meanings';
      default:
        return testType;
    }
  }
}