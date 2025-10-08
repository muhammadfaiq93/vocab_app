import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../services/api_service.dart';
import '../models/vocabulary_card.dart';

class DynamicLearningScreen extends StatefulWidget {
  final int wordCount;
  final int difficulty;
  final String? categoryName;

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
        difficulty: widget.difficulty,
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
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return _buildUnauthenticatedScreen();
        }

        final user = state.user;

        if (isLoading) {
          return _buildLoadingScreen(isTablet);
        }

        if (errorMessage != null) {
          return _buildErrorScreen(isTablet);
        }

        if (vocabularyCards.isEmpty) {
          return _buildEmptyScreen();
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
                  _buildHeader(user, isTablet),
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
                        child: CustomScrollView(
                          physics: BouncingScrollPhysics(),
                          slivers: [
                            SliverPadding(
                              padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                              sliver: SliverList(
                                delegate: SliverChildListDelegate([
                                  _buildProgressIndicator(isTablet),
                                  SizedBox(height: 12),
                                  _buildWordCard(currentCard, isTablet),
                                  SizedBox(height: 16),
                                  _buildNavigationButtons(isTablet),
                                  SizedBox(height: 12),
                                ]),
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
      },
    );
  }

  Widget _buildUnauthenticatedScreen() {
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
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, color: Colors.white, size: 64),
                SizedBox(height: 16),
                Text(
                  'Authentication Required',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Please log in to access the learning module',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingScreen(bool isTablet) {
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
                'Loading Your Vocabulary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Preparing ${vocabularyCards.isEmpty ? widget.wordCount : vocabularyCards.length} words...',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen(bool isTablet) {
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
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.white, size: 56),
                SizedBox(height: 16),
                Text(
                  'Something Went Wrong',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  errorMessage ?? 'An unexpected error occurred',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                      errorMessage = null;
                    });
                    _fetchVocabulary();
                  },
                  icon: Icon(Icons.refresh, size: 18),
                  label: Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF6366F1),
                    padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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

  Widget _buildEmptyScreen() {
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
              Icon(Icons.library_books, color: Colors.white, size: 64),
              SizedBox(height: 16),
              Text(
                'No Words Available',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'No vocabulary words found',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic user, bool isTablet) {
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
      padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white.withOpacity(0.25),
            child: Text(
              userInitial,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  firstName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${vocabularyCards.length} words • Level ${widget.difficulty}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, color: Colors.white, size: 22),
            padding: EdgeInsets.all(8),
            constraints: BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildWordCard(VocabularyCard card, bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
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
        border: Border.all(color: Color(0xFFF3F4F6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6366F1).withOpacity(0.08),
                  Color(0xFF8B5CF6).withOpacity(0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Color(0xFF6366F1).withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF6366F1).withOpacity(0.15),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    card.word,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF6366F1),
                                    Color(0xFF8B5CF6)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.category_outlined,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Type',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Color(0xFF6B7280),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    card.category,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF6366F1),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF8B5CF6),
                                    Color(0xFFA855F7)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.record_voice_over,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pronunciation',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: Color(0xFF6B7280),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    card.pronunciation,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF8B5CF6),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 14),
          _buildCompactSection('Definition', card.definition,
              Icons.lightbulb_outline, Color(0xFFFBBF24)),
          SizedBox(height: 12),
          _buildCompactSection('Example', '"${card.example}"',
              Icons.format_quote, Color(0xFF10B981),
              isItalic: true),
          if (card.synonyms.isNotEmpty) ...[
            SizedBox(height: 12),
            _buildWordChips('Synonyms', card.synonyms, Color(0xFF6366F1)),
          ],
          if (card.antonyms.isNotEmpty) ...[
            SizedBox(height: 12),
            _buildWordChips('Antonyms', card.antonyms, Color(0xFFEF4444)),
          ],
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _markAsLearned(card),
                  icon: Icon(Icons.check_circle_outline, size: 16),
                  label: Text(
                    'Learned',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () => _toggleBookmark(card),
                  icon: Icon(
                    card.isFavorite ? Icons.bookmark : Icons.bookmark_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  padding: EdgeInsets.all(10),
                  constraints: BoxConstraints(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactSection(
      String title, String content, IconData icon, Color color,
      {bool isItalic = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: color, size: 14),
            ),
            SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF374151),
              height: 1.4,
              fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWordChips(String title, List<String> words, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: words.map((word) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withOpacity(0.25)),
              ),
              child: Text(
                word,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF6366F1).withOpacity(0.08),
            Color(0xFF8B5CF6).withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Word ${currentWordIndex + 1}/${vocabularyCards.length}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6366F1),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Level ${vocabularyCards[currentWordIndex].difficultyLevel}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (currentWordIndex + 1) / vocabularyCards.length,
              backgroundColor: Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(bool isTablet) {
    return Row(
      children: [
        Expanded(
          child: _buildNavButton(
            label: 'Previous',
            icon: Icons.arrow_back_ios_rounded,
            isEnabled: currentWordIndex > 0,
            onTap: _previousWord,
            isPrevious: true,
          ),
        ),
        SizedBox(width: 10),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
            ),
            shape: BoxShape.circle,
          ),
          child: Text('📚', style: TextStyle(fontSize: 18)),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _buildNavButton(
            label: 'Next',
            icon: Icons.arrow_forward_ios_rounded,
            isEnabled: currentWordIndex < vocabularyCards.length - 1,
            onTap: _nextWord,
            isPrevious: false,
          ),
        ),
      ],
    );
  }

  Widget _buildNavButton({
    required String label,
    required IconData icon,
    required bool isEnabled,
    required VoidCallback onTap,
    required bool isPrevious,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isEnabled
                ? LinearGradient(
                    colors: isPrevious
                        ? [Color(0xFF10B981), Color(0xFF059669)]
                        : [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  )
                : null,
            color: isEnabled ? null : Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isPrevious) ...[
                Icon(
                  icon,
                  color: isEnabled ? Colors.white : Color(0xFF9CA3AF),
                  size: 16,
                ),
                SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isEnabled ? Colors.white : Color(0xFF9CA3AF),
                ),
              ),
              if (!isPrevious) ...[
                SizedBox(width: 6),
                Icon(
                  icon,
                  color: isEnabled ? Colors.white : Color(0xFF9CA3AF),
                  size: 16,
                ),
              ],
            ],
          ),
        ),
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
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Text('${card.word} marked as learned!'),
          ],
        ),
        backgroundColor: Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.all(12),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _toggleBookmark(VocabularyCard card) {
    setState(() {
      //card.isFavorite = !card.isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              card.isFavorite ? Icons.bookmark : Icons.bookmark_outline,
              color: Colors.white,
              size: 18,
            ),
            SizedBox(width: 10),
            Text(
              card.isFavorite ? 'Added to favorites' : 'Removed from favorites',
            ),
          ],
        ),
        backgroundColor: Color(0xFF6366F1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.all(12),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
