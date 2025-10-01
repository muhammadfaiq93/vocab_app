import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/learning/learning_bloc.dart';
import '../widgets/stat_card.dart';
import 'learning_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              SizedBox(height: 24),
              _buildStatsSection(context),
              SizedBox(height: 32),
              _buildWeeklyProgressSection(),
              SizedBox(height: 32),
              _buildCalendarHeatmapSection(),
              SizedBox(height: 32),
              _buildContinueLearningButton(context),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryBlue, AppColors.secondaryBlue],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          state.user['name'].split(' ').first,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  }
                  return SizedBox();
                },
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  IconButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLogout());
                    },
                    icon: Icon(Icons.logout, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24),
          Column(
            children: [
              Text(
                AppStrings.yourProgress,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                AppStrings.trackLearning,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Monday, June 24, 2025',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(
                              difficulty: 1,
                              limit: 10,
                              testType: 'synonyms',
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(
                          12), // Optional: for rounded corners
                      child: StatCard(
                        value: '150',
                        label: 'Words\nTotal Learned',
                        backgroundColor: AppColors.purpleLight,
                        iconColor: AppColors.purpleDark,
                        icon: Icons.menu_book,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(
                              difficulty: 1,
                              limit: 10,
                              testType: 'synonyms',
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: StatCard(
                        value: '5',
                        label: 'Days\nCurrent Streak',
                        backgroundColor: AppColors.orangeLight,
                        iconColor: AppColors.orangeDark,
                        icon: Icons.local_fire_department,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(
                              difficulty: 1,
                              limit: 10,
                              testType: 'synonyms',
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: StatCard(
                        value: '7',
                        label: 'Days\nLongest Streak',
                        backgroundColor: AppColors.greenLight,
                        iconColor: AppColors.greenDark,
                        icon: Icons.trending_up,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(
                              difficulty: 1,
                              limit: 10,
                              testType: 'synonyms',
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: StatCard(
                        value: 'June 25',
                        label: 'Last Word\nLearned',
                        backgroundColor: AppColors.purpleLight,
                        iconColor: AppColors.purpleDark,
                        icon: Icons.schedule,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWeeklyProgressSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.weeklyProgress,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 200,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildProgressBar(80, 'Mon', AppColors.primaryBlue),
                      _buildProgressBar(60, 'Tue', AppColors.purpleDark),
                      _buildProgressBar(100, 'Wed', AppColors.primaryBlue),
                      _buildProgressBar(45, 'Thu', AppColors.purpleDark),
                      _buildProgressBar(70, 'Fri', AppColors.primaryBlue),
                      _buildProgressBar(30, 'Sat', AppColors.purpleDark),
                      _buildProgressBar(90, 'Sun', AppColors.primaryBlue),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double percentage, String day, Color color) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 20,
                  height: (percentage / 100) * 120,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarHeatmapSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.calendarHeatmap,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'June 24, 2025',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.chevron_left, color: AppColors.textLight),
                        SizedBox(width: 8),
                        Icon(Icons.chevron_right, color: AppColors.textLight),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Calendar Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCalendarHeader('Mon'),
                    _buildCalendarHeader('Tue'), // <-- Added
                    _buildCalendarHeader('Wed'),
                    _buildCalendarHeader('Thu'),
                    _buildCalendarHeader('Fri'),
                    _buildCalendarHeader('Sat'),
                    _buildCalendarHeader('Sun'),
                  ],
                ),

                SizedBox(height: 16),

                // Calendar Grid
                _buildCalendarGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader(String day) {
    return Text(
      day,
      style: TextStyle(
        fontSize: 12,
        color: AppColors.textLight,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return Container(
      height: 120,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemCount: 28,
        itemBuilder: (context, index) {
          final day = index + 1;
          final isToday = day == 24;
          final hasActivity = [2, 5, 8, 12, 15, 18, 22, 24].contains(day);

          return Container(
            decoration: BoxDecoration(
              color: isToday
                  ? AppColors.primaryBlue
                  : hasActivity
                      ? AppColors.primaryBlue.withOpacity(0.3)
                      : Colors.grey[100],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                day.toString(),
                style: TextStyle(
                  fontSize: 11,
                  color: isToday
                      ? Colors.white
                      : hasActivity
                          ? AppColors.primaryBlue
                          : AppColors.textLight,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContinueLearningButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            // context.read<LearningBloc>().add(SelectCardRange(1, 10));
            // context
            //     .read<LearningBloc>()
            //     .add(SelectCardRange(start: 1, end: 10));
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => LearningScreen()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            AppStrings.continueLearning,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
