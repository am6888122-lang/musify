import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 2)
class User extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String email;
  
  @HiveField(3)
  final String profileImageUrl;
  
  @HiveField(4)
  final String localProfileImagePath;
  
  @HiveField(5)
  final DateTime createdAt;
  
  @HiveField(6)
  final List<String> favoriteGenres;
  
  @HiveField(7)
  final bool isPremium;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl = '',
    this.localProfileImagePath = '',
    required this.createdAt,
    this.favoriteGenres = const [],
    this.isPremium = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      localProfileImagePath: json['localProfileImagePath'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      favoriteGenres: List<String>.from(json['favoriteGenres'] ?? []),
      isPremium: json['isPremium'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'localProfileImagePath': localProfileImagePath,
      'createdAt': createdAt.toIso8601String(),
      'favoriteGenres': favoriteGenres,
      'isPremium': isPremium,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    String? localProfileImagePath,
    DateTime? createdAt,
    List<String>? favoriteGenres,
    bool? isPremium,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      localProfileImagePath: localProfileImagePath ?? this.localProfileImagePath,
      createdAt: createdAt ?? this.createdAt,
      favoriteGenres: favoriteGenres ?? this.favoriteGenres,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}