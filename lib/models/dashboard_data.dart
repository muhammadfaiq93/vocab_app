class DashboardData {
  final OverallStats overallStats;
  final List<PerformanceByType> performanceByType;
  final List<WeeklyProgress> weeklyProgress;
  final List<ActivityHeatmap> activityHeatmap;
  final StreakData streak;
  final List<RecentActivity> recentActivity;

  DashboardData({
    required this.overallStats,
    required this.performanceByType,
    required this.weeklyProgress,
    required this.activityHeatmap,
    required this.streak,
    required this.recentActivity,
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
      recentActivity: (json['recent_activity'] as List? ?? [])
          .map((item) => RecentActivity.fromJson(item))
          .toList(),
    );
  }
}

class OverallStats {
  final int totalQuizzes;
  final int accuracy;
  final int wordsLearned;
  final int avgTimeSpent;
  final int quizzesThisWeek;

  OverallStats({
    required this.totalQuizzes,
    required this.accuracy,
    required this.wordsLearned,
    required this.avgTimeSpent,
    required this.quizzesThisWeek,
  });

  factory OverallStats.fromJson(Map<String, dynamic> json) {
    return OverallStats(
      totalQuizzes: json['total_quizzes'] ?? 0,
      accuracy: json['accuracy'] ?? 0,
      wordsLearned: json['words_learned'] ?? 0,
      avgTimeSpent: json['avg_time_spent'] ?? 0,
      quizzesThisWeek: json['quizzes_this_week'] ?? 0,
    );
  }
}

class PerformanceByType {
  final String testType;
  final int total;
  final int correct;
  final int accuracy;

  PerformanceByType({
    required this.testType,
    required this.total,
    required this.correct,
    required this.accuracy,
  });

  factory PerformanceByType.fromJson(Map<String, dynamic> json) {
    return PerformanceByType(
      testType: json['test_type'] ?? '',
      total: json['total'] ?? 0,
      correct: json['correct'] ?? 0,
      accuracy: json['accuracy'] ?? 0,
    );
  }
}

class WeeklyProgress {
  final String day;
  final String date;
  final int quizzes;
  final int accuracy;

  WeeklyProgress({
    required this.day,
    required this.date,
    required this.quizzes,
    required this.accuracy,
  });

  factory WeeklyProgress.fromJson(Map<String, dynamic> json) {
    return WeeklyProgress(
      day: json['day'] ?? '',
      date: json['date'] ?? '',
      quizzes: json['quizzes'] ?? 0,
      accuracy: json['accuracy'] ?? 0,
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

  StreakData({
    required this.currentStreak,
    required this.bestStreak,
  });

  factory StreakData.fromJson(Map<String, dynamic> json) {
    return StreakData(
      currentStreak: json['current_streak'] ?? 0,
      bestStreak: json['best_streak'] ?? 0,
    );
  }
}

class RecentActivity {
  final String date;
  final int quizzes;
  final int correct;
  final int accuracy;

  RecentActivity({
    required this.date,
    required this.quizzes,
    required this.correct,
    required this.accuracy,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      date: json['date'] ?? '',
      quizzes: json['quizzes'] ?? 0,
      correct: json['correct'] ?? 0,
      accuracy: json['accuracy'] ?? 0,
    );
  }
}

class WeakWord {
  final int id;
  final String word;
  final int attempts;
  final int correct;

  WeakWord({
    required this.id,
    required this.word,
    required this.attempts,
    required this.correct,
  });

  factory WeakWord.fromJson(Map<String, dynamic> json) {
    return WeakWord(
      id: json['id'] ?? 0,
      word: json['word'] ?? '',
      attempts: json['attempts'] ?? 0,
      correct: json['correct'] ?? 0,
    );
  }
}
