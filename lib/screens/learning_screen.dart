import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import 'quiz_screen.dart';
import '../services/storage_service.dart';

class LearningScreen extends StatefulWidget {
  final int? wordCount; // Add this parameter

  const LearningScreen({Key? key, this.wordCount})
      : super(key: key); // Add constructor

  @override
  _LearningScreenState createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  int currentWordIndex = 0;

  // Sample vocabulary data - matches the screenshot
  final List<Map<String, dynamic>> vocabularyWords = [
    {
      'word': 'Serendipity',
      'partOfSpeech': 'Noun',
      'pronunciation': 'ser.en\'dɪp.ɪ.ti',
      'meaning':
          'The Fact Of Finding Something Valuable Or Pleasant In A Way That Is Not Planned.',
      'example': 'It Was Pure Serendipity That We Met Again.',
      'date': 'Monday, June 24, 2025',
    },
    {
      'word': 'Ephemeral',
      'partOfSpeech': 'Adjective',
      'pronunciation': 'ɪ\'fem.ər.əl',
      'meaning': 'Lasting For A Very Short Time; Temporary And Fleeting.',
      'example': 'The beauty of cherry blossoms is ephemeral.',
      'date': 'Tuesday, June 25, 2025',
    },
    {
      'word': 'Mellifluous',
      'partOfSpeech': 'Adjective',
      'pronunciation': 'mɛ\'lɪf.lu.əs',
      'meaning': 'Sweet Or Musical; Pleasant To Hear And Listen To.',
      'example': 'Her mellifluous voice captivated the audience.',
      'date': 'Wednesday, June 26, 2025',
    },
  ];

  @override
  void initState() {
    super.initState();
    // You can use widget.wordCount here to fetch specific number of words
    if (widget.wordCount != null) {
      print('Learning ${widget.wordCount} words');
      // TODO: Fetch vocabulary based on widget.wordCount from API
      // For now, limit the existing list
      // vocabularyWords = vocabularyWords.take(widget.wordCount!).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = StorageService();
    final fullName = storage.currentUser?.name ?? 'User';
    final firstName = storage.currentUser?.name.split(' ').first ?? 'User';
    final email = storage.currentUser?.email ?? '';
    final userId = storage.userId ?? 0;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return Center(child: Text('Please log in to access learning'));
        }

        final currentWord = vocabularyWords[currentWordIndex];

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6366F1),
                  Color(0xFF8B5CF6),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(firstName),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
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
                            _buildWordCard(currentWord),
                            SizedBox(height: 30),
                            _buildNavigationButtons(),
                            SizedBox(height: 20),
                            _buildQuizSection(),
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

  Widget _buildHeader(firstName) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Text(
                      firstName,
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
              Stack(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 30),

          // Title Section
          Text(
            "Today's Word!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'One word a day keeps your vocabulary strong!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4),
          Text(
            vocabularyWords[currentWordIndex]['date'],
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordCard(Map<String, dynamic> wordData) {
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
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 32),
              decoration: BoxDecoration(
                color: Color(0xFFF8F9FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                wordData['word'],
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
          ),
          SizedBox(height: 24),

          // Part of Speech
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Part of Speech:',
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
                  wordData['partOfSpeech'],
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
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      wordData['pronunciation'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFF6366F1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.volume_up,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 30),

          // English Meaning
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
                'English Meaning',
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
              '"${wordData['meaning']}"',
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
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
              '"${wordData['example']}"',
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
          ),

          SizedBox(height: 32),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _showWordDetails();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6366F1),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.visibility, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'See Details',
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
                    _toggleBookmark();
                  },
                  icon: Icon(
                    Icons.bookmark_outline,
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

  Widget _buildQuizSection() {
    return GestureDetector(
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
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xFFE8F5E8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.quiz,
                color: Colors.white,
                size: 20,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Try a Quick Quiz',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Test your brain in seconds – let\'s go',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF6B7280),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showWordDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Word Details'),
        content: Text(
            'More detailed information about this word would be shown here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
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
                'Word ${currentWordIndex + 1} of ${vocabularyWords.length}',
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
                  'Learning',
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
          // Progress bar
          Row(
            children: List.generate(vocabularyWords.length, (index) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  height: 8,
                  decoration: BoxDecoration(
                    color: index <= currentWordIndex
                        ? Color(0xFF6366F1)
                        : Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
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
          // Previous Button
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
                  boxShadow: currentWordIndex > 0
                      ? [
                          BoxShadow(
                            color: Color(0xFF10B981).withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ]
                      : null,
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

          // Fun emoji or icon in the middle
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFFBBF24),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFFBBF24).withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              '📚',
              style: TextStyle(fontSize: 20),
            ),
          ),

          SizedBox(width: 16),

          // Next Button
          Expanded(
            child: GestureDetector(
              onTap: currentWordIndex < vocabularyWords.length - 1
                  ? _nextWord
                  : null,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: currentWordIndex < vocabularyWords.length - 1
                      ? Color(0xFF6366F1)
                      : Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: currentWordIndex < vocabularyWords.length - 1
                      ? [
                          BoxShadow(
                            color: Color(0xFF6366F1).withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: currentWordIndex < vocabularyWords.length - 1
                            ? Colors.white
                            : Color(0xFF9CA3AF),
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: currentWordIndex < vocabularyWords.length - 1
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
      _showWordChangeAnimation(
          'Previous word: ${vocabularyWords[currentWordIndex]['word']}');
    }
  }

  void _nextWord() {
    if (currentWordIndex < vocabularyWords.length - 1) {
      setState(() {
        currentWordIndex++;
      });
      _showWordChangeAnimation(
          'Next word: ${vocabularyWords[currentWordIndex]['word']}');
    }
  }

  void _showWordChangeAnimation(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Text('✨', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(width: 12),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF6366F1),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _toggleBookmark() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Text('⭐', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(width: 12),
            Text(
              'Word bookmarked!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
