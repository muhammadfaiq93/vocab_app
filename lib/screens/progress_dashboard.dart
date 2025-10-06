import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/app_colors.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../widgets/user_avatar.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../models/dashboard_data.dart';
import '../widgets/quiz_selection_modal.dart';
import '../widgets/vocabulary_selection_modal.dart';
import 'dynamic_learning_screen.dart';
import 'quiz_screen.dart';
import 'profile_screen.dart';
import '../models/calendar_heatmap.dart';

class ProgressDashboard extends StatefulWidget {
  @override
  _ProgressDashboardState createState() => _ProgressDashboardState();
}

class _ProgressDashboardState extends State<ProgressDashboard> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  DashboardData? _dashboardData;
  String? _errorMessage;
  CalendarHeatmapData? _calendarData;
  DateTime _selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    _loadCalendarHeatmap();
  }

  void _changeMonth(int offset) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + offset,
        1,
      );
    });
    _loadCalendarHeatmap();
  }

  Future<void> _loadCalendarHeatmap() async {
    try {
      final token = StorageService().authToken;
      if (token == null) return;
      // final data = [];
      final data = await _apiService.fetchCalendarHeatmapData(
        year: _selectedMonth.year.toInt(),
        month: _selectedMonth.month.toInt(),
      );
      // print('Loaded calendar data: $data');

      setState(() {
        _calendarData = data;
      });
    } catch (e) {
      print('Error loading calendar: $e');
    }
  }

  Future<void> _loadDashboardData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final token = StorageService().authToken;
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final data = await _apiService.getDashboardData(token: token);

      setState(() {
        _dashboardData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

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
              _buildHeader(context),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? _buildLoadingState()
                      : _errorMessage != null
                          ? _buildErrorState()
                          : _buildDashboardContent(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildSpeedDial(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading your progress...',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(
            'Failed to load dashboard',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _errorMessage ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadDashboardData,
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    if (_dashboardData == null) return SizedBox();

    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
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
            _buildQuickActions(),
            SizedBox(height: 24),
            _buildStreakSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final storage = StorageService();
    final avatarPath = storage.currentUser?.avatar;
    final fullName = storage.currentUser?.name ?? 'User';
    final firstName = storage.currentUser?.name.split(' ').first ?? 'User';
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
                  UserAvatar(
                    userName: fullName,
                    avatarPath: avatarPath,
                    size: 50,
                    showBorder: true,
                    backgroundColor: Colors.white,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 12),
                  Text(
                    firstName,
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
                    icon: Icon(Icons.logout, color: Colors.white, size: 20),
                    onPressed: () => _showLogoutDialog(context),
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
            _formatDate(DateTime.now()),
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
    final stats = _dashboardData!.overallStats;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            '${stats.totalQuizzes}',
            'Quizzes',
            Icons.quiz_outlined,
            Color(0xFF3B82F6),
            '+${stats.quizzesThisWeek} this week',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            '${stats.accuracy}%',
            'Accuracy',
            Icons.check_circle_outline,
            Color(0xFF10B981),
            'Great job!',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            '${stats.wordsLearned}',
            'Words',
            Icons.book_outlined,
            Color(0xFF8B5CF6),
            '${stats.avgTimeSpent}s avg',
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
    final weeklyData = _dashboardData!.weeklyProgress;
    if (weeklyData.isEmpty) return SizedBox();

    final maxQuizzes = weeklyData.map((e) => e.quizCount).reduce(math.max);
    final totalQuizzes =
        weeklyData.fold(0, (sum, item) => sum + item.quizCount);

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
                  '$totalQuizzes Total',
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
                final isToday = _isToday(day.date);

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (day.quizCount > 0)
                          Text(
                            '${day.quizCount}',
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
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.bottomCenter,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double barHeight = 0;
                                if (day.quizCount > 0 && maxQuizzes > 0) {
                                  final heightPercent =
                                      day.quizCount / maxQuizzes;
                                  barHeight = math.max(
                                    constraints.maxHeight * heightPercent,
                                    8.0, // Minimum 8px visibility
                                  );
                                }

                                return Container(
                                  height: barHeight,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: isToday
                                          ? [
                                              Color(0xFF6366F1),
                                              Color(0xFF8B5CF6)
                                            ]
                                          : [
                                              Color(0xFF8B5CF6),
                                              Color(0xFF6366F1)
                                            ],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                );
                              },
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
    final performance = _dashboardData!.performanceByType;
    if (performance.isEmpty) return SizedBox();

    final colors = {
      'synonyms': Color(0xFF3B82F6),
      'antonyms': Color(0xFF8B5CF6),
      'meaning': Color(0xFF10B981),
    };

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
          ...performance.map((item) {
            final color =
                colors[item.testType.toLowerCase()] ?? Color(0xFF6366F1);
            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: _buildPerformanceBar(
                _capitalize(item.testType),
                item.totalCorrect,
                item.totalQuestions,
                color,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPerformanceBar(
      String label, int correct, int total, Color color) {
    final percentage = total > 0 ? (correct / total * 100).round() : 0;

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
              widthFactor: total > 0 ? correct / total : 0,
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          '$percentage% accuracy',
          style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

  Widget _buildCalendarHeatmap() {
    if (_calendarData == null) {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Activity Calendar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () => _changeMonth(-1),
                  icon: Icon(Icons.chevron_left, color: Color(0xFF6B7280)),
                ),
                IconButton(
                  onPressed: () => _changeMonth(1),
                  icon: Icon(Icons.chevron_right, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                '${_calendarData!.monthName} ${_calendarData!.year}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${_calendarData!.stats.totalQuizzes} quizzes • ${_calendarData!.stats.totalDaysActive} active days',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
              SizedBox(height: 16),
              _buildCalendarGrid(),
              SizedBox(height: 16),
              _buildIntensityLegend(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();

    // Create a map for quick day lookup
    final daysMap = {for (var day in _calendarData!.calendar) day.day: day};

    return Column(
      children: [
        // Week headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekDays
              .map((day) => Container(
                    width: 36,
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ))
              .toList(),
        ),
        SizedBox(height: 8),

        // Calendar grid
        ...List.generate(6, (weekIndex) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (dayIndex) {
                int dayNumber = weekIndex * 7 +
                    dayIndex +
                    1 -
                    (_calendarData!.firstDayOfWeek - 1);

                if (dayNumber < 1 || dayNumber > _calendarData!.daysInMonth) {
                  return Container(width: 36, height: 36);
                }

                final dayData = daysMap[dayNumber];
                final isToday = now.year == _calendarData!.year &&
                    now.month == _calendarData!.month &&
                    now.day == dayNumber;

                return _buildDayCell(dayNumber, dayData, isToday);
              }),
            ),
          );
        }).where((row) {
          // Filter out completely empty rows
          return true;
        }).toList(),
      ],
    );
  }

  Widget _buildDayCell(int day, CalendarDay? data, bool isToday) {
    final intensity = data?.intensity ?? 0;
    final quizCount = data?.quizCount ?? 0;

    Color cellColor;
    if (isToday) {
      cellColor = Color(0xFF6366F1);
    } else if (intensity > 0) {
      cellColor = Color(0xFF6366F1).withOpacity(0.2 + (intensity * 0.2));
    } else {
      cellColor = Color(0xFFF3F4F6);
    }

    return GestureDetector(
      onTap: quizCount > 0 ? () => _showDayDetails(data!) : null,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: cellColor,
          borderRadius: BorderRadius.circular(6),
          border:
              isToday ? Border.all(color: Color(0xFF6366F1), width: 2) : null,
        ),
        child: Center(
          child: Text(
            day.toString(),
            style: TextStyle(
              fontSize: 12,
              color:
                  isToday || intensity > 2 ? Colors.white : Color(0xFF1F2937),
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIntensityLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Less', style: TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
        SizedBox(width: 8),
        ...List.generate(5, (index) {
          return Padding(
            padding: EdgeInsets.only(left: 4),
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: index == 0
                    ? Color(0xFFF3F4F6)
                    : Color(0xFF6366F1).withOpacity(0.2 + (index * 0.2)),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          );
        }),
        SizedBox(width: 8),
        Text('More', style: TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
      ],
    );
  }

  void _showDayDetails(CalendarDay day) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Activity on ${day.date}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quizzes completed: ${day.quizCount}'),
            SizedBox(height: 8),
            Text('Average accuracy: ${day.accuracy.toStringAsFixed(1)}%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                title: 'Take Quiz',
                subtitle: 'Test your knowledge',
                icon: Icons.quiz_outlined,
                gradient: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                onTap: () {
                  _showQuizModal(context);
                },
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                title: 'Learn Words',
                subtitle: 'Study vocabulary',
                icon: Icons.book_outlined,
                gradient: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                onTap: () {
                  _showLearningModal(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.3),
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuizModal(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuizSelectionModal(),
    );

    if (result != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizScreen(
            difficulty: result['difficulty'],
            limit: result['limit'],
            testType: result['testType'],
          ),
        ),
      );
    }
  }

  void _showLearningModal(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VocabularySelectionModal(),
    );

    if (result != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DynamicLearningScreen(
              difficulty: result['difficulty'], wordCount: result['count']),
        ),
      );
    }
  }

  Widget _buildStreakSection() {
    final streak = _dashboardData!.streak;

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
              child: Text('🔥', style: TextStyle(fontSize: 32)),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${streak.currentStreak} Day Streak!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Best: ${streak.bestStreak} days',
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthBloc>().add(AuthLogout());
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  bool _isToday(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      final now = DateTime.now();
      return parsedDate.year == now.year &&
          parsedDate.month == now.month &&
          parsedDate.day == now.day;
    } catch (e) {
      return false;
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Widget _buildSpeedDial() {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      backgroundColor: Color(0xFF6366F1),
      foregroundColor: Colors.white,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      spacing: 12,
      childPadding: EdgeInsets.all(5),
      spaceBetweenChildren: 10,
      children: [
        SpeedDialChild(
          child: Icon(Icons.quiz_outlined, color: Colors.white),
          backgroundColor: Color(0xFF3B82F6),
          label: 'Take Quiz',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          onTap: () => _showQuizModal(context),
        ),
        SpeedDialChild(
          child: Icon(Icons.book_outlined, color: Colors.white),
          backgroundColor: Color(0xFF8B5CF6),
          label: 'Learn Words',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          onTap: () => _showLearningModal(context),
        ),
      ],
    );
  }
}
