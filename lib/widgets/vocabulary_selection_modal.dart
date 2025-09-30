import 'package:flutter/material.dart';

class VocabularySelectionModal extends StatefulWidget {
  @override
  _VocabularySelectionModalState createState() =>
      _VocabularySelectionModalState();
}

class _VocabularySelectionModalState extends State<VocabularySelectionModal>
    with SingleTickerProviderStateMixin {
  int? selectedCategory;
  int? selectedRange;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<Map<String, dynamic>> categories = [
    {
      'level': 1,
      'icon': '🌱',
      'title': 'Beginner',
      'subtitle': 'Simple everyday words',
      'color': Color(0xFF10B981),
      'gradient': [Color(0xFF10B981), Color(0xFF059669)],
    },
    {
      'level': 2,
      'icon': '🌿',
      'title': 'Elementary',
      'subtitle': 'Building foundation',
      'color': Color(0xFF3B82F6),
      'gradient': [Color(0xFF3B82F6), Color(0xFF2563EB)],
    },
    {
      'level': 3,
      'icon': '🌳',
      'title': 'Intermediate',
      'subtitle': 'Challenge yourself',
      'color': Color(0xFF6366F1),
      'gradient': [Color(0xFF6366F1), Color(0xFF4F46E5)],
    },
    {
      'level': 4,
      'icon': '🎯',
      'title': 'Advanced',
      'subtitle': 'Master level',
      'color': Color(0xFF8B5CF6),
      'gradient': [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    },
    {
      'level': 5,
      'icon': '👑',
      'title': 'Expert',
      'subtitle': 'Champion level',
      'color': Color(0xFFEC4899),
      'gradient': [Color(0xFFEC4899), Color(0xFFDB2777)],
    },
  ];

  final List<Map<String, dynamic>> ranges = [
    {'min': 1, 'max': 10, 'label': '1-10 words', 'icon': Icons.star},
    {'min': 10, 'max': 20, 'label': '10-20 words', 'icon': Icons.stars},
    {'min': 20, 'max': 30, 'label': '20-30 words', 'icon': Icons.auto_awesome},
    {'min': 30, 'max': 40, 'label': '30-40 words', 'icon': Icons.emoji_events},
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
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 12),

            // Title Section with gradient background
            Container(
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
                    'Choose Your Level',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Select difficulty and word count',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Category Selection
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Color(0xFF3B82F6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('1️⃣', style: TextStyle(fontSize: 16)),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Select Difficulty',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(vertical: 4),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected = selectedCategory == index;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = index;
                              selectedRange = null;
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOutBack,
                            width: 110,
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: category['gradient'],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              color: isSelected ? null : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : Colors.grey[200]!,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected
                                      ? category['color'].withOpacity(0.4)
                                      : Colors.black.withOpacity(0.05),
                                  blurRadius: isSelected ? 15 : 8,
                                  offset: Offset(0, isSelected ? 6 : 3),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.white.withOpacity(0.2)
                                        : Color(0xFFF3F4F6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    category['icon'],
                                    style: TextStyle(fontSize: 28),
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  category['title'],
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Color(0xFF1F2937),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Level ${category['level']}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white.withOpacity(0.9)
                                        : Color(0xFF9CA3AF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Range Selection
            if (selectedCategory != null) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: categories[selectedCategory!]['color']
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('2️⃣', style: TextStyle(fontSize: 16)),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'How many words?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Column(
                      children: List.generate(ranges.length, (index) {
                        final range = ranges[index];
                        final isSelected = selectedRange == index;
                        final categoryColor =
                            categories[selectedCategory!]['color'];

                        return Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedRange = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 250),
                              curve: Curves.easeOut,
                              padding: EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? LinearGradient(
                                        colors: categories[selectedCategory!]
                                            ['gradient'],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      )
                                    : null,
                                color: isSelected ? null : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.transparent
                                      : Colors.grey[200]!,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isSelected
                                        ? categoryColor.withOpacity(0.3)
                                        : Colors.black.withOpacity(0.03),
                                    blurRadius: isSelected ? 12 : 4,
                                    offset: Offset(0, isSelected ? 4 : 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.white.withOpacity(0.2)
                                          : categoryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      range['icon'],
                                      color: isSelected
                                          ? Colors.white
                                          : categoryColor,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      range['label'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected
                                            ? Colors.white
                                            : Color(0xFF1F2937),
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: categoryColor,
                                        size: 20,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14),
            ],

            // Start Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: selectedCategory != null && selectedRange != null
                        ? LinearGradient(
                            colors: categories[selectedCategory!]['gradient'],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        : null,
                    color: selectedCategory == null || selectedRange == null
                        ? Colors.grey[300]
                        : null,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: selectedCategory != null && selectedRange != null
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
                    onPressed: selectedCategory != null && selectedRange != null
                        ? () {
                            _animationController.forward().then((_) {
                              _animationController.reverse();
                            });

                            final category = categories[selectedCategory!];
                            final range = ranges[selectedRange!];
                            final categoryStart =
                                (category['level'] - 1) * 40 + 1;
                            final wordCount = range['max'];

                            Future.delayed(Duration(milliseconds: 150), () {
                              Navigator.pop(context, {
                                'difficulty': category['level'],
                                'count': wordCount,
                                'start': categoryStart,
                                'end': categoryStart + wordCount - 1,
                                'categoryName': category['title'],
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
                        Text(
                          '🚀',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Start Learning',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: selectedCategory != null &&
                                    selectedRange != null
                                ? Colors.white
                                : Colors.grey[500],
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color:
                              selectedCategory != null && selectedRange != null
                                  ? Colors.white
                                  : Colors.grey[500],
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
