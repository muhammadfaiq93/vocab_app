import 'package:flutter/material.dart';

class QuizSelectionModal extends StatefulWidget {
  @override
  _QuizSelectionModalState createState() => _QuizSelectionModalState();
}

class _QuizSelectionModalState extends State<QuizSelectionModal>
    with SingleTickerProviderStateMixin {
  int? selectedCategory;
  int? selectedRange;
  String? selectedTestType;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<Map<String, dynamic>> categories = [
    {
      'level': 1,
      'icon': '🌱',
      'title': 'Beginner',
      'color': Color(0xFF10B981),
      'gradient': [Color(0xFF10B981), Color(0xFF059669)],
    },
    {
      'level': 2,
      'icon': '🌿',
      'title': 'Elementary',
      'color': Color(0xFF3B82F6),
      'gradient': [Color(0xFF3B82F6), Color(0xFF2563EB)],
    },
    {
      'level': 3,
      'icon': '🌳',
      'title': 'Intermediate',
      'color': Color(0xFF6366F1),
      'gradient': [Color(0xFF6366F1), Color(0xFF4F46E5)],
    },
    {
      'level': 4,
      'icon': '🎯',
      'title': 'Advanced',
      'color': Color(0xFF8B5CF6),
      'gradient': [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    },
    {
      'level': 5,
      'icon': '👑',
      'title': 'Expert',
      'color': Color(0xFFEC4899),
      'gradient': [Color(0xFFEC4899), Color(0xFFDB2777)],
    },
  ];

  final List<Map<String, dynamic>> ranges = [
    {'max': 10, 'label': '1-10 words', 'icon': Icons.star},
    {'max': 20, 'label': '11-20 words', 'icon': Icons.stars},
    {'max': 30, 'label': '21-30 words', 'icon': Icons.auto_awesome},
    {'max': 40, 'label': '31-40 words', 'icon': Icons.emoji_events},
  ];

  final List<Map<String, dynamic>> testTypes = [
    {
      'type': 'synonyms',
      'icon': '🔄',
      'title': 'Synonyms',
      'subtitle': 'Similar meanings',
    },
    {
      'type': 'antonyms',
      'icon': '⚖️',
      'title': 'Antonyms',
      'subtitle': 'Opposite meanings',
    },
    {
      'type': 'meaning',
      'icon': '📖',
      'title': 'Meaning',
      'subtitle': 'Match definition',
    }
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFF9FAFB)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 6),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 12),
            _buildTitle(),
            SizedBox(height: 16),
            _buildDifficultySection(),
            if (selectedCategory != null) ...[
              SizedBox(height: 16),
              _buildRangeSection(),
            ],
            if (selectedCategory != null && selectedRange != null) ...[
              SizedBox(height: 16),
              _buildTestTypeSection(),
              SizedBox(height: 14),
            ],
            _buildStartButton(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF3B82F6).withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Text('📚', style: TextStyle(fontSize: 28)),
          ),
          SizedBox(height: 8),
          Text(
            'Quiz Setup',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Choose your preferences',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultySection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('1️⃣', 'Select Difficulty'),
          SizedBox(height: 12),
          Container(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(vertical: 4),
              itemCount: categories.length,
              itemBuilder: (context, index) => _buildCategoryCard(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRangeSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('2️⃣', 'How many words?'),
          SizedBox(height: 12),
          ...List.generate(ranges.length, (i) => _buildRangeCard(i)),
        ],
      ),
    );
  }

  Widget _buildTestTypeSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader('3️⃣', 'Test Type'),
          SizedBox(height: 12),
          ...List.generate(testTypes.length, (i) => _buildTestTypeCard(i)),
        ],
      ),
    );
  }

  Widget _buildHeader(String emoji, String title) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: (selectedCategory != null
                    ? categories[selectedCategory!]['color']
                    : Color(0xFF3B82F6))
                .withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(emoji, style: TextStyle(fontSize: 16)),
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(int index) {
    final cat = categories[index];
    final selected = selectedCategory == index;
    return GestureDetector(
      onTap: () => setState(() {
        selectedCategory = index;
        selectedRange = null;
        selectedTestType = null;
      }),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 110,
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          gradient: selected ? LinearGradient(colors: cat['gradient']) : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? Colors.transparent : Colors.grey[200]!,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? cat['color'].withOpacity(0.4)
                  : Colors.black12.withOpacity(0.05),
              blurRadius: selected ? 15 : 8,
              offset: Offset(0, selected ? 6 : 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withOpacity(0.2)
                    : Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: Text(cat['icon'], style: TextStyle(fontSize: 28)),
            ),
            SizedBox(height: 6),
            Text(
              cat['title'],
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Level ${cat['level']}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: selected
                    ? Colors.white.withOpacity(0.9)
                    : Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRangeCard(int index) {
    final range = ranges[index];
    final selected = selectedRange == index;
    final color = categories[selectedCategory!]['color'];
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => setState(() {
          selectedRange = index;
          selectedTestType = null;
        }),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: selected
                ? LinearGradient(
                    colors: categories[selectedCategory!]['gradient'])
                : null,
            color: selected ? null : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? Colors.transparent : Colors.grey[200]!,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: selected
                    ? color.withOpacity(0.3)
                    : Colors.black.withOpacity(0.03),
                blurRadius: selected ? 12 : 4,
                offset: Offset(0, selected ? 4 : 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withOpacity(0.2)
                      : color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(range['icon'],
                    color: selected ? Colors.white : color, size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  range['label'],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : Color(0xFF1F2937),
                  ),
                ),
              ),
              if (selected)
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: color, size: 20),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestTypeCard(int index) {
    final test = testTypes[index];
    final selected = selectedTestType == test['type'];
    final color = categories[selectedCategory!]['color'];
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () => setState(() => selectedTestType = test['type']),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: selected
                ? LinearGradient(
                    colors: categories[selectedCategory!]['gradient'])
                : null,
            color: selected ? null : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? Colors.transparent : Colors.grey[200]!,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: selected
                    ? color.withOpacity(0.3)
                    : Colors.black.withOpacity(0.03),
                blurRadius: selected ? 12 : 4,
                offset: Offset(0, selected ? 4 : 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withOpacity(0.2)
                      : color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(test['icon'], style: TextStyle(fontSize: 20)),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      test['title'],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: selected ? Colors.white : Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      test['subtitle'],
                      style: TextStyle(
                        fontSize: 12,
                        color: selected
                            ? Colors.white.withOpacity(0.8)
                            : Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: color, size: 20),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    final canStart = selectedCategory != null &&
        selectedRange != null &&
        selectedTestType != null;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            gradient: canStart
                ? LinearGradient(
                    colors: categories[selectedCategory!]['gradient'])
                : null,
            color: canStart ? null : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
            boxShadow: canStart
                ? [
                    BoxShadow(
                      color: categories[selectedCategory!]['color']
                          .withOpacity(0.4),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: ElevatedButton(
            onPressed: canStart
                ? () {
                    _animationController.forward().then((_) {
                      _animationController.reverse();
                    });
                    Future.delayed(Duration(milliseconds: 150), () {
                      Navigator.pop(context, {
                        'difficulty': categories[selectedCategory!]['level'],
                        'limit': ranges[selectedRange!]['max'],
                        'testType': selectedTestType,
                      });
                    });
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('🚀', style: TextStyle(fontSize: 20)),
                SizedBox(width: 10),
                Text(
                  'Start Quiz',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: canStart ? Colors.white : Colors.grey[500],
                  ),
                ),
                SizedBox(width: 6),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: canStart ? Colors.white : Colors.grey[500],
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
