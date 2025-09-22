abstract class LearningEvent {}

class LoadVocabularyCardsEvent extends LearningEvent {
  final String? category;
  final int? difficulty;
  final int page;
  final int limit;

  LoadVocabularyCardsEvent({
    this.category,
    this.difficulty,
    this.page = 1,
    this.limit = 10,
  });
}

class LoadCategoriesEvent extends LearningEvent {}

class ChangeCurrentCardEvent extends LearningEvent {
  final int index;

  ChangeCurrentCardEvent({required this.index});
}

class MarkAsLearnedEvent extends LearningEvent {
  final String vocabularyId;

  MarkAsLearnedEvent({required this.vocabularyId});
}

class LoadLearningProgressEvent extends LearningEvent {}

class FilterVocabularyEvent extends LearningEvent {
  final String? category;
  final int? difficulty;

  FilterVocabularyEvent({
    this.category,
    this.difficulty,
  });
}
