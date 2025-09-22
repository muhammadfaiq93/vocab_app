import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../blocs/exam/exam_bloc.dart';
import '../blocs/exam/exam_event.dart';
import '../blocs/exam/exam_state.dart';
import '../models/exam_question.dart';
import '../constants/app_colors.dart';
import '../widgets/progress_bar.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({Key? key}) : super(key: key);

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> with TickerProviderStateMixin {
  late AnimationController _questionAnimationController;
  late AnimationController _optionAnimationController;
  late Animation<double> _questionAnimation;
  late Animation<Offset> _slideAnimation;

  Timer? _examTimer;
  int _secondsElapsed = 0;

  @override
  void initState() {
    super.initState();
    _questionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _optionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _questionAnimation = CurvedAnimation(
      parent: _questionAnimationController,
      curve: Curves.easeInOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _optionAnimationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _questionAnimationController.dispose();
    _optionAnimationController.dispose();
    _examTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _examTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  void _stopTimer() {
    _examTimer?.cancel();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vocabulary Exam',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _formatTime(_secondsElapsed),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<ExamBloc, ExamState>(
        listener: (context, state) {
          if (state is ExamInProgressState) {
            _startTimer();
            _questionAnimationController.forward();
            _optionAnimationController.forward();
          } else if (state is ExamCompletedState) {
            _stopTimer();
            _showResultDialog(state);
          } else if (state is ExamErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ExamInitialState) {
            return _buildExamSetup();
          }

          if (state is ExamLoadingState) {
            return _buildLoadingState();
          }

          if (state is ExamGeneratedState) {
            return _buildExamReady(state);
          }

          if (state is ExamInProgressState) {
            return _buildExamInProgress(state);
          }

          if (state is ExamCompletedState) {
            return _buildExamCompleted(state);
          }

          if (state is ExamErrorState) {
            return _buildErrorState(state);
          }

          return _buildExamSetup();
        },
      ),
    );
  }

  Widget _buildExamSetup() {
    String? selectedCategory;
    int? selectedDifficulty;
    int questionCount = 10;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.quiz,
                size: 100,
                color: AppColors.primaryColor,
              ),
              const SizedBox(height: 30),
              const Text(
                'Ready for your vocabulary exam?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'Exam Settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Question count
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Number of Questions:'),
                          DropdownButton<int>(
                            value: questionCount,
                            items: [5, 10, 15, 20]
                                .map((count) => DropdownMenuItem(
                                      value: count,
                                      child: Text('$count'),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                questionCount = value!;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // Difficulty
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Difficulty:'),
                          DropdownButton<int?>(
                            value: selectedDifficulty,
                            hint: const Text('Any'),
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('Any'),
                              ),
                              const DropdownMenuItem(
                                value: 1,
                                child: Text('Easy'),
                              ),
                              const DropdownMenuItem(
                                value: 2,
                                child: Text('Medium'),
                              ),
                              const DropdownMenuItem(
                                value: 3,
                                child: Text('Hard'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedDifficulty = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<ExamBloc>().add(
                          GenerateExamEvent(
                            category: selectedCategory,
                            difficulty: selectedDifficulty,
                            questionCount: questionCount,
                          ),
                        );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Generate Exam',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          ),
          SizedBox(height: 20),
          Text(
            'Preparing your exam...',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamReady(ExamGeneratedState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.timer,
            size: 80,
            color: AppColors.primaryColor,
          ),
          const SizedBox(height: 30),
          const Text(
            'Exam Ready!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${state.questions.length} questions prepared',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 40),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.primaryColor,
                    size: 40,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Instructions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    '• Choose the best answer for each question\n'
                    '• You can navigate between questions\n'
                    '• Your progress is automatically saved\n'
                    '• Take your time and do your best!',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                context.read<ExamBloc>().add(StartExamEvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Start Exam',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamInProgress(ExamInProgressState state) {
    final currentQuestion = state.questions[state.currentQuestionIndex];

    return Column(
      children: [
        // Progress section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryColor,
                AppColors.primaryColor.withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${state.currentQuestionIndex + 1}/${state.questions.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Answered: ${state.answeredCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ProgressBar(
                progress: state.progress,
                backgroundColor: Colors.white.withOpacity(0.3),
                progressColor: Colors.white,
                height: 8,
              ),
            ],
          ),
        ),

        // Question section
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: FadeTransition(
                    opacity: _questionAnimation,
                    child: _buildQuestionCard(currentQuestion, state),
                  ),
                ),

                // Navigation buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: !state.isFirstQuestion
                          ? () {
                              context
                                  .read<ExamBloc>()
                                  .add(PreviousQuestionEvent());
                              _questionAnimationController.reset();
                              _questionAnimationController.forward();
                            }
                          : null,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                      ),
                    ),
                    if (state.answeredCount == state.questions.length)
                      ElevatedButton.icon(
                        onPressed: () => _showSubmitDialog(),
                        icon: const Icon(Icons.check),
                        label: const Text('Submit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ElevatedButton.icon(
                      onPressed: !state.isLastQuestion
                          ? () {
                              context.read<ExamBloc>().add(NextQuestionEvent());
                              _questionAnimationController.reset();
                              _questionAnimationController.forward();
                            }
                          : null,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(ExamQuestion question, ExamInProgressState state) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question text
            Text(
              question.question,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 20),

            // Options
            Expanded(
              child: ListView.builder(
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  return SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: _buildOptionCard(
                        question.options[index],
                        index,
                        state.userAnswers[state.currentQuestionIndex] == index,
                        state.currentQuestionIndex,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    String option,
    int index,
    bool isSelected,
    int questionIndex,
  ) {
    return InkWell(
      onTap: () {
        context.read<ExamBloc>().add(
              AnswerQuestionEvent(
                questionIndex: questionIndex,
                selectedAnswerIndex: index,
              ),
            );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withOpacity(0.1)
              : Colors.grey[50],
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColor : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C, D
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? AppColors.primaryColor : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamCompleted(ExamCompletedState state) {
    final percentage = state.result.percentage;
    final isGoodScore = percentage >= 70;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isGoodScore ? Icons.celebration : Icons.emoji_events,
            size: 100,
            color: isGoodScore ? Colors.green : Colors.orange,
          ),
          const SizedBox(height: 30),
          Text(
            isGoodScore ? 'Excellent Work!' : 'Good Effort!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isGoodScore ? Colors.green : Colors.orange,
            ),
          ),
          const SizedBox(height: 40),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: isGoodScore ? Colors.green : Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${state.result.score}/${state.result.totalQuestions} Correct',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Time: ${_formatTime(state.result.timeSpent)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<ExamBloc>().add(ResetExamEvent());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('Home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ExamErrorState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[400],
          ),
          const SizedBox(height: 20),
          Text(
            'Oops! Something went wrong',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red[400],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            state.message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              context.read<ExamBloc>().add(ResetExamEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _showSubmitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Exam'),
        content: const Text(
          'Are you sure you want to submit your exam? '
          'You won\'t be able to make changes after submission.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ExamBloc>().add(SubmitExamEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showResultDialog(ExamCompletedState state) {
    final percentage = state.result.percentage;
    final isGoodScore = percentage >= 70;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          isGoodScore ? '🎉 Congratulations!' : '👍 Well Done!',
          style: TextStyle(
            color: isGoodScore ? Colors.green : Colors.orange,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You scored ${percentage.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${state.result.score} out of ${state.result.totalQuestions} correct',
            ),
            if (isGoodScore) ...[
              const SizedBox(height: 15),
              const Text(
                'Great job! Keep up the excellent work!',
                style: TextStyle(color: Colors.green),
                textAlign: TextAlign.center,
              ),
            ] else ...[
              const SizedBox(height: 15),
              const Text(
                'Good effort! Practice more to improve your score.',
                style: TextStyle(color: Colors.orange),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
