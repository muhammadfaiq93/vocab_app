import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import '../../models/vocabulary_card.dart';
import 'learning_event.dart';
import 'learning_state.dart';

class LearningBloc extends Bloc<LearningEvent, LearningState> {
  final ApiService _apiService;
  final String _token;
  List<VocabularyCard> _allVocabularyCards = [];
  List<String> _learnedVocabularyIds = [];

  // FIXED: Updated to work with instance-based ApiService
  LearningBloc({
    required ApiService apiService,
    required String token,
  })  : _apiService = apiService,
        _token = token,
        super(LearningInitialState()) {
    on<LoadVocabularyCardsEvent>(_onLoadVocabularyCards);
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<ChangeCurrentCardEvent>(_onChangeCurrentCard);
    on<MarkAsLearnedEvent>(_onMarkAsLearned);
    on<LoadLearningProgressEvent>(_onLoadLearningProgress);
    on<FilterVocabularyEvent>(_onFilterVocabulary);
    on<SearchVocabularyEvent>(_onSearchVocabulary);
  }

  Future<void> _onLoadVocabularyCards(
    LoadVocabularyCardsEvent event,
    Emitter<LearningState> emit,
  ) async {
    emit(LearningLoadingState());
    try {
      // FIXED: Use the instance-based API method
      final vocabularyCards = await _apiService.getVocabularyCards(
        token: _token,
        category: event.category,
        difficulty: event.difficulty,
        page: event.page,
        limit: event.limit,
      );

      _allVocabularyCards = vocabularyCards;

      emit(VocabularyCardsLoadedState(
        vocabularyCards: vocabularyCards,
        learnedCount: _learnedVocabularyIds.length,
        selectedCategory: event.category,
        selectedDifficulty: event.difficulty,
      ));
    } catch (e) {
      emit(LearningErrorState(message: e.toString()));
    }
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<LearningState> emit,
  ) async {
    emit(LearningLoadingState());
    try {
      // FIXED: Use the instance-based API method
      final categories = await _apiService.getCategories(token: _token);
      emit(CategoriesLoadedState(categories: categories));
    } catch (e) {
      emit(LearningErrorState(message: e.toString()));
    }
  }

  void _onChangeCurrentCard(
    ChangeCurrentCardEvent event,
    Emitter<LearningState> emit,
  ) {
    if (state is VocabularyCardsLoadedState) {
      final currentState = state as VocabularyCardsLoadedState;
      emit(currentState.copyWith(currentIndex: event.index));
    }
  }

  Future<void> _onMarkAsLearned(
    MarkAsLearnedEvent event,
    Emitter<LearningState> emit,
  ) async {
    try {
      // FIXED: Use the instance-based API method
      await _apiService.markVocabularyAsLearned(
        token: _token,
        vocabularyId: event.vocabularyId,
      );

      _learnedVocabularyIds.add(event.vocabularyId);

      if (state is VocabularyCardsLoadedState) {
        final currentState = state as VocabularyCardsLoadedState;
        emit(currentState.copyWith(
          learnedCount: _learnedVocabularyIds.length,
        ));
      }

      emit(VocabularyMarkedAsLearnedState(vocabularyId: event.vocabularyId));
    } catch (e) {
      emit(LearningErrorState(message: e.toString()));
    }
  }

  Future<void> _onLoadLearningProgress(
    LoadLearningProgressEvent event,
    Emitter<LearningState> emit,
  ) async {
    emit(LearningLoadingState());
    try {
      // FIXED: Use the instance-based API method
      final progressData = await _apiService.getLearningProgress(token: _token);

      if (progressData['learnedVocabulary'] != null) {
        _learnedVocabularyIds =
            List<String>.from(progressData['learnedVocabulary']);
      }

      emit(LearningProgressLoadedState(progressData: progressData));
    } catch (e) {
      emit(LearningErrorState(message: e.toString()));
    }
  }

  Future<void> _onFilterVocabulary(
    FilterVocabularyEvent event,
    Emitter<LearningState> emit,
  ) async {
    add(LoadVocabularyCardsEvent(
      category: event.category,
      difficulty: event.difficulty,
    ));
  }

  Future<void> _onSearchVocabulary(
    SearchVocabularyEvent event,
    Emitter<LearningState> emit,
  ) async {
    emit(LearningLoadingState());
    try {
      // For search, we'll use getVocabularyCards with category filter
      // Since there's no search method in your API, we'll filter client-side
      final vocabularyCards = await _apiService.getVocabularyCards(
        token: _token,
        page: 1,
        limit: 50, // Get more cards for better search results
      );

      // Filter by query on client side
      final filteredCards = vocabularyCards
          .where((card) =>
              card.word.toLowerCase().contains(event.query.toLowerCase()) ||
              card.definition.toLowerCase().contains(event.query.toLowerCase()))
          .take(event.limit)
          .toList();

      emit(VocabularyCardsLoadedState(
        vocabularyCards: filteredCards,
        learnedCount: _learnedVocabularyIds.length,
      ));
    } catch (e) {
      emit(LearningErrorState(message: e.toString()));
    }
  }
}

// Additional events
class SearchVocabularyEvent extends LearningEvent {
  final String query;
  final int limit;
  SearchVocabularyEvent({required this.query, this.limit = 10});
}
