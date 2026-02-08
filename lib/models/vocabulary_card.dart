import 'dart:convert';

class VocabularyCard {
  final int id;
  final String word;
  final String definition;
  final String example;
  final String pronunciation;
  final List<String> synonyms;
  final List<String>? synonymChoices; // Add this
  final List<String> antonyms;
  final List<String>? antonymChoices; // Add this
  final List<String>? meaningChoices; // Add this
  final String category;
  final int difficultyLevel;
  final bool isFavorite;
  final int correctAnswers;
  final int totalAttempts;
  final String? createdAt;
  final String? updatedAt;
  final String? image;

  VocabularyCard({
    required this.id,
    required this.word,
    required this.definition,
    required this.example,
    required this.pronunciation,
    required this.synonyms,
    this.synonymChoices,
    required this.antonyms,
    this.antonymChoices,
    this.meaningChoices,
    required this.category,
    required this.difficultyLevel,
    this.isFavorite = false,
    this.correctAnswers = 0,
    this.totalAttempts = 0,
    this.createdAt,
    this.updatedAt,
    this.image,
  });

  factory VocabularyCard.fromJson(Map<String, dynamic> json) {
    return VocabularyCard(
      id: json['id'] ?? 0,
      word: json['word'] ?? '',
      definition: json['definition'] ?? '',
      example: json['example'] ?? '',
      pronunciation: json['pronunciation'] ?? '',
      synonyms: _parseJsonList(json['synonyms']),
      synonymChoices: _parseJsonList(json['synonym_choices']),
      antonyms: _parseJsonList(json['antonyms']),
      antonymChoices: _parseJsonList(json['antonym_choices']),
      meaningChoices: _parseJsonList(json['meaning_choices']),
      category: json['category'] ?? '',
      difficultyLevel: json['difficulty_level'] ?? 1,
      isFavorite: json['is_favorite'] ?? false,
      correctAnswers: json['correct_answers'] ?? 0,
      totalAttempts: json['total_attempts'] ?? 0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      image: json['image'],
    );
  }

  // Helper method to parse JSON strings or arrays into List<String>
  static List<String> _parseJsonList(dynamic value) {
    if (value == null) return [];

    // If it's already a List
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }

    // If it's a String (JSON encoded)
    if (value is String) {
      try {
        final decoded = json.decode(value);
        if (decoded is List) {
          return decoded.map((item) => item.toString()).toList();
        }
      } catch (e) {
        print('Error parsing JSON list: $e');
        return [];
      }
    }

    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'definition': definition,
      'example': example,
      'pronunciation': pronunciation,
      'synonyms': synonyms,
      'synonym_choices': synonymChoices,
      'antonyms': antonyms,
      'antonym_choices': antonymChoices,
      'meaning_choices': meaningChoices,
      'category': category,
      'difficulty_level': difficultyLevel,
      'is_favorite': isFavorite,
      'correct_answers': correctAnswers,
      'total_attempts': totalAttempts,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'image': image,
    };
  }
}
