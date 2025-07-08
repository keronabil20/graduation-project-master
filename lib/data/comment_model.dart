// Project imports:
import 'package:graduation_project/domain/entities/comment.dart';

class CommmentModel extends Comment {
  CommmentModel(
      {required super.id,
      required super.userId,
      required super.username,
      required super.text,
      required super.postId});

  factory CommmentModel.fromJson(Map<String, dynamic> json, String id) {
    return CommmentModel(
      id: id,
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      text: json['text'] ?? '',
      postId: '',
    );
  }
}
