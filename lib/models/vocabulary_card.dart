class VocabularyCard {
  final int id;
  final String word;
  final String definition;
  final String example;
  final String pronunciation;
  final List<String> synonyms;
  final List<String>? synonymChoices;
  final List<String> antonyms;
  final List<String>? antonymChoices;
  final String category;
  final int difficultyLevel;
  final bool isFavorite;
  final int correctAnswers;
  final int totalAttempts;
  final String? createdAt;
  final String? updatedAt;

  VocabularyCard({
    required this.id,
    required this.word,
    required this.definition,
    required this.example,
    required this.pronunciation,
    required this.synonyms,
    required this.synonymChoices,
    required this.antonyms,
    required this.antonymChoices,
    required this.category,
    required this.difficultyLevel,
    this.isFavorite = false,
    this.correctAnswers = 0,
    this.totalAttempts = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory VocabularyCard.fromJson(Map<String, dynamic> json) {
    return VocabularyCard(
      id: json['id'] ?? 0,
      word: json['word'] ?? '',
      definition: json['definition'] ?? '',
      example: json['example'] ?? '',
      pronunciation: json['pronunciation'] ?? '',
      synonyms:
          json['synonyms'] != null ? List<String>.from(json['synonyms']) : [],
      synonymChoices: json['synonym_choices'] != null
          ? List<String>.from(json['synonym_choices'])
          : null,
      antonyms:
          json['antonyms'] != null ? List<String>.from(json['antonyms']) : [],
      antonymChoices: json['antonym_choices'] != null
          ? List<String>.from(json['antonym_choices'])
          : null,
      category: json['category'] ?? '',
      difficultyLevel: json['difficulty_level'] ?? 1,
      isFavorite: json['is_favorite'] ?? false,
      correctAnswers: json['correct_answers'] ?? 0,
      totalAttempts: json['total_attempts'] ?? 0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'definition': definition,
      'example': example,
      'pronunciation': pronunciation,
      'synonyms': synonyms,
      'antonyms': antonyms,
      'category': category,
      'difficulty_level': difficultyLevel,
      'is_favorite': isFavorite,
      'correct_answers': correctAnswers,
      'total_attempts': totalAttempts,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
