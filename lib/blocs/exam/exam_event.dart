abstract class ExamEvent {}

class GenerateExamEvent extends ExamEvent {
  final String? category;
  final int? difficulty;
  final int questionCount;

  GenerateExamEvent({
    this.category,
    this.difficulty,
    this.questionCount = 10,
  });
}

class StartExamEvent extends ExamEvent {}

class AnswerQuestionEvent extends ExamEvent {
  final int questionIndex;
  final int selectedAnswerIndex;

  AnswerQuestionEvent({
    required this.questionIndex,
    required this.selectedAnswerIndex,
  });
}

class NextQuestionEvent extends ExamEvent {}

class PreviousQuestionEvent extends ExamEvent {}

class SubmitExamEvent extends ExamEvent {}

class LoadExamHistoryEvent extends ExamEvent {
  final int page;
  final int limit;

  LoadExamHistoryEvent({
    this.page = 1,
    this.limit = 10,
  });
}

class ResetExamEvent extends ExamEvent {}
