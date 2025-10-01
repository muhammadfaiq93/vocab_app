// lib/screens/progress_dashboard.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProgressDashboard extends StatefulWidget {
  final String userName = "Faiq";
  final int childId = 2;

  const ProgressDashboard();
  //   {
  //   Key? key,
  //   required this.userName,
  //   required this.childId,
  // }) : super(key: key);

  @override
  _ProgressDashboardState createState() => _ProgressDashboardState();
}

class _ProgressDashboardState extends State<ProgressDashboard> {
  // Mock data - Replace with API
  final List<DayProgress> weeklyData = [
    DayProgress('Mon', 8, 85),
    DayProgress('Tue', 12, 92),
    DayProgress('Wed', 6, 75),
    DayProgress('Thu', 10, 88),
    DayProgress('Fri', 7, 82),
    DayProgress('Sat', 5, 70),
    DayProgress('Sun', 15, 95),
  ];

  final Map<DateTime, int> heatmapData = {
    DateTime(2025, 6, 2): 3,
    DateTime(2025, 6, 5): 2,
    DateTime(2025, 6, 8): 4,
    DateTime(2025, 6, 12): 3,
    DateTime(2025, 6, 15): 2,
    DateTime(2025, 6, 18): 5,
    DateTime(2025, 6, 22): 3,
    DateTime(2025, 6, 25): 4,
    DateTime(2025, 6, 28): 2,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6366F1),
              Color(0xFF8B5CF6),
              Color(0xFFA855F7),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatsCards(),
                        SizedBox(height: 24),
                        _buildWeeklyProgress(),
                        SizedBox(height: 24),
                        _buildPerformanceChart(),
                        SizedBox(height: 24),
                        _buildCalendarHeatmap(),
                        SizedBox(height: 24),
                        _buildStreakSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        // widget.userName[0].toUpperCase(),
                        'Faiq',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Faiq",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Stack(
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications_outlined,
                            color: Colors.white, size: 28),
                        onPressed: () {},
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.person_outline,
                        color: Colors.white, size: 28),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'Your Progress!',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Track your learning, day by day!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          Text(
            'Monday, June 24, 2025',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            '63',
            'Quizzes',
            Icons.quiz_outlined,
            Color(0xFF3B82F6),
            '+12 this week',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            '87%',
            'Accuracy',
            Icons.check_circle_outline,
            Color(0xFF10B981),
            '+5% vs last week',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            '245',
            'Words',
            Icons.book_outlined,
            Color(0xFF8B5CF6),
            '45 this week',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgress() {
    final maxQuizzes = weeklyData.map((e) => e.quizzes).reduce(math.max);

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Progress',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '63 Total',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Container(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: weeklyData.map((day) {
                final heightPercent = (day.quizzes / maxQuizzes);
                final isToday = day.day == 'Sun';

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${day.quizzes}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        SizedBox(height: 8),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: isToday
                                    ? [Color(0xFF6366F1), Color(0xFF8B5CF6)]
                                    : [
                                        Color(0xFF8B5CF6).withOpacity(0.3),
                                        Color(0xFF6366F1).withOpacity(0.3)
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.bottomCenter,
                            child: FractionallySizedBox(
                              heightFactor: heightPercent,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: isToday
                                        ? [Color(0xFF6366F1), Color(0xFF8B5CF6)]
                                        : [
                                            Color(0xFF8B5CF6),
                                            Color(0xFF6366F1)
                                          ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          day.day,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                isToday ? FontWeight.bold : FontWeight.w500,
                            color:
                                isToday ? Color(0xFF6366F1) : Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance by Type',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 20),
          _buildPerformanceBar('Synonyms', 18, 20, Color(0xFF3B82F6)),
          SizedBox(height: 16),
          _buildPerformanceBar('Antonyms', 15, 18, Color(0xFF8B5CF6)),
          SizedBox(height: 16),
          _buildPerformanceBar('Meaning', 25, 25, Color(0xFF10B981)),
        ],
      ),
    );
  }

  Widget _buildPerformanceBar(
      String label, int correct, int total, Color color) {
    final percentage = (correct / total * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            Text(
              '$correct/$total',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 12,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            FractionallySizedBox(
              widthFactor: correct / total,
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          '$percentage% accuracy',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarHeatmap() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Activity Heatmap',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, color: Color(0xFF6B7280)),
                    onPressed: () {},
                  ),
                  Text(
                    'June 2025',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right, color: Color(0xFF6B7280)),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildCalendarGrid(),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Less',
                style: TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
              ),
              SizedBox(width: 8),
              ...List.generate(5, (index) {
                return Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Color(0xFF6366F1).withOpacity(0.2 + (index * 0.2)),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                );
              }),
              SizedBox(width: 8),
              Text(
                'More',
                style: TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth = 30;
    final firstDayOfWeek = 0; // Monday

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 35,
      itemBuilder: (context, index) {
        final dayNumber = index - firstDayOfWeek + 1;
        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return SizedBox.shrink();
        }

        final date = DateTime(2025, 6, dayNumber);
        final intensity = heatmapData[date] ?? 0;
        final isToday = dayNumber == 25;

        return Container(
          decoration: BoxDecoration(
            color: intensity > 0
                ? Color(0xFF6366F1).withOpacity(0.2 * intensity)
                : Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8),
            border:
                isToday ? Border.all(color: Color(0xFF6366F1), width: 2) : null,
          ),
          child: Center(
            child: Text(
              '$dayNumber',
              style: TextStyle(
                fontSize: 12,
                fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                color: intensity > 0 ? Color(0xFF1F2937) : Color(0xFF9CA3AF),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStreakSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFF59E0B).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '🔥',
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '7 Day Streak!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Keep it up! You\'re on fire!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
        ],
      ),
    );
  }
}

class DayProgress {
  final String day;
  final int quizzes;
  final int accuracy;

  DayProgress(this.day, this.quizzes, this.accuracy);
}
