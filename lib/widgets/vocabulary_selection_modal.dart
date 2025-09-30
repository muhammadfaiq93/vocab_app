import 'package:flutter/material.dart';

class VocabularySelectionModal extends StatefulWidget {
  @override
  _VocabularySelectionModalState createState() =>
      _VocabularySelectionModalState();
}

class _VocabularySelectionModalState extends State<VocabularySelectionModal> {
  int? selectedCategory;
  int? selectedRange;

  final List<Map<String, dynamic>> categories = [
    {
      'level': 1,
      'icon': '🌱',
      'title': 'Beginner',
      'subtitle': 'Simple everyday words',
      'color': Color(0xFF10B981),
      'wordRange': '1-40',
    },
    {
      'level': 2,
      'icon': '🌿',
      'title': 'Elementary',
      'subtitle': 'Building your foundation',
      'color': Color(0xFF3B82F6),
      'wordRange': '41-80',
    },
    {
      'level': 3,
      'icon': '🌳',
      'title': 'Intermediate',
      'subtitle': 'Challenge yourself',
      'color': Color(0xFF6366F1),
      'wordRange': '81-120',
    },
    {
      'level': 4,
      'icon': '🎯',
      'title': 'Advanced',
      'subtitle': 'Master level words',
      'color': Color(0xFF8B5CF6),
      'wordRange': '121-160',
    },
    {
      'level': 5,
      'icon': '👑',
      'title': 'Expert',
      'subtitle': 'Championship level',
      'color': Color(0xFFEC4899),
      'wordRange': '161-200',
    },
  ];

  final List<Map<String, dynamic>> ranges = [
    {
      'min': 10,
      'max': 20,
      'label': '10-20 words',
    },
    {
      'min': 20,
      'max': 30,
      'label': '20-30 words',
    },
    {
      'min': 30,
      'max': 40,
      'label': '30-40 words',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 12),
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 24),

          // Title Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F9FF),
                    shape: BoxShape.circle,
                  ),
                  child: Text('📚', style: TextStyle(fontSize: 32)),
                ),
                SizedBox(height: 16),
                Text(
                  'Choose Your Level',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Pick a difficulty level first',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),

          // Category Selection
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step 1: Select Difficulty',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = selectedCategory == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = index;
                            selectedRange = null; // Reset range selection
                          });
                        },
                        child: Container(
                          width: 120,
                          margin: EdgeInsets.only(right: 12),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? category['color'].withOpacity(0.1)
                                : Colors.grey[50],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? category['color']
                                  : Colors.grey[200]!,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                category['icon'],
                                style: TextStyle(fontSize: 32),
                              ),
                              SizedBox(height: 8),
                              Text(
                                category['title'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? category['color']
                                      : Color(0xFF1F2937),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Level ${category['level']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6B7280),
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
          SizedBox(height: 24),

          // Range Selection (only shown after category is selected)
          if (selectedCategory != null) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Step 2: How many words?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  SizedBox(height: 16),
                  Column(
                    children: List.generate(ranges.length, (index) {
                      final range = ranges[index];
                      final isSelected = selectedRange == index;
                      final categoryColor =
                          categories[selectedCategory!]['color'];

                      return Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedRange = index;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? categoryColor.withOpacity(0.1)
                                  : Colors.grey[50],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? categoryColor
                                    : Colors.grey[200]!,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? categoryColor
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.bookmark,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey[600],
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    range['label'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? categoryColor
                                          : Color(0xFF1F2937),
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: categoryColor,
                                    size: 24,
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
            SizedBox(height: 16),
          ],

          // Start Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: selectedCategory != null && selectedRange != null
                    ? () {
                        final category = categories[selectedCategory!];
                        final range = ranges[selectedRange!];

                        // Calculate the start and end based on category and range
                        final categoryStart = (category['level'] - 1) * 40 + 1;
                        final selectedCount = range['min'] +
                            ((range['max'] - range['min']) ~/
                                2); // Use middle value

                        Navigator.pop(context, {
                          'difficulty': category['level'],
                          'count': selectedCount,
                          'start': categoryStart,
                          'end': categoryStart + selectedCount - 1,
                          'categoryName': category['title'],
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedCategory != null && selectedRange != null
                          ? categories[selectedCategory!]['color']
                          : Colors.grey[300],
                  elevation:
                      selectedCategory != null && selectedRange != null ? 4 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Start Learning',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: selectedCategory != null && selectedRange != null
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: selectedCategory != null && selectedRange != null
                          ? Colors.white
                          : Colors.grey[500],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
