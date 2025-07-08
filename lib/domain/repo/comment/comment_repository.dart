// Project imports:
import 'package:graduation_project/domain/entities/comment.dart';

abstract class CommentRepository {
  Future<List<Comment>> getCommentsByPost(String postId);
  Future<void> addComment(Comment comment);
  Future<void> updateComment(Comment comment);
  Future<void> deleteComment(String postId, String commentId);
}
