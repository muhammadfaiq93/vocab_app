class CalendarHeatmapData {
  final int year;
  final int month;
  final String monthName;
  final int daysInMonth;
  final int firstDayOfWeek;
  final List<CalendarDay> calendar;
  final CalendarStats stats;

  CalendarHeatmapData({
    required this.year,
    required this.month,
    required this.monthName,
    required this.daysInMonth,
    required this.firstDayOfWeek,
    required this.calendar,
    required this.stats,
  });

  factory CalendarHeatmapData.fromJson(Map<String, dynamic> json) {
    return CalendarHeatmapData(
      year: json['year'] as int,
      month: json['month'] as int,
      monthName: json['month_name'] as String,
      daysInMonth: json['days_in_month'] as int,
      firstDayOfWeek: json['first_day_of_week'] as int,
      calendar: (json['calendar'] as List)
          .map((item) => CalendarDay.fromJson(item as Map<String, dynamic>))
          .toList(),
      stats: CalendarStats.fromJson(json['stats'] as Map<String, dynamic>),
    );
  }
}

class CalendarDay {
  final String date;
  final int day;
  final int dayOfWeek;
  final int quizCount;
  final int intensity;
  final double accuracy;

  CalendarDay({
    required this.date,
    required this.day,
    required this.dayOfWeek,
    required this.quizCount,
    required this.intensity,
    required this.accuracy,
  });

  factory CalendarDay.fromJson(Map<String, dynamic> json) {
    return CalendarDay(
      date: json['date'] as String,
      day: json['day'] as int,
      dayOfWeek: json['day_of_week'] as int,
      quizCount: json['quiz_count'] as int,
      intensity: json['intensity'] as int,
      accuracy: (json['accuracy'] as num).toDouble(),
    );
  }
}

class CalendarStats {
  final int totalQuizzes;
  final int totalDaysActive;
  final double avgQuizzesPerActiveDay;

  CalendarStats({
    required this.totalQuizzes,
    required this.totalDaysActive,
    required this.avgQuizzesPerActiveDay,
  });

  factory CalendarStats.fromJson(Map<String, dynamic> json) {
    return CalendarStats(
      totalQuizzes: json['total_quizzes'] as int,
      totalDaysActive: json['total_days_active'] as int,
      avgQuizzesPerActiveDay:
          (json['avg_quizzes_per_active_day'] as num).toDouble(),
    );
  }
}
