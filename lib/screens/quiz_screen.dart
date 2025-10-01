import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../models/vocabulary_card.dart';
import '../models/quiz_result.dart';
import '../services/api_service.dart';

class QuizScreen extends StatefulWidget {
  final int difficulty;
  final int limit;
  final String testType;

  const QuizScreen({
    Key? key,
    required this.difficulty,
    required this.limit,
    required this.testType,
  }) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // final VocabularyApiService _apiService = VocabularyApiService();
  final ApiService _apiService = ApiService();

  List<VocabularyCard> _vocabularyList = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool isLoading = true;
  String? _selectedAnswer;
  bool _showResult = false;
  List<QuizResult> _quizResults = [];
  String? errorMessage;

  Timer? _questionTimer;
  int _timeSpent = 0;
  DateTime? _questionStartTime;

  @override
  void initState() {
    super.initState();
    _loadVocabulary();
  }

  @override
  void dispose() {
    _questionTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadVocabulary() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) {
      setState(() {
        errorMessage = 'Please login to continue';
        isLoading = false;
      });
      return;
    }
    try {
      final words = await _apiService.getVocabularyByDifficulty(
        token: authState.token,
        difficulty: widget.difficulty, // Pass from modal
        count: widget.limit,
      );

      setState(() {
        _vocabularyList = words;
        isLoading = false;
      });

      _startQuestionTimer();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading quiz: $e')),
      );
    }
  }

  void _startQuestionTimer() {
    _questionStartTime = DateTime.now();
    _timeSpent = 0;
    _questionTimer?.cancel();
    _questionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timeSpent++;
      });
    });
  }

  void _submitAnswer() {
    if (_selectedAnswer == null) return;

    _questionTimer?.cancel();

    final currentWord = _vocabularyList[_currentQuestionIndex];
    final correctAnswers = widget.testType == 'synonyms'
        ? currentWord.synonyms
        : currentWord.antonyms;

    final isCorrect = correctAnswers.contains(_selectedAnswer);

    // Save quiz result
    final quizResult = QuizResult(
      wordId: currentWord.id,
      testType: widget.testType,
      userAnswer: _selectedAnswer!,
      isCorrect: isCorrect,
      timeSpent: _timeSpent,
    );

    _quizResults.add(quizResult);

    if (isCorrect) {
      setState(() {
        _score++;
      });
    }

    setState(() {
      _showResult = true;
    });

    // Auto move to next question after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _vocabularyList.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _showResult = false;
      });
      _startQuestionTimer();
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    _questionTimer?.cancel();

    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) {
      setState(() {
        errorMessage = 'Please login to continue';
        isLoading = false;
      });
      return;
    }

    // Save all results to API
    try {
      await _apiService.saveQuizResults(authState.token, _quizResults);
    } catch (e) {
      print('Error saving results: $e');
    }

    // Show results screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
          score: _score,
          total: _vocabularyList.length,
          results: _quizResults,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Loading Quiz...', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      );
    }

    if (_vocabularyList.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Quiz')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text('No vocabulary words found', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final currentWord = _vocabularyList[_currentQuestionIndex];
    final choices = (widget.testType == 'synonyms'
            ? currentWord.synonymChoices
            : currentWord.antonymChoices) ??
        [];
    final correctAnswers = (widget.testType == 'synonyms'
            ? currentWord.synonyms
            : currentWord.antonyms) ??
        [];

    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Color(0xFF3B82F6),
        elevation: 0,
        title: Text('Quiz', style: TextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                '${_currentQuestionIndex + 1}/${_vocabularyList.length}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _vocabularyList.length,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
            minHeight: 8,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Score and Timer Card
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF3B82F6).withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.white, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Score: $_score',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.timer, color: Colors.white, size: 24),
                            SizedBox(width: 8),
                            Text(
                              '$_timeSpent s',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Question Card
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
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
                        Text(
                          widget.testType == 'synonyms'
                              ? 'Find the Synonym'
                              : 'Find the Antonym',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          currentWord.word,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          currentWord.pronunciation,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF9CA3AF),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          currentWord.definition,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '"${currentWord.example}"',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Answer Choices
                  ...choices.map((choice) {
                    final isSelected = _selectedAnswer == choice;
                    final isCorrect = correctAnswers.contains(choice);

                    Color cardColor = Colors.white;
                    Color borderColor = Colors.grey[200]!;

                    if (_showResult && isSelected) {
                      cardColor = isCorrect
                          ? Color(0xFF10B981).withOpacity(0.1)
                          : Color(0xFFEF4444).withOpacity(0.1);
                      borderColor =
                          isCorrect ? Color(0xFF10B981) : Color(0xFFEF4444);
                    } else if (isSelected) {
                      borderColor = Color(0xFF3B82F6);
                    }

                    return Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: _showResult
                            ? null
                            : () => setState(() => _selectedAnswer = choice),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          padding: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                  color: isSelected
                                      ? borderColor
                                      : Colors.transparent,
                                ),
                                child: isSelected
                                    ? Icon(Icons.check,
                                        color: Colors.white, size: 16)
                                    : null,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  choice,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                              ),
                              if (_showResult && isCorrect)
                                Icon(Icons.check_circle,
                                    color: Color(0xFF10B981), size: 28),
                              if (_showResult && isSelected && !isCorrect)
                                Icon(Icons.cancel,
                                    color: Color(0xFFEF4444), size: 28),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),

                  SizedBox(height: 24),

                  // Submit Button
                  if (!_showResult)
                    ElevatedButton(
                      onPressed: _selectedAnswer == null ? null : _submitAnswer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3B82F6),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Submit Answer',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Quiz Result Screen
class QuizResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final List<QuizResult> results;

  const QuizResultScreen({
    Key? key,
    required this.score,
    required this.total,
    required this.results,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = (score / total * 100).round();

    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF3B82F6).withOpacity(0.3),
                      blurRadius: 30,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Text(
                  percentage >= 70
                      ? '🎉'
                      : percentage >= 50
                          ? '👍'
                          : '💪',
                  style: TextStyle(fontSize: 80),
                ),
              ),
              SizedBox(height: 32),
              Text(
                percentage >= 70
                    ? 'Excellent!'
                    : percentage >= 50
                        ? 'Good Job!'
                        : 'Keep Practicing!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'You scored',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF6B7280),
                ),
              ),
              SizedBox(height: 8),
              Text(
                '$score / $total',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B82F6),
                ),
              ),
              SizedBox(height: 8),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
              SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3B82F6),
                  padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Back to Home',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
