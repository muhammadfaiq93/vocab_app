import 'package:flutter/material.dart';

class VocabularySelectionModal extends StatefulWidget {
  @override
  _VocabularySelectionModalState createState() =>
      _VocabularySelectionModalState();
}

class _VocabularySelectionModalState extends State<VocabularySelectionModal> {
  int? selectedRange;

  final List<Map<String, dynamic>> ranges = [
    {
      'min': 10,
      'max': 20,
      'icon': '🌱',
      'title': 'Beginner',
      'subtitle': 'Perfect for starting',
      'color': Color(0xFF10B981),
    },
    {
      'min': 20,
      'max': 30,
      'icon': '🌿',
      'title': 'Intermediate',
      'subtitle': 'Challenge yourself',
      'color': Color(0xFF6366F1),
    },
    {
      'min': 30,
      'max': 40,
      'icon': '🌳',
      'title': 'Advanced',
      'subtitle': 'Master level',
      'color': Color(0xFF8B5CF6),
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
                  child: Text(
                    '📚',
                    style: TextStyle(fontSize: 32),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'How many words?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Choose your learning goal for today',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),

          // Range Options
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: List.generate(ranges.length, (index) {
                final range = ranges[index];
                final isSelected = selectedRange == index;

                return Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedRange = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? range['color'].withOpacity(0.1)
                            : Colors.grey[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              isSelected ? range['color'] : Colors.grey[200]!,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: range['color'].withOpacity(0.2),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        children: [
                          // Icon
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? range['color']
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                range['icon'],
                                style: TextStyle(fontSize: 28),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),

                          // Text Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  range['title'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? range['color']
                                        : Color(0xFF1F2937),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  range['subtitle'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Word Count Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? range['color']
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${range['min']}-${range['max']}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : Color(0xFF6B7280),
                              ),
                            ),
                          ),

                          // Checkmark
                          SizedBox(width: 12),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? range['color']
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? range['color']
                                    : Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 16),

          // Start Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: selectedRange != null
                    ? () {
                        final range = ranges[selectedRange!];
                        Navigator.pop(context, {
                          'min': range['min'],
                          'max': range['max'],
                          'count': range[
                              'min'], // or calculate random between min-max
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedRange != null
                      ? ranges[selectedRange!]['color']
                      : Colors.grey[300],
                  elevation: selectedRange != null ? 4 : 0,
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
                        color: selectedRange != null
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: selectedRange != null
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

// How to use this in your button/screen:
void showVocabularySelection(BuildContext context) async {
  final result = await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => VocabularySelectionModal(),
  );

  if (result != null) {
    print('Selected range: ${result['min']}-${result['max']}');
    print('Starting with ${result['count']} words');

    // Navigate to learning screen with the selected count
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => LearningScreen(wordCount: result['count']),
    //   ),
    // );
  }
}
