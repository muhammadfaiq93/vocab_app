import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../services/api_service.dart';
import '../models/vocabulary_card.dart';

class DynamicLearningScreen extends StatefulWidget {
  final int wordCount;
  final int difficulty; // Add this
  final String? categoryName; // Add this for display

  const DynamicLearningScreen({
    Key? key,
    required this.wordCount,
    required this.difficulty,
    this.categoryName,
  }) : super(key: key);

  @override
  _DynamicLearningScreenState createState() => _DynamicLearningScreenState();
}

class _DynamicLearningScreenState extends State<DynamicLearningScreen> {
  int currentWordIndex = 0;
  List<VocabularyCard> vocabularyCards = [];
  bool isLoading = true;
  String? errorMessage;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchVocabulary();
  }

  Future<void> _fetchVocabulary() async {
    try {
      final cards = await _apiService.getVocabularyByDifficulty(
        difficulty: widget.difficulty, // Pass from modal
        count: widget.wordCount,
      );

      setState(() {
        vocabularyCards = cards;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return Scaffold(
            body: Center(child: Text('Please log in to access learning')),
          );
        }

        final user = state.user;

        if (isLoading) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Loading ${(widget.wordCount - 10)} To ${widget.wordCount} words...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (errorMessage != null) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.white, size: 64),
                      SizedBox(height: 16),
                      Text(
                        'Oops!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });
                          _fetchVocabulary();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFF6366F1),
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Try Again',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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

        if (vocabularyCards.isEmpty) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
              ),
              child: Center(
                child: Text(
                  'No vocabulary words found',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          );
        }

        final currentCard = vocabularyCards[currentWordIndex];

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(user),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _buildProgressIndicator(),
                            SizedBox(height: 20),
                            _buildWordCard(currentCard),
                            SizedBox(height: 30),
                            _buildNavigationButtons(),
                            SizedBox(height: 20),
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
      },
    );
  }

  Widget _buildHeader(dynamic user) {
    String userName = '';
    if (user is Map<String, dynamic>) {
      userName = user['name']?.toString().trim() ?? '';
    } else {
      userName = user?.name?.toString().trim() ?? '';
    }

    String firstName = userName.isNotEmpty ? userName.split(' ').first : 'User';
    String userInitial =
        firstName.isNotEmpty ? firstName[0].toUpperCase() : 'U';

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
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Text(
                      userInitial,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    firstName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: Colors.white, size: 24),
              ),
            ],
          ),
          SizedBox(height: 25),
          Text(
            "Today's Word!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Learning ${vocabularyCards.length} words from ${(widget.wordCount - 10)} to ${widget.wordCount} amazing words',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordCard(VocabularyCard card) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Word Title
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 32),
              decoration: BoxDecoration(
                color: Color(0xFFF8F9FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                card.word,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
          ),
          SizedBox(height: 24),

          // Category
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Category:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  card.category,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Pronunciation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pronunciation:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  card.pronunciation,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),

          // Definition
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(0xFFFBBF24).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.lightbulb,
                  color: Color(0xFFFBBF24),
                  size: 18,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Definition',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.only(left: 32),
            child: Text(
              card.definition,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 24),

          // Example
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.format_quote,
                  color: Color(0xFF10B981),
                  size: 18,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Example',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.only(left: 32),
            child: Text(
              '"${card.example}"',
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
          ),

          if (card.synonyms.isNotEmpty) ...[
            SizedBox(height: 24),
            _buildWordList('Synonyms', card.synonyms, Color(0xFF6366F1)),
          ],

          if (card.antonyms.isNotEmpty) ...[
            SizedBox(height: 24),
            _buildWordList('Antonyms', card.antonyms, Color(0xFFEF4444)),
          ],

          SizedBox(height: 32),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _markAsLearned(card);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF10B981),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Mark as Learned',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    _toggleBookmark(card);
                  },
                  icon: Icon(
                    card.isFavorite ? Icons.bookmark : Icons.bookmark_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                  padding: EdgeInsets.all(12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWordList(String title, List<String> words, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: words.map((word) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Text(
                word,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Word ${currentWordIndex + 1} of ${vocabularyCards.length}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6366F1),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Level ${vocabularyCards[currentWordIndex].difficultyLevel}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (currentWordIndex + 1) / vocabularyCards.length,
              backgroundColor: Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: currentWordIndex > 0 ? _previousWord : null,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: currentWordIndex > 0
                      ? Color(0xFF10B981)
                      : Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color: currentWordIndex > 0
                          ? Colors.white
                          : Color(0xFF9CA3AF),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Previous',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: currentWordIndex > 0
                            ? Colors.white
                            : Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFFBBF24),
              shape: BoxShape.circle,
            ),
            child: Text('📚', style: TextStyle(fontSize: 20)),
          ),
          SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: currentWordIndex < vocabularyCards.length - 1
                  ? _nextWord
                  : null,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: currentWordIndex < vocabularyCards.length - 1
                      ? Color(0xFF6366F1)
                      : Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: currentWordIndex < vocabularyCards.length - 1
                            ? Colors.white
                            : Color(0xFF9CA3AF),
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: currentWordIndex < vocabularyCards.length - 1
                          ? Colors.white
                          : Color(0xFF9CA3AF),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _previousWord() {
    if (currentWordIndex > 0) {
      setState(() {
        currentWordIndex--;
      });
    }
  }

  void _nextWord() {
    if (currentWordIndex < vocabularyCards.length - 1) {
      setState(() {
        currentWordIndex++;
      });
    }
  }

  void _markAsLearned(VocabularyCard card) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${card.word} marked as learned!'),
        backgroundColor: Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleBookmark(VocabularyCard card) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            card.isFavorite ? 'Removed from favorites' : 'Added to favorites'),
        backgroundColor: Color(0xFF6366F1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
