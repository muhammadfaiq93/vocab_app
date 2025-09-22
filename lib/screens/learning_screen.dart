import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/learning/learning_bloc.dart';
import '../blocs/learning/learning_event.dart';
import '../blocs/learning/learning_state.dart';
import '../models/vocabulary_card.dart';
import '../constants/app_colors.dart';
import '../widgets/progress_bar.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({Key? key}) : super(key: key);

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _cardAnimationController;
  late AnimationController _progressAnimationController;
  late Animation<double> _cardAnimation;
  late Animation<double> _progressAnimation;

  String? selectedCategory;
  int? selectedDifficulty;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _cardAnimation = CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.elasticOut,
    );
    _progressAnimation = CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    );

    // Load initial vocabulary cards
    context.read<LearningBloc>().add(LoadVocabularyCardsEvent());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _cardAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Learn New Words',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.quiz, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/exam'),
          ),
        ],
      ),
      body: BlocConsumer<LearningBloc, LearningState>(
        listener: (context, state) {
          if (state is LearningErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is VocabularyCardsLoadedState) {
            _cardAnimationController.forward();
            _progressAnimationController.forward();
          }
        },
        builder: (context, state) {
          if (state is LearningLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              ),
            );
          }

          if (state is VocabularyCardsLoadedState) {
            return Column(
              children: [
                _buildProgressSection(state),
                _buildCategoryFilter(),
                Expanded(
                  child: _buildVocabularyCards(state.vocabularyCards),
                ),
                _buildNavigationButtons(state),
              ],
            );
          }

          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildProgressSection(VocabularyCardsLoadedState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress: ${state.currentIndex + 1}/${state.vocabularyCards.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Learned: ${state.learnedCount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return ProgressBar(
                progress: (state.currentIndex + 1) /
                    state.vocabularyCards.length *
                    _progressAnimation.value,
                backgroundColor: Colors.white.withOpacity(0.3),
                progressColor: Colors.white,
                height: 8,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: BlocBuilder<LearningBloc, LearningState>(
        builder: (context, state) {
          if (state is VocabularyCardsLoadedState) {
            final categories = state.vocabularyCards
                .map((card) => card.category)
                .toSet()
                .toList();

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildFilterChip('All', selectedCategory == null);
                }
                final category = categories[index - 1];
                return _buildFilterChip(
                  category,
                  selectedCategory == category,
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            selectedCategory =
                selected ? (label == 'All' ? null : label) : null;
          });
          context.read<LearningBloc>().add(
                LoadVocabularyCardsEvent(
                  category: selectedCategory,
                  difficulty: selectedDifficulty,
                ),
              );
        },
        selectedColor: AppColors.primaryColor.withOpacity(0.2),
        checkmarkColor: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildVocabularyCards(List<VocabularyCard> cards) {
    return AnimatedBuilder(
      animation: _cardAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _cardAnimation.value,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              context.read<LearningBloc>().add(
                    ChangeCurrentCardEvent(index: index),
                  );
            },
            itemCount: cards.length,
            itemBuilder: (context, index) {
              return _buildVocabularyCard(cards[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildVocabularyCard(VocabularyCard card) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Word
              Text(
                card.word,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // Pronunciation
              Text(
                card.pronunciation,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 15),

              // Meaning
              Text(
                card.meaning,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // FIXED: Use correct field names from your VocabularyCard model
              // Check if your model has these fields, adjust accordingly

              // Try to access example field safely
              if (_hasExample(card)) ...[
                const Text(
                  'Example:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _getExample(card),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
              ],

              // Part of speech (if available)
              if (_hasPartOfSpeech(card)) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    _getPartOfSpeech(card),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],

              // Difficulty indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Difficulty: ${card.difficulty}'),
                  const SizedBox(width: 5),
                  ...List.generate(
                    3,
                    (index) => Icon(
                      Icons.star,
                      size: 16,
                      color: index <
                              _getDifficultyStars(card.difficulty.toString())
                          ? Colors.amber
                          : Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(VocabularyCardsLoadedState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: state.currentIndex > 0
                ? () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                : null,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Previous'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black87,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              context.read<LearningBloc>().add(
                    MarkAsLearnedEvent(
                      vocabularyId: state.vocabularyCards[state.currentIndex].id
                          .toString(),
                    ),
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Word marked as learned!'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.check),
            label: const Text('Learned'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
          ElevatedButton.icon(
            onPressed: state.currentIndex < state.vocabularyCards.length - 1
                ? () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                : null,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Next'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'No vocabulary cards available',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.read<LearningBloc>().add(LoadVocabularyCardsEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Vocabulary'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Difficulty Level:'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: ['easy', 'medium', 'hard'].map((difficulty) {
                return FilterChip(
                  label: Text(difficulty),
                  selected:
                      selectedDifficulty == _getDifficultyNumber(difficulty),
                  onSelected: (selected) {
                    setState(() {
                      selectedDifficulty =
                          selected ? _getDifficultyNumber(difficulty) : null;
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<LearningBloc>().add(
                    LoadVocabularyCardsEvent(
                      category: selectedCategory,
                      difficulty: selectedDifficulty,
                    ),
                  );
            },
            child: const Text('Apply'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // FIXED: Helper methods to safely access fields that may not exist in your model
  bool _hasExample(VocabularyCard card) {
    // Check if your VocabularyCard has example field
    try {
      return card.toString().contains('example') &&
          _getExample(card).isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  String _getExample(VocabularyCard card) {
    // Try to get example field - adjust based on your actual model
    // You might need to change this to card.exampleSentence or card.sampleUsage etc.
    try {
      // Replace with actual field name from your VocabularyCard model
      final cardJson = card.toJson();
      return cardJson['example'] ?? '';
    } catch (e) {
      return '';
    }
  }

  bool _hasPartOfSpeech(VocabularyCard card) {
    try {
      return _getPartOfSpeech(card).isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  String _getPartOfSpeech(VocabularyCard card) {
    try {
      // Replace with actual field name from your VocabularyCard model
      final cardJson = card.toJson();
      return cardJson['part_of_speech'] ?? '';
    } catch (e) {
      return '';
    }
  }

  int _getDifficultyStars(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return 1;
      case 'medium':
        return 2;
      case 'hard':
        return 3;
      default:
        return 1;
    }
  }

  int _getDifficultyNumber(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return 1;
      case 'medium':
        return 2;
      case 'hard':
        return 3;
      default:
        return 1;
    }
  }
}
