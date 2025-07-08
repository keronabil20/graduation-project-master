// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:graduation_project/domain/entities/comment.dart';
import 'package:graduation_project/domain/entities/post.dart';

class PostModel {
  final String id;
  final String userId;
  final String username;
  final String restaurantId;
  final String description;
  final String image;
  final int likes;
  final DateTime createdAt;
  final List<CommentModel> comments;

  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.restaurantId,
    required this.description,
    required this.image,
    required this.likes,
    required this.createdAt,
    required this.comments,
  });

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return PostModel(
      id: doc.id,
      userId: data['userId']?.toString() ?? '',
      username: data['username']?.toString() ?? '',
      restaurantId: data['restaurantId']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      image: data['image']?.toString() ?? '',
      likes: (data['likes'] as num?)?.toInt() ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      comments: _parseComments(data['comments']),
    );
  }

  static List<CommentModel> _parseComments(dynamic commentsData) {
    if (commentsData == null) return [];
    if (commentsData is! List) return [];

    return commentsData.map((comment) {
      if (comment is Map<String, dynamic>) {
        return CommentModel.fromMap(comment);
      }
      return CommentModel(
        id: '',
        text: '',
        userId: '',
        username: '',
        like: false,
        createdAt: DateTime.now(),
      );
    }).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'restaurantId': restaurantId,
      'description': description,
      'image': image,
      'likes': likes,
      'createdAt': Timestamp.fromDate(createdAt),
      'comments': comments.map((comment) => comment.toMap()).toList(),
    };
  }

  Post toDomain() {
    return Post(
      id: id,
      userId: userId,
      username: username,
      restaurantId: restaurantId,
      description: description,
      image: image,
      likes: likes,
      createdAt: createdAt,
      comments: comments.map((comment) => comment.toDomain()).toList(),
    );
  }

  factory PostModel.fromDomain(Post post) {
    return PostModel(
      id: post.id,
      userId: post.userId,
      username: post.username,
      restaurantId: post.restaurantId,
      description: post.description,
      image: post.image,
      likes: post.likes,
      createdAt: post.createdAt,
      comments: post.comments
          .map((comment) => CommentModel.fromDomain(comment))
          .toList(),
    );
  }
}

class CommentModel {
  final String id;
  final String text;
  final String userId;
  final String username;
  final bool like;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.text,
    required this.userId,
    required this.username,
    required this.like,
    required this.createdAt,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id']?.toString() ?? '',
      text: map['text']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      username: map['username']?.toString() ?? '',
      like: map['like'] as bool? ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'userId': userId,
      'username': username,
      'like': like,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Comment toDomain() {
    return Comment(
      id: id,
      text: text,
      userId: userId,
      username: username,
      like: like,
      createdAt: createdAt,
      postId: '',
    );
  }

  factory CommentModel.fromDomain(Comment comment) {
    return CommentModel(
      id: comment.id,
      text: comment.text,
      userId: comment.userId,
      username: comment.username,
      like: comment.like,
      createdAt: comment.createdAt ?? DateTime.now(),
    );
  }
}
