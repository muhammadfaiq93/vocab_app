import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class QuizScreen extends StatefulWidget {
  final String quizType;
  final int questionCount;

  QuizScreen({
    this.quizType = 'Mixed',
    this.questionCount = 10,
  });

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedAnswer;
  bool showResult = false;
  bool isAnswered = false;
  bool quizCompleted = false;
  Timer? _timer;
  int timeLeft = 30; // 30 seconds per question
  List<int> userAnswers = [];

  // Sample quiz data - you can replace with your vocabulary API data
  final List<Map<String, dynamic>> quizQuestions = [
    {
      'question': 'What does "Serendipity" mean?',
      'type': 'meaning',
      'options': [
        'A planned discovery',
        'The fact of finding something valuable by chance',
        'A type of musical instrument',
        'A scientific method'
      ],
      'correctAnswer': 1,
      'word': 'Serendipity',
      'explanation':
          'Serendipity refers to finding something valuable or pleasant unexpectedly.'
    },
    {
      'question': 'Which sentence uses "Ephemeral" correctly?',
      'type': 'usage',
      'options': [
        'The ephemeral building lasted for centuries',
        'His ephemeral mood lasted all week',
        'The beauty of cherry blossoms is ephemeral',
        'She bought an ephemeral car'
      ],
      'correctAnswer': 2,
      'word': 'Ephemeral',
      'explanation':
          'Ephemeral means lasting for a very short time, so cherry blossoms\' brief blooming period is ephemeral.'
    },
    {
      'question': 'What part of speech is "Mellifluous"?',
      'type': 'grammar',
      'options': ['Noun', 'Verb', 'Adjective', 'Adverb'],
      'correctAnswer': 2,
      'word': 'Mellifluous',
      'explanation':
          'Mellifluous is an adjective meaning sweet-sounding or musical.'
    },
    {
      'question': 'What does "Ubiquitous" mean?',
      'type': 'meaning',
      'options': [
        'Very rare and unique',
        'Present everywhere',
        'Extremely expensive',
        'Hard to understand'
      ],
      'correctAnswer': 1,
      'word': 'Ubiquitous',
      'explanation': 'Ubiquitous means present, appearing, or found everywhere.'
    },
    {
      'question': 'Which word means "showing great attention to detail"?',
      'type': 'synonym',
      'options': ['Careless', 'Meticulous', 'Hasty', 'Approximate'],
      'correctAnswer': 1,
      'word': 'Meticulous',
      'explanation':
          'Meticulous means showing great attention to detail; very careful and precise.'
    },
    {
      'question': 'Choose the correct pronunciation of "Ethereal"',
      'type': 'pronunciation',
      'options': ['/ɪˈθɪəriəl/', '/ˈiːθərəl/', '/ɛˈθɛriəl/', '/ˈɛθəriəl/'],
      'correctAnswer': 0,
      'word': 'Ethereal',
      'explanation':
          'Ethereal is pronounced /ɪˈθɪəriəl/ meaning extremely delicate and light.'
    },
    {
      'question': 'What does "Perfunctory" mean?',
      'type': 'meaning',
      'options': [
        'Done with great care',
        'Done as a duty without real interest',
        'Done perfectly',
        'Done repeatedly'
      ],
      'correctAnswer': 1,
      'word': 'Perfunctory',
      'explanation':
          'Perfunctory means carried out with minimal effort or reflection; routine.'
    },
    {
      'question': 'Which sentence uses "Palpable" correctly?',
      'type': 'usage',
      'options': [
        'The palpable car was very expensive',
        'Her palpable excitement filled the room',
        'He wore a palpable shirt',
        'The palpable book was interesting'
      ],
      'correctAnswer': 1,
      'word': 'Palpable',
      'explanation':
          'Palpable means able to be touched or felt; so intense as to be almost touchable.'
    },
    {
      'question': 'What is the opposite of "Verbose"?',
      'type': 'antonym',
      'options': ['Talkative', 'Lengthy', 'Concise', 'Detailed'],
      'correctAnswer': 2,
      'word': 'Verbose',
      'explanation':
          'Verbose means using more words than needed. Its opposite is concise (brief and clear).'
    },
    {
      'question': 'What does "Magnanimous" mean?',
      'type': 'meaning',
      'options': [
        'Very large in size',
        'Generous in forgiving',
        'Extremely angry',
        'Highly intelligent'
      ],
      'correctAnswer': 1,
      'word': 'Magnanimous',
      'explanation':
          'Magnanimous means generous or forgiving, especially toward a rival or less powerful person.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);

    // Shuffle questions for variety
    quizQuestions.shuffle();

    // Start the first question
    startTimer();
    _fadeController.forward();
  }

  void startTimer() {
    timeLeft = 30;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          timeLeft--;
          if (timeLeft <= 0) {
            _handleTimeout();
          }
        });
      }
    });
  }

  void _handleTimeout() {
    if (!isAnswered) {
      setState(() {
        isAnswered = true;
        selectedAnswer = -1; // Indicate timeout
        userAnswers.add(-1);
      });
      _timer?.cancel();

      Future.delayed(Duration(seconds: 2), () {
        _nextQuestion();
      });
    }
  }

  void _selectAnswer(int answerIndex) {
    if (isAnswered) return;

    setState(() {
      selectedAnswer = answerIndex;
      isAnswered = true;
      showResult = true;
      userAnswers.add(answerIndex);

      if (answerIndex == quizQuestions[currentQuestionIndex]['correctAnswer']) {
        score++;
      }
    });

    _timer?.cancel();

    // Show result for 2 seconds then move to next question
    Future.delayed(Duration(seconds: 2), () {
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < widget.questionCount - 1 &&
        currentQuestionIndex < quizQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        isAnswered = false;
        showResult = false;
        _progressController
            .animateTo((currentQuestionIndex + 1) / widget.questionCount);
      });

      _fadeController.reset();
      _fadeController.forward();
      startTimer();
    } else {
      _completeQuiz();
    }
  }

  void _completeQuiz() {
    setState(() {
      quizCompleted = true;
    });
    _timer?.cancel();
  }

  void _restartQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      selectedAnswer = null;
      showResult = false;
      isAnswered = false;
      quizCompleted = false;
      userAnswers.clear();
      _progressController.reset();
    });

    quizQuestions.shuffle();
    startTimer();
    _fadeController.reset();
    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (quizCompleted) {
      return _buildResultScreen();
    }

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
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                _buildQuizHeader(),
                SizedBox(height: 20),
                _buildProgressBar(),
                SizedBox(height: 30),
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildQuestionCard(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuizHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
        ),
        Column(
          children: [
            Text(
              '${widget.quizType} Quiz',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Question ${currentQuestionIndex + 1} of ${widget.questionCount}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: timeLeft <= 10 ? Colors.red : Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(
                Icons.timer,
                color: Colors.white,
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                '${timeLeft}s',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Score: $score/${currentQuestionIndex + (isAnswered ? 1 : 0)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        AnimatedBuilder(
          animation: _progressController,
          builder: (context, child) {
            return LinearProgressIndicator(
              value: (currentQuestionIndex + (isAnswered ? 1 : 0)) /
                  widget.questionCount,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 6,
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuestionCard() {
    final question = quizQuestions[currentQuestionIndex];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Type Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getQuestionTypeColor(question['type']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getQuestionTypeLabel(question['type']),
              style: TextStyle(
                color: _getQuestionTypeColor(question['type']),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 20),

          // Question
          Text(
            question['question'],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
              height: 1.4,
            ),
          ),
          SizedBox(height: 30),

          // Answer Options
          Expanded(
            child: ListView.builder(
              itemCount: question['options'].length,
              itemBuilder: (context, index) {
                return _buildAnswerOption(index, question['options'][index],
                    question['correctAnswer']);
              },
            ),
          ),

          // Show explanation if answered
          if (showResult) _buildExplanation(question),
        ],
      ),
    );
  }

  Widget _buildAnswerOption(int index, String option, int correctAnswer) {
    Color backgroundColor = Colors.grey.shade100;
    Color borderColor = Colors.grey.shade300;
    Color textColor = Color(0xFF1F2937);
    IconData? icon;

    if (isAnswered) {
      if (index == correctAnswer) {
        backgroundColor = Colors.green.shade100;
        borderColor = Colors.green.shade400;
        textColor = Colors.green.shade700;
        icon = Icons.check_circle;
      } else if (index == selectedAnswer && selectedAnswer != correctAnswer) {
        backgroundColor = Colors.red.shade100;
        borderColor = Colors.red.shade400;
        textColor = Colors.red.shade700;
        icon = Icons.cancel;
      }
    } else if (selectedAnswer == index) {
      backgroundColor = Color(0xFF6366F1).withOpacity(0.1);
      borderColor = Color(0xFF6366F1);
      textColor = Color(0xFF6366F1);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _selectAnswer(index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isAnswered && index == correctAnswer
                      ? Colors.green.shade400
                      : isAnswered &&
                              index == selectedAnswer &&
                              selectedAnswer != correctAnswer
                          ? Colors.red.shade400
                          : borderColor,
                ),
                child: Center(
                  child: icon != null
                      ? Icon(icon, color: Colors.white, size: 16)
                      : Text(
                          String.fromCharCode(65 + index), // A, B, C, D
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExplanation(Map<String, dynamic> question) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: Color(0xFFFBBF24), size: 20),
              SizedBox(width: 8),
              Text(
                'Explanation',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            question['explanation'],
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    double percentage = (score / widget.questionCount) * 100;
    String grade = _getGrade(percentage);
    Color gradeColor = _getGradeColor(percentage);

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
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: Colors.white, size: 28),
                    ),
                    Text(
                      'Quiz Results',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 48), // Balance the row
                  ],
                ),
                SizedBox(height: 40),

                // Results Card
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Grade Circle
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: gradeColor.withOpacity(0.1),
                            border: Border.all(color: gradeColor, width: 4),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                grade,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: gradeColor,
                                ),
                              ),
                              Text(
                                '${percentage.toInt()}%',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: gradeColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 32),

                        Text(
                          _getResultMessage(percentage),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),

                        Text(
                          'You scored $score out of ${widget.questionCount} questions correctly!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF6B7280),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 40),

                        // Stats
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem('Correct', '$score', Colors.green),
                            _buildStatItem('Wrong',
                                '${widget.questionCount - score}', Colors.red),
                            _buildStatItem('Accuracy', '${percentage.toInt()}%',
                                Color(0xFF6366F1)),
                          ],
                        ),

                        Spacer(),

                        // Action Buttons
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _restartQuiz,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF6366F1),
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Try Again',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Color(0xFF6366F1)),
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Back to Home',
                                  style: TextStyle(
                                    color: Color(0xFF6366F1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Color _getQuestionTypeColor(String type) {
    switch (type) {
      case 'meaning':
        return Color(0xFF10B981);
      case 'usage':
        return Color(0xFF6366F1);
      case 'grammar':
        return Color(0xFFF59E0B);
      case 'pronunciation':
        return Color(0xFFEF4444);
      case 'synonym':
        return Color(0xFF8B5CF6);
      case 'antonym':
        return Color(0xFF06B6D4);
      default:
        return Color(0xFF6B7280);
    }
  }

  String _getQuestionTypeLabel(String type) {
    switch (type) {
      case 'meaning':
        return 'Meaning';
      case 'usage':
        return 'Usage';
      case 'grammar':
        return 'Grammar';
      case 'pronunciation':
        return 'Pronunciation';
      case 'synonym':
        return 'Synonym';
      case 'antonym':
        return 'Antonym';
      default:
        return 'Mixed';
    }
  }

  String _getGrade(double percentage) {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B';
    if (percentage >= 60) return 'C';
    if (percentage >= 50) return 'D';
    return 'F';
  }

  Color _getGradeColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getResultMessage(double percentage) {
    if (percentage >= 90) return 'Outstanding! 🎉';
    if (percentage >= 80) return 'Excellent Work! 👏';
    if (percentage >= 70) return 'Great Job! 🌟';
    if (percentage >= 60) return 'Good Effort! 👍';
    if (percentage >= 50) return 'Keep Practicing! 💪';
    return 'Try Again! 📚';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
}
