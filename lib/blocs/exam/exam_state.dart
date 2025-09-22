import '../../models/exam_question.dart';
import '../../models/exam_result.dart';

abstract class ExamState {}

class ExamInitialState extends ExamState {}

class ExamLoadingState extends ExamState {}

class ExamGeneratedState extends ExamState {
  final List<ExamQuestion> questions;
  final int currentQuestionIndex;
  final List<int?> userAnswers;
  final DateTime? startTime;

  ExamGeneratedState({
    required this.questions,
    this.currentQuestionIndex = 0,
    required this.userAnswers,
    this.startTime,
  });

  ExamGeneratedState copyWith({
    List<ExamQuestion>? questions,
    int? currentQuestionIndex,
    List<int?>? userAnswers,
    DateTime? startTime,
  }) {
    return ExamGeneratedState(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      userAnswers: userAnswers ?? this.userAnswers,
      startTime: startTime ?? this.startTime,
    );
  }

  bool get isLastQuestion => currentQuestionIndex >= questions.length - 1;
  bool get isFirstQuestion => currentQuestionIndex <= 0;
  int get answeredCount => userAnswers.where((answer) => answer != null).length;
  double get progress => answeredCount / questions.length;
}

class ExamInProgressState extends ExamGeneratedState {
  ExamInProgressState({
    required super.questions,
    required super.currentQuestionIndex,
    required super.userAnswers,
    required DateTime startTime,
  }) : super(startTime: startTime);

  @override
  ExamInProgressState copyWith({
    List<ExamQuestion>? questions,
    int? currentQuestionIndex,
    List<int?>? userAnswers,
    DateTime? startTime,
  }) {
    return ExamInProgressState(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      userAnswers: userAnswers ?? this.userAnswers,
      startTime: startTime ?? this.startTime!,
    );
  }
}

class ExamCompletedState extends ExamState {
  final ExamResult result;

  ExamCompletedState({required this.result});
}

class ExamHistoryLoadedState extends ExamState {
  final List<ExamResult> examHistory;

  ExamHistoryLoadedState({required this.examHistory});
}

class ExamErrorState extends ExamState {
  final String message;

  ExamErrorState({required this.message});
}
