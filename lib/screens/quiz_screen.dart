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

  List<QuizResult> _quizResults = [];
  List<QuizAttendResult> _quizAttendResults = [];

  String? errorMessage;

  Timer? _questionTimer;
  int _timeSpent = 0;
  DateTime? _questionStartTime;
  DateTime? _quizStartTime;

  int? _currentSessionId;

  // Store shuffled choices for each question
  Map<int, List<String>> _shuffledChoices = {};

  @override
  void initState() {
    super.initState();
    _quizStartTime = DateTime.now();
    _loadVocabulary();
  }

  @override
  void dispose() {
    _questionTimer?.cancel();
    if (_currentSessionId != null) {
      _apiService.abandonQuizSession(_currentSessionId!);
    }
    super.dispose();
  }

  Future<void> _loadVocabulary() async {
    try {
      final words = await _apiService.getVocabularyByDifficulty(
        difficulty: widget.difficulty,
        count: widget.limit,
      );
      final sessionId = await _apiService.startQuizSession(
        testType: widget.testType,
        difficulty: widget.difficulty,
        totalQuestions: widget.limit,
      );

      setState(() {
        _vocabularyList = words;
        _currentSessionId = sessionId;
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

  List<String> _getShuffledChoices(int questionIndex) {
    // If already shuffled for this question, return cached version
    if (_shuffledChoices.containsKey(questionIndex)) {
      return _shuffledChoices[questionIndex]!;
    }

    // Get the original choices
    final currentWord = _vocabularyList[questionIndex];
    final choices = widget.testType == 'synonyms'
        ? (currentWord.synonymChoices ?? [])
        : widget.testType == 'antonyms'
            ? (currentWord.antonymChoices ?? [])
            : (currentWord.meaningChoices ?? []);

    // Create a copy and shuffle
    final shuffled = List<String>.from(choices)..shuffle();

    // Cache the shuffled choices
    _shuffledChoices[questionIndex] = shuffled;

    return shuffled;
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
      correctAnswerText =
          correctAnswers.isNotEmpty ? correctAnswers.first : _selectedAnswer!;
    }

    final quizResult = QuizResult(
      quizSessionId: _currentSessionId,
      wordId: currentWord.id,
      testType: widget.testType,
      userAnswer: _selectedAnswer!,
      isCorrect: isCorrect,
      timeSpent: _timeSpent,
    );
    _quizResults.add(quizResult);

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

    try {
      final totalTime = DateTime.now().difference(_quizStartTime!).inSeconds;
      final incorrectCount = _vocabularyList.length - _score;

      if (_currentSessionId != null) {
        await _apiService.finishQuizSession(
          sessionId: _currentSessionId!,
          correctCount: _score,
          incorrectCount: incorrectCount,
          totalTimeSeconds: totalTime,
        );
        _currentSessionId = null;
      }
      await _apiService.saveQuizResults(_quizResults);
    } catch (e) {
      print('Error saving results: $e');
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
          score: _score,
          total: _vocabularyList.length,
          results: _quizAttendResults,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 44,
                  height: 44,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3.5,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Loading Quiz...',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_vocabularyList.isEmpty) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'No vocabulary words found',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentWord = _vocabularyList[_currentQuestionIndex];
    final choices = _getShuffledChoices(_currentQuestionIndex);

    final correctAnswer =
        widget.testType == 'meaning' ? currentWord.definition : null;
    final correctAnswers = widget.testType == 'synonyms'
        ? currentWord.synonyms.cast<String>()
        : widget.testType == 'antonyms'
            ? currentWord.antonyms.cast<String>()
            : <String>[];

    if (choices.isEmpty) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning_amber_rounded,
                    size: 64, color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'No answer choices available',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    child: Column(
                      children: [
                        _buildProgressBar(),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildScoreTimer(),
                                SizedBox(height: 12),
                                _buildQuestionCard(currentWord),
                                SizedBox(height: 16),
                                ...choices.map((choice) {
                                  return _buildAnswerChoice(
                                    choice,
                                    correctAnswer,
                                    correctAnswers,
                                  );
                                }).toList(),
                                SizedBox(height: 16),
                                if (!_showResult) _buildSubmitButton(),
                              ],
                            ),
                          ),
                        ),
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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: Colors.white),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
          SizedBox(width: 12),
          Icon(Icons.quiz, color: Colors.white, size: 24),
          SizedBox(width: 8),
          Text(
            'Quiz',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.list_alt, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text(
                  '${_currentQuestionIndex + 1}/${_vocabularyList.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return LinearProgressIndicator(
      value: (_currentQuestionIndex + 1) / _vocabularyList.length,
      backgroundColor: Color(0xFFE5E7EB),
      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
      minHeight: 6,
    );
  }

  Widget _buildScoreTimer() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.white, size: 18),
                SizedBox(width: 6),
                Text(
                  'Score: $_score',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer, color: Colors.white, size: 18),
                SizedBox(width: 6),
                Text(
                  '$_timeSpent s',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(VocabularyCard currentWord) {
    IconData questionIcon;
    String questionText;
    Color accentColor;

    if (widget.testType == 'synonyms') {
      questionIcon = Icons.compare_arrows;
      questionText = 'Find the Synonym';
      accentColor = Color(0xFF3B82F6);
    } else if (widget.testType == 'antonyms') {
      questionIcon = Icons.swap_horiz;
      questionText = 'Find the Antonym';
      accentColor = Color(0xFFEF4444);
    } else {
      questionIcon = Icons.help_outline;
      questionText = 'What does this mean?';
      accentColor = Color(0xFF8B5CF6);
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withOpacity(0.08),
            accentColor.withOpacity(0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(questionIcon, color: accentColor, size: 16),
              ),
              SizedBox(width: 8),
              Text(
                questionText,
                style: TextStyle(
                  fontSize: 14,
                  color: accentColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  currentWord.word,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  currentWord.pronunciation,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          if (widget.testType != 'meaning') ...[
            SizedBox(height: 10),
            Text(
              currentWord.definition,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF4B5563),
                height: 1.4,
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.format_quote, size: 14, color: Color(0xFF6B7280)),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      currentWord.example,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnswerChoice(
    String choice,
    String? correctAnswer,
    List<String> correctAnswers,
  ) {
    final isSelected = _selectedAnswer == choice;

    bool isCorrect;
    if (widget.testType == 'meaning') {
      isCorrect = choice == correctAnswer;
    } else {
      isCorrect = correctAnswers.contains(choice);
    }

    Color cardColor = Colors.white;
    Color borderColor = Color(0xFFE5E7EB);
    Color textColor = Color(0xFF1F2937);

    if (_showResult && isSelected) {
      if (isCorrect) {
        cardColor = Color(0xFF10B981).withOpacity(0.1);
        borderColor = Color(0xFF10B981);
        textColor = Color(0xFF10B981);
      } else {
        cardColor = Color(0xFFEF4444).withOpacity(0.1);
        borderColor = Color(0xFFEF4444);
        textColor = Color(0xFFEF4444);
      }
    } else if (isSelected) {
      borderColor = Color(0xFF3B82F6);
      cardColor = Color(0xFF3B82F6).withOpacity(0.05);
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showResult
              ? null
              : () => setState(() => _selectedAnswer = choice),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor, width: 2),
                    color: isSelected ? borderColor : Colors.transparent,
                  ),
                  child: isSelected
                      ? Icon(Icons.check, color: Colors.white, size: 12)
                      : null,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    choice,
                    style: TextStyle(
                      fontSize: widget.testType == 'meaning' ? 13 : 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                    maxLines: widget.testType == 'meaning' ? 3 : 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_showResult && isCorrect)
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, color: Colors.white, size: 16),
                  ),
                if (_showResult && isSelected && !isCorrect)
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 16),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _selectedAnswer == null ? null : _submitAnswer,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF3B82F6),
        disabledBackgroundColor: Color(0xFFE5E7EB),
        padding: EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.send,
            color: _selectedAnswer == null ? Color(0xFF9CA3AF) : Colors.white,
            size: 18,
          ),
          SizedBox(width: 8),
          Text(
            'Submit Answer',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _selectedAnswer == null ? Color(0xFF9CA3AF) : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
