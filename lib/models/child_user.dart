class ChildUser {
  final int id;
  final String name;
  final String email;
  final int? age;
  final String? avatar;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ChildUser({
    required this.id,
    required this.name,
    required this.email,
    this.age,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor for creating ChildUser from JSON
  factory ChildUser.fromJson(Map<String, dynamic> json) {
    return ChildUser(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      age: json['age'],
      avatar: json['avatar'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  // Convert ChildUser to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'avatar': avatar,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Convert to Map for easy access (for backward compatibility)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'age': age,
      'avatar': avatar,
    };
  }

  // Copy with method for immutability
  ChildUser copyWith({
    int? id,
    String? name,
    String? email,
    int? age,
    String? avatar,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChildUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'ChildUser(id: $id, name: $name, email: $email, age: $age)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChildUser &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.age == age;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ email.hashCode ^ age.hashCode;
  }
}
