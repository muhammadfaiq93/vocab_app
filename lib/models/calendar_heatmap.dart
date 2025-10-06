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
    try {
      var calendarList = json['calendar'];
      List<CalendarDay> parsedCalendar = [];

      if (calendarList is List) {
        parsedCalendar = calendarList
            .map((item) => CalendarDay.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      return CalendarHeatmapData(
        year: json['year'] ?? DateTime.now().year,
        month: json['month'] ?? DateTime.now().month,
        monthName: json['month_name'] ?? '',
        daysInMonth: json['days_in_month'] ?? 30,
        firstDayOfWeek: json['first_day_of_week'] ?? 1,
        calendar: parsedCalendar,
        stats:
            CalendarStats.fromJson(json['stats'] is Map ? json['stats'] : {}),
      );
    } catch (e) {
      print('Error parsing CalendarHeatmapData: $e');
      print('JSON: $json');
      rethrow;
    }
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
      date: json['date']?.toString() ?? '',
      day: json['day'] is int
          ? json['day']
          : int.tryParse(json['day']?.toString() ?? '0') ?? 0,
      dayOfWeek: json['day_of_week'] is int ? json['day_of_week'] : 1,
      quizCount: json['quiz_count'] is int ? json['quiz_count'] : 0,
      intensity: json['intensity'] is int ? json['intensity'] : 0,
      accuracy: (json['accuracy'] ?? 0).toDouble(),
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
      totalQuizzes: json['total_quizzes'] is int ? json['total_quizzes'] : 0,
      totalDaysActive:
          json['total_days_active'] is int ? json['total_days_active'] : 0,
      avgQuizzesPerActiveDay:
          (json['avg_quizzes_per_active_day'] ?? 0).toDouble(),
    );
  }
}
