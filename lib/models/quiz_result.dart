class QuizResult {
  final int? id;
  final int? quizSessionId;
  final int wordId;
  final String testType;
  final String userAnswer;
  final bool isCorrect;
  final int timeSpent;
  final DateTime? answeredAt;

  QuizResult({
    this.id,
    required this.quizSessionId,
    required this.wordId,
    required this.testType,
    required this.userAnswer,
    required this.isCorrect,
    required this.timeSpent,
    this.answeredAt,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      id: json['id'],
      quizSessionId: json['quiz_session_id'],
      wordId: json['word_id'],
      testType: json['test_type'],
      userAnswer: json['user_answer'],
      isCorrect: json['is_correct'],
      timeSpent: json['time_spent'],
      answeredAt: json['answered_at'] != null
          ? DateTime.parse(json['answered_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quiz_session_id': quizSessionId,
      'word_id': wordId,
      'test_type': testType,
      'user_answer': userAnswer,
      'is_correct': isCorrect,
      'time_spent': timeSpent,
    };
  }
}

class QuizResultResponse {
  final String message;
  final QuizResult result;

  QuizResultResponse({
    required this.message,
    required this.result,
  });

  factory QuizResultResponse.fromJson(Map<String, dynamic> json) {
    return QuizResultResponse(
      message: json['message'],
      result: QuizResult.fromJson(json['result']),
    );
  }
}
