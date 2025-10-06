class DashboardData {
  final OverallStats overallStats;
  final List<PerformanceByType> performanceByType;
  final List<WeeklyProgress> weeklyProgress;
  final List<ActivityHeatmap> activityHeatmap;
  final StreakData streak;
  final List<RecentSession> recentSessions;

  DashboardData({
    required this.overallStats,
    required this.performanceByType,
    required this.weeklyProgress,
    required this.activityHeatmap,
    required this.streak,
    required this.recentSessions,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      overallStats: OverallStats.fromJson(json['overall_stats'] ?? {}),
      performanceByType: (json['performance_by_type'] as List? ?? [])
          .map((item) => PerformanceByType.fromJson(item))
          .toList(),
      weeklyProgress: (json['weekly_progress'] as List? ?? [])
          .map((item) => WeeklyProgress.fromJson(item))
          .toList(),
      activityHeatmap: (json['activity_heatmap'] as List? ?? [])
          .map((item) => ActivityHeatmap.fromJson(item))
          .toList(),
      streak: StreakData.fromJson(json['streak'] ?? {}),
      recentSessions: (json['recent_sessions'] as List? ?? [])
          .map((item) => RecentSession.fromJson(item))
          .toList(),
    );
  }
}

class OverallStats {
  final int totalQuizzes;
  final double accuracy;
  final int wordsLearned;
  final int avgTimeSpent;
  final int quizzesThisWeek;
  final int totalCorrect;
  final int totalQuestions;

  OverallStats({
    required this.totalQuizzes,
    required this.accuracy,
    required this.wordsLearned,
    required this.avgTimeSpent,
    required this.quizzesThisWeek,
    required this.totalCorrect,
    required this.totalQuestions,
  });

  factory OverallStats.fromJson(Map<String, dynamic> json) {
    return OverallStats(
      totalQuizzes: json['total_quizzes'] ?? 0,
      accuracy: (json['accuracy'] ?? 0).toDouble(),
      wordsLearned: json['words_learned'] ?? 0,
      avgTimeSpent: json['avg_time_seconds'] ?? 0,
      quizzesThisWeek: json['quizzes_this_week'] ?? 0,
      totalCorrect: json['total_correct'] ?? 0,
      totalQuestions: json['total_questions'] ?? 0,
    );
  }
}

class PerformanceByType {
  final String testType;
  final int totalSessions;
  final int totalCorrect;
  final int totalQuestions;
  final double avgAccuracy;
  final int avgTimeSeconds;

  PerformanceByType({
    required this.testType,
    required this.totalSessions,
    required this.totalCorrect,
    required this.totalQuestions,
    required this.avgAccuracy,
    required this.avgTimeSeconds,
  });

  factory PerformanceByType.fromJson(Map<String, dynamic> json) {
    return PerformanceByType(
      testType: json['test_type'] ?? '',
      totalSessions: json['total_sessions'] ?? 0,
      totalCorrect: json['total_correct'] ?? 0,
      totalQuestions: json['total_questions'] ?? 0,
      avgAccuracy: (json['avg_accuracy'] ?? 0).toDouble(),
      avgTimeSeconds: json['avg_time_seconds'] ?? 0,
    );
  }
}

class WeeklyProgress {
  final String day;
  final String date;
  final int quizCount;
  final double accuracy;

  WeeklyProgress({
    required this.day,
    required this.date,
    required this.quizCount,
    required this.accuracy,
  });

  factory WeeklyProgress.fromJson(Map<String, dynamic> json) {
    return WeeklyProgress(
      day: json['day'] ?? '',
      date: json['date'] ?? '',
      quizCount: json['quiz_count'] ?? 0,
      accuracy: (json['accuracy'] ?? 0).toDouble(),
    );
  }
}

class ActivityHeatmap {
  final String date;
  final int count;
  final int intensity;

  ActivityHeatmap({
    required this.date,
    required this.count,
    required this.intensity,
  });

  factory ActivityHeatmap.fromJson(Map<String, dynamic> json) {
    return ActivityHeatmap(
      date: json['date'] ?? '',
      count: json['count'] ?? 0,
      intensity: json['intensity'] ?? 0,
    );
  }
}

class StreakData {
  final int currentStreak;
  final int bestStreak;
  final String? lastActivity;

  StreakData({
    required this.currentStreak,
    required this.bestStreak,
    this.lastActivity,
  });

  factory StreakData.fromJson(Map<String, dynamic> json) {
    return StreakData(
      currentStreak: json['current_streak'] ?? 0,
      bestStreak: json['best_streak'] ?? 0,
      lastActivity: json['last_activity'],
    );
  }
}

class RecentSession {
  final int id;
  final String testType;
  final int difficulty;
  final String score;
  final double accuracy;
  final int timeSeconds;
  final String completedAt;

  RecentSession({
    required this.id,
    required this.testType,
    required this.difficulty,
    required this.score,
    required this.accuracy,
    required this.timeSeconds,
    required this.completedAt,
  });

  factory RecentSession.fromJson(Map<String, dynamic> json) {
    return RecentSession(
      id: json['id'] ?? 0,
      testType: json['test_type'] ?? '',
      difficulty: json['difficulty'] ?? 0,
      score: json['score'] ?? '',
      accuracy: (json['accuracy'] ?? 0).toDouble(),
      timeSeconds: json['time_seconds'] ?? 0,
      completedAt: json['completed_at'] ?? '',
    );
  }
}

class WeakWord {
  final int id;
  final String word;
  final String definition;
  final int totalAttempts;
  final int correctAttempts;
  final int incorrectAttempts;
  final double accuracy;

  WeakWord({
    required this.id,
    required this.word,
    required this.definition,
    required this.totalAttempts,
    required this.correctAttempts,
    required this.incorrectAttempts,
    required this.accuracy,
  });

  factory WeakWord.fromJson(Map<String, dynamic> json) {
    return WeakWord(
      id: json['id'] ?? 0,
      word: json['word'] ?? '',
      definition: json['definition'] ?? '',
      totalAttempts: json['total_attempts'] ?? 0,
      correctAttempts: json['correct_attempts'] ?? 0,
      incorrectAttempts: json['incorrect_attempts'] ?? 0,
      accuracy: (json['accuracy'] ?? 0).toDouble(),
    );
  }
}
