class ChildUser {
  final int id;
  final String name;
  final String email;
  final int age;
  final String? avatar;
  final int totalScore;
  final int sessionsCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? emailVerifiedAt;
  final bool isActive;
  final String? timezone;
  final String? language;

  ChildUser({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    this.avatar,
    required this.totalScore,
    required this.sessionsCompleted,
    required this.createdAt,
    required this.updatedAt,
    this.emailVerifiedAt,
    this.isActive = true,
    this.timezone,
    this.language = 'en',
  });

  factory ChildUser.fromJson(Map<String, dynamic> json) {
    return ChildUser(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      age: json['age'] as int,
      avatar: json['avatar'] as String?,
      totalScore: (json['total_score'] as num?)?.toInt() ?? 0,
      sessionsCompleted: (json['sessions_completed'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? true,
      timezone: json['timezone'] as String?,
      language: json['language'] as String? ?? 'en',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'avatar': avatar,
      'total_score': totalScore,
      'sessions_completed': sessionsCompleted,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'is_active': isActive,
      'timezone': timezone,
      'language': language,
    };
  }

  ChildUser copyWith({
    int? id,
    String? name,
    String? email,
    int? age,
    String? avatar,
    int? totalScore,
    int? sessionsCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? emailVerifiedAt,
    bool? isActive,
    String? timezone,
    String? language,
  }) {
    return ChildUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      avatar: avatar ?? this.avatar,
      totalScore: totalScore ?? this.totalScore,
      sessionsCompleted: sessionsCompleted ?? this.sessionsCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      isActive: isActive ?? this.isActive,
      timezone: timezone ?? this.timezone,
      language: language ?? this.language,
    );
  }

  // Helper methods
  String get firstName => name.split(' ').first;
  String get lastName => name.split(' ').length > 1 ? name.split(' ').last : '';
  String get initials {
    List<String> nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts.first[0]}${nameParts.last[0]}'.toUpperCase();
    } else {
      return name.length > 1
          ? name.substring(0, 2).toUpperCase()
          : name.toUpperCase();
    }
  }

  bool get isEmailVerified => emailVerifiedAt != null;
  bool get hasAvatar => avatar != null && avatar!.isNotEmpty;

  String get ageGroup {
    if (age <= 8) return 'Early Learner';
    if (age <= 12) return 'Young Scholar';
    if (age <= 16) return 'Teen Explorer';
    return 'Advanced Learner';
  }

  double get averageScorePerSession {
    if (sessionsCompleted == 0) return 0.0;
    return totalScore / sessionsCompleted;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChildUser && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ChildUser(id: $id, name: $name, email: $email, age: $age, totalScore: $totalScore, sessionsCompleted: $sessionsCompleted)';
  }
}
