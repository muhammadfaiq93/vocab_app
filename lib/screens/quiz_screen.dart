import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../models/vocabulary_card.dart';
import '../models/quiz_result.dart';
import 'quiz_result_screen.dart';
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
  final ApiService _apiService = ApiService();

  List<VocabularyCard> _vocabularyList = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool isLoading = true;
  String? _selectedAnswer;
  bool _showResult = false;

  // For API submission
  List<QuizResult> _quizResults = [];

  // For display in results screen
  List<QuizAttendResult> _quizAttendResults = [];

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
    try {
      final words = await _apiService.getVocabularyByDifficulty(
        difficulty: widget.difficulty,
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

    bool isCorrect;
    String correctAnswerText;

    if (widget.testType == 'meaning') {
      correctAnswerText = currentWord.definition;
      isCorrect = _selectedAnswer == correctAnswerText;
    } else {
      final correctAnswers = widget.testType == 'synonyms'
          ? currentWord.synonyms
          : currentWord.antonyms;
      isCorrect = correctAnswers.contains(_selectedAnswer);
      // Get first correct answer for display
      correctAnswerText =
          correctAnswers.isNotEmpty ? correctAnswers.first : _selectedAnswer!;
    }

    // Save quiz result for API
    final quizResult = QuizResult(
      wordId: currentWord.id,
      testType: widget.testType,
      userAnswer: _selectedAnswer!,
      isCorrect: isCorrect,
      timeSpent: _timeSpent,
    );
    _quizResults.add(quizResult);

    // Save quiz attend result for display
    final quizAttendResult = QuizAttendResult(
      word: currentWord.word,
      selectedAnswer: _selectedAnswer!,
      correctAnswer: correctAnswerText,
    );
    _quizAttendResults.add(quizAttendResult);

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
      await _apiService.saveQuizResults(_quizResults);
    } catch (e) {
      print('Error saving results: $e');
    }

    // Navigate to results screen with display data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
          score: _score,
          total: _vocabularyList.length,
          results: _quizAttendResults, // Pass the display data
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
    final choices = widget.testType == 'synonyms'
        ? (currentWord.synonymChoices ?? [])
        : widget.testType == 'antonyms'
            ? (currentWord.antonymChoices ?? [])
            : (currentWord.meaningChoices ?? []);

    final correctAnswer =
        widget.testType == 'meaning' ? currentWord.definition : null;
    final correctAnswers = widget.testType == 'synonyms'
        ? currentWord.synonyms
        : widget.testType == 'antonyms'
            ? currentWord.antonyms
            : [];

    if (choices.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
          backgroundColor: Color(0xFF3B82F6),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded, size: 64, color: Colors.orange),
              SizedBox(height: 16),
              Text(
                'No answer choices available',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'for "${currentWord.word}"',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
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
                              : widget.testType == 'antonyms'
                                  ? 'Find the Antonym'
                                  : 'What does this word mean?',
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
                        if (widget.testType != 'meaning') ...[
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
                        ] else ...[
                          SizedBox(height: 12),
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(0xFFF0F9FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Select the correct definition',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF3B82F6),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  ...choices.map((choice) {
                    final isSelected = _selectedAnswer == choice;

                    bool isCorrect;
                    if (widget.testType == 'meaning') {
                      isCorrect = choice == correctAnswer;
                    } else {
                      isCorrect = correctAnswers.contains(choice);
                    }

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
                                    fontSize:
                                        widget.testType == 'meaning' ? 15 : 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1F2937),
                                  ),
                                  maxLines:
                                      widget.testType == 'meaning' ? 3 : 2,
                                  overflow: TextOverflow.ellipsis,
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
