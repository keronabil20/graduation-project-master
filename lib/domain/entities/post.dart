// Project imports:
import 'package:graduation_project/domain/entities/comment.dart';

class Post {
  final String id;
  final String restaurantId;
  final String userId;
  final String username;
  final String description;
  final String image;
  int likes;
  final DateTime createdAt;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.restaurantId,
    required this.userId,
    required this.username,
    required this.description,
    required this.image,
    this.likes = 0,
    required this.createdAt,
    this.comments = const [],
  });

  Post copyWith({
    String? id,
    String? restaurantId,
    String? userId,
    String? username,
    String? description,
    String? image,
    int? likes,
    DateTime? createdAt,
    List<Comment>? comments,
  }) {
    return Post(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      description: description ?? this.description,
      image: image ?? this.image,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
      comments: comments ?? this.comments,
    );
  }
}
