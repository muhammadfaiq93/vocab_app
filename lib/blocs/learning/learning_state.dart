import '../../models/vocabulary_card.dart';

abstract class LearningState {}

class LearningInitialState extends LearningState {}

class LearningLoadingState extends LearningState {}

class VocabularyCardsLoadedState extends LearningState {
  final List<VocabularyCard> vocabularyCards;
  final int currentIndex;
  final int learnedCount;
  final String? selectedCategory;
  final int? selectedDifficulty;

  VocabularyCardsLoadedState({
    required this.vocabularyCards,
    this.currentIndex = 0,
    this.learnedCount = 0,
    this.selectedCategory,
    this.selectedDifficulty,
  });

  VocabularyCardsLoadedState copyWith({
    List<VocabularyCard>? vocabularyCards,
    int? currentIndex,
    int? learnedCount,
    String? selectedCategory,
    int? selectedDifficulty,
  }) {
    return VocabularyCardsLoadedState(
      vocabularyCards: vocabularyCards ?? this.vocabularyCards,
      currentIndex: currentIndex ?? this.currentIndex,
      learnedCount: learnedCount ?? this.learnedCount,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedDifficulty: selectedDifficulty ?? this.selectedDifficulty,
    );
  }

  bool get hasNext => currentIndex < vocabularyCards.length - 1;
  bool get hasPrevious => currentIndex > 0;
  double get progress => vocabularyCards.isEmpty
      ? 0.0
      : (currentIndex + 1) / vocabularyCards.length;
}

class CategoriesLoadedState extends LearningState {
  final List<String> categories;

  CategoriesLoadedState({required this.categories});
}

class LearningProgressLoadedState extends LearningState {
  final Map<String, dynamic> progressData;

  LearningProgressLoadedState({required this.progressData});
}

class VocabularyMarkedAsLearnedState extends LearningState {
  final String vocabularyId;

  VocabularyMarkedAsLearnedState({required this.vocabularyId});
}

class LearningErrorState extends LearningState {
  final String message;

  LearningErrorState({required this.message});
}
