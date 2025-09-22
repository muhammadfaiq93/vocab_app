class VocabularyCard {
  final String id;
  final String word;
  final String meaning;
  final String pronunciation;
  final String imageUrl;
  final String audioUrl;
  final String category;
  final int difficulty; // 1-5
  final List<String> examples;

  VocabularyCard({
    required this.id,
    required this.word,
    required this.meaning,
    required this.pronunciation,
    required this.imageUrl,
    required this.audioUrl,
    required this.category,
    required this.difficulty,
    required this.examples,
  });

  factory VocabularyCard.fromJson(Map<String, dynamic> json) {
    return VocabularyCard(
      id: json['id'],
      word: json['word'],
      meaning: json['meaning'],
      pronunciation: json['pronunciation'],
      imageUrl: json['imageUrl'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
      category: json['category'],
      difficulty: json['difficulty'] ?? 1,
      examples: List<String>.from(json['examples'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'meaning': meaning,
      'pronunciation': pronunciation,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'category': category,
      'difficulty': difficulty,
      'examples': examples,
    };
  }
}
