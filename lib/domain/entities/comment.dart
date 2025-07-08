// lib/domain/entities/comments_model.dart
class Comment {
  final String id;
  final String userId;
  final String username;
  final String text;
  final DateTime createdAt;
  final bool like;
  final String postId; // Not stored, but used internally

  Comment({
    required this.postId,
    required this.id,
    required this.userId,
    required this.username,
    required this.text,
    DateTime? createdAt,
    this.like = false,
  }) : createdAt = createdAt ?? DateTime.now();

  Comment copyWith({
    String? id,
    String? userId,
    String? username,
    String? text,
    DateTime? createdAt,
    bool? like,
    String? postId,
  }) {
    return Comment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      like: like ?? this.like,
      postId: postId ?? this.postId,
    );
  }
}
