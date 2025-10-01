import 'package:flutter/material.dart';
import 'dart:math' as math;

class DashboardScreen extends StatefulWidget {
  // final int childId;

  const DashboardScreen();
  //{Key? key, required this.childId}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Mock data - Replace with actual API call
  final DashboardData data = DashboardData(
    totalQuizzes: 25,
    correctAnswers: 21,
    totalWords: 100,
    averageTime: 8,
    currentStreak: 5,
    bestStreak: 7,
    synonymsCorrect: 15,
    synonymsTotal: 18,
    antonymsCorrect: 3,
    antonymsTotal: 4,
    meaningCorrect: 3,
    meaningTotal: 3,
    recentActivity: [
      QuizActivity(date: '2025-10-01', quizzes: 8, correct: 7),
      QuizActivity(date: '2025-09-30', quizzes: 5, correct: 4),
      QuizActivity(date: '2025-09-29', quizzes: 7, correct: 6),
      QuizActivity(date: '2025-09-28', quizzes: 5, correct: 4),
    ],
    weakWords: [
      WeakWord(word: 'Articulate', attempts: 3, correct: 1),
      WeakWord(word: 'Unpredictable', attempts: 2, correct: 0),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final accuracy = ((data.correctAnswers / data.totalQuizzes) * 100).round();

    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'My Progress',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Color(0xFF6B7280)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            _buildWelcomeCard(accuracy),
            SizedBox(height: 20),

            // Stats Grid
            _buildStatsGrid(),
            SizedBox(height: 20),

            // Performance by Test Type
            _buildSectionTitle('Performance by Type'),
            SizedBox(height: 12),
            _buildTestTypeCards(),
            SizedBox(height: 20),

            // Recent Activity
            _buildSectionTitle('Recent Activity'),
            SizedBox(height: 12),
            _buildRecentActivity(),
            SizedBox(height: 20),

            // Words to Practice
            _buildSectionTitle('Words to Practice'),
            SizedBox(height: 12),
            _buildWeakWords(),
            SizedBox(height: 20),

            // Achievements
            _buildSectionTitle('Achievements'),
            SizedBox(height: 12),
            _buildAchievements(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(int accuracy) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF3B82F6).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Great Job! 🎉',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'You\'re doing amazing!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    _buildMiniStat('$accuracy%', 'Accuracy'),
                    SizedBox(width: 24),
                    _buildMiniStat('${data.currentStreak}🔥', 'Day Streak'),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '📚',
                style: TextStyle(fontSize: 50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            '${data.totalQuizzes}',
            'Quizzes Taken',
            Icons.quiz,
            Color(0xFF10B981),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            '${data.totalWords}',
            'Words Learned',
            Icons.book,
            Color(0xFF8B5CF6),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            '${data.averageTime}s',
            'Avg Time',
            Icons.timer,
            Color(0xFFF59E0B),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String value, String label, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTestTypeCards() {
    return Column(
      children: [
        _buildTestTypeCard(
          'Synonyms',
          '🔄',
          data.synonymsCorrect,
          data.synonymsTotal,
          Color(0xFF3B82F6),
        ),
        SizedBox(height: 12),
        _buildTestTypeCard(
          'Antonyms',
          '⚖️',
          data.antonymsCorrect,
          data.antonymsTotal,
          Color(0xFF8B5CF6),
        ),
        SizedBox(height: 12),
        _buildTestTypeCard(
          'Meaning',
          '📖',
          data.meaningCorrect,
          data.meaningTotal,
          Color(0xFF10B981),
        ),
      ],
    );
  }

  Widget _buildTestTypeCard(
    String type,
    String emoji,
    int correct,
    int total,
    Color color,
  ) {
    final percentage = total > 0 ? (correct / total * 100).round() : 0;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(emoji, style: TextStyle(fontSize: 24)),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '$correct / $total correct',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: total > 0 ? correct / total : 0,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: data.recentActivity.map((activity) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFF3B82F6).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.calendar_today,
                      color: Color(0xFF3B82F6),
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDate(activity.date),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      Text(
                        '${activity.quizzes} quizzes • ${activity.correct} correct',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${((activity.correct / activity.quizzes) * 100).round()}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWeakWords() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: data.weakWords.map((word) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFEF4444).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Color(0xFFEF4444),
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        word.word,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      Text(
                        '${word.correct}/${word.attempts} correct',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3B82F6),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Practice',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAchievements() {
    return Container(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildAchievementBadge('🎯', 'First Quiz', true),
          _buildAchievementBadge('🔥', '5 Day Streak', true),
          _buildAchievementBadge('⭐', '20 Quizzes', true),
          _buildAchievementBadge('🏆', '100% Score', false),
          _buildAchievementBadge('💯', '100 Words', false),
          _buildAchievementBadge('👑', '30 Day Streak', false),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge(String emoji, String title, bool earned) {
    return Container(
      width: 100,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: earned ? Colors.white : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: earned ? Color(0xFFF59E0B) : Colors.grey[300]!,
          width: 2,
        ),
        boxShadow: earned
            ? [
                BoxShadow(
                  color: Color(0xFFF59E0B).withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            emoji,
            style: TextStyle(
              fontSize: 36,
              color: earned ? null : Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: earned ? Color(0xFF1F2937) : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1F2937),
      ),
    );
  }

  String _formatDate(String date) {
    final parts = date.split('-');
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[int.parse(parts[1]) - 1]} ${parts[2]}';
  }
}

// Data Models
class DashboardData {
  final int totalQuizzes;
  final int correctAnswers;
  final int totalWords;
  final int averageTime;
  final int currentStreak;
  final int bestStreak;
  final int synonymsCorrect;
  final int synonymsTotal;
  final int antonymsCorrect;
  final int antonymsTotal;
  final int meaningCorrect;
  final int meaningTotal;
  final List<QuizActivity> recentActivity;
  final List<WeakWord> weakWords;

  DashboardData({
    required this.totalQuizzes,
    required this.correctAnswers,
    required this.totalWords,
    required this.averageTime,
    required this.currentStreak,
    required this.bestStreak,
    required this.synonymsCorrect,
    required this.synonymsTotal,
    required this.antonymsCorrect,
    required this.antonymsTotal,
    required this.meaningCorrect,
    required this.meaningTotal,
    required this.recentActivity,
    required this.weakWords,
  });
}

class QuizActivity {
  final String date;
  final int quizzes;
  final int correct;

  QuizActivity({
    required this.date,
    required this.quizzes,
    required this.correct,
  });
}

class WeakWord {
  final String word;
  final int attempts;
  final int correct;

  WeakWord({
    required this.word,
    required this.attempts,
    required this.correct,
  });
}
