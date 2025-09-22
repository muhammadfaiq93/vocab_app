import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import '../../models/exam_question.dart';
import '../../models/exam_result.dart';
import '../../models/vocabulary_card.dart';
import 'exam_event.dart';
import 'exam_state.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  final ApiService _apiService;
  final String _token;

  // FIXED: Updated to work with instance-based ApiService
  ExamBloc({
    required ApiService apiService,
    required String token,
  })  : _apiService = apiService,
        _token = token,
        super(ExamInitialState()) {
    on<GenerateExamEvent>(_onGenerateExam);
    on<StartExamEvent>(_onStartExam);
    on<AnswerQuestionEvent>(_onAnswerQuestion);
    on<NextQuestionEvent>(_onNextQuestion);
    on<PreviousQuestionEvent>(_onPreviousQuestion);
    on<SubmitExamEvent>(_onSubmitExam);
    on<LoadExamHistoryEvent>(_onLoadExamHistory);
    on<ResetExamEvent>(_onResetExam);
  }

  Future<void> _onGenerateExam(
    GenerateExamEvent event,
    Emitter<ExamState> emit,
  ) async {
    emit(ExamLoadingState());
    try {
      // FIXED: Use the instance-based API method
      final questions = await _apiService.generateExam(
        token: _token,
        category: event.category,
        difficulty: event.difficulty,
        questionCount: event.questionCount,
      );

      emit(ExamGeneratedState(
        questions: questions,
        userAnswers: List.filled(questions.length, null),
      ));
    } catch (e) {
      emit(ExamErrorState(message: e.toString()));
    }
  }

  void _onStartExam(StartExamEvent event, Emitter<ExamState> emit) {
    if (state is ExamGeneratedState) {
      final currentState = state as ExamGeneratedState;
      emit(ExamInProgressState(
        questions: currentState.questions,
        currentQuestionIndex: 0,
        userAnswers: currentState.userAnswers,
        startTime: DateTime.now(),
      ));
    }
  }

  void _onAnswerQuestion(AnswerQuestionEvent event, Emitter<ExamState> emit) {
    if (state is ExamGeneratedState) {
      final currentState = state as ExamGeneratedState;
      final newAnswers = List<int?>.from(currentState.userAnswers);
      newAnswers[event.questionIndex] = event.selectedAnswerIndex;

      if (currentState is ExamInProgressState) {
        emit((currentState as ExamInProgressState)
            .copyWith(userAnswers: newAnswers));
      } else {
        emit(currentState.copyWith(userAnswers: newAnswers));
      }
    }
  }

  void _onNextQuestion(NextQuestionEvent event, Emitter<ExamState> emit) {
    if (state is ExamGeneratedState) {
      final currentState = state as ExamGeneratedState;
      if (!currentState.isLastQuestion) {
        if (currentState is ExamInProgressState) {
          emit((currentState as ExamInProgressState).copyWith(
            currentQuestionIndex: currentState.currentQuestionIndex + 1,
          ));
        } else {
          emit(currentState.copyWith(
            currentQuestionIndex: currentState.currentQuestionIndex + 1,
          ));
        }
      }
    }
  }

  void _onPreviousQuestion(
      PreviousQuestionEvent event, Emitter<ExamState> emit) {
    if (state is ExamGeneratedState) {
      final currentState = state as ExamGeneratedState;
      if (!currentState.isFirstQuestion) {
        if (currentState is ExamInProgressState) {
          emit((currentState as ExamInProgressState).copyWith(
            currentQuestionIndex: currentState.currentQuestionIndex - 1,
          ));
        } else {
          emit(currentState.copyWith(
            currentQuestionIndex: currentState.currentQuestionIndex - 1,
          ));
        }
      }
    }
  }

  Future<void> _onSubmitExam(
      SubmitExamEvent event, Emitter<ExamState> emit) async {
    if (state is ExamInProgressState) {
      emit(ExamLoadingState());
      try {
        final currentState = state as ExamInProgressState;
        final timeSpent =
            DateTime.now().difference(currentState.startTime!).inSeconds;

        // Create UserAnswer objects
        final answers = currentState.userAnswers
            .asMap()
            .entries
            .map((entry) => UserAnswer(
                  questionId: currentState.questions[entry.key].id,
                  selectedAnswerIndex: entry.value ?? -1,
                  isCorrect: entry.value ==
                      currentState.questions[entry.key].correctAnswerIndex,
                ))
            .toList();

        // FIXED: Use the instance-based API method
        final result = await _apiService.submitExam(
          token: _token,
          examId: 'exam_${DateTime.now().millisecondsSinceEpoch}',
          answers: answers,
          timeSpent: timeSpent,
        );

        emit(ExamCompletedState(result: result));
      } catch (e) {
        emit(ExamErrorState(message: e.toString()));
      }
    }
  }

  Future<void> _onLoadExamHistory(
      LoadExamHistoryEvent event, Emitter<ExamState> emit) async {
    emit(ExamLoadingState());
    try {
      // FIXED: Use the instance-based API method
      final history = await _apiService.getExamHistory(
        token: _token,
        page: event.page,
        limit: event.limit,
      );
      emit(ExamHistoryLoadedState(examHistory: history));
    } catch (e) {
      emit(ExamErrorState(message: e.toString()));
    }
  }

  void _onResetExam(ResetExamEvent event, Emitter<ExamState> emit) {
    emit(ExamInitialState());
  }
}
