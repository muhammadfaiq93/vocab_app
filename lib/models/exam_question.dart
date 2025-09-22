class ExamQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String type; // 'multiple_choice', 'fill_blank', 'match'
  final String vocabularyId;
  final String? imageUrl;

  ExamQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.type,
    required this.vocabularyId,
    this.imageUrl,
  });

  factory ExamQuestion.fromJson(Map<String, dynamic> json) {
    return ExamQuestion(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correctAnswerIndex'],
      type: json['type'],
      vocabularyId: json['vocabularyId'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'type': type,
      'vocabularyId': vocabularyId,
      'imageUrl': imageUrl,
    };
  }
}
