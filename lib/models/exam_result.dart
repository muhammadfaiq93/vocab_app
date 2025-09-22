class ExamResult {
  final String id;
  final String userId;
  final String examId;
  final int score;
  final int totalQuestions;
  final int timeSpent; // in seconds
  final DateTime completedAt;
  final List<UserAnswer> answers;

  ExamResult({
    required this.id,
    required this.userId,
    required this.examId,
    required this.score,
    required this.totalQuestions,
    required this.timeSpent,
    required this.completedAt,
    required this.answers,
  });

  double get percentage => (score / totalQuestions) * 100;

  factory ExamResult.fromJson(Map<String, dynamic> json) {
    return ExamResult(
      id: json['id'],
      userId: json['userId'],
      examId: json['examId'],
      score: json['score'],
      totalQuestions: json['totalQuestions'],
      timeSpent: json['timeSpent'],
      completedAt: DateTime.parse(json['completedAt']),
      answers:
          (json['answers'] as List).map((e) => UserAnswer.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'examId': examId,
      'score': score,
      'totalQuestions': totalQuestions,
      'timeSpent': timeSpent,
      'completedAt': completedAt.toIso8601String(),
      'answers': answers.map((a) => a.toJson()).toList(),
    };
  }
}

class UserAnswer {
  final String questionId;
  final int selectedAnswerIndex;
  final bool isCorrect;

  UserAnswer({
    required this.questionId,
    required this.selectedAnswerIndex,
    required this.isCorrect,
  });

  factory UserAnswer.fromJson(Map<String, dynamic> json) {
    return UserAnswer(
      questionId: json['questionId'],
      selectedAnswerIndex: json['selectedAnswerIndex'],
      isCorrect: json['isCorrect'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'selectedAnswerIndex': selectedAnswerIndex,
      'isCorrect': isCorrect,
    };
  }
}
