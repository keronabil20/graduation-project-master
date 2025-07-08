// Project imports:
import 'package:graduation_project/domain/entities/comment.dart';
import 'package:graduation_project/domain/repo/comment/comment_repository.dart';

class CommentRepositoryImplementation implements CommentRepository {
  final CommentRepository dataSource;

  CommentRepositoryImplementation({required this.dataSource});

  @override
  Future<void> addComment(Comment comment) {
    return dataSource.addComment(comment);
  }

  @override
  Future<void> deleteComment(String postId, String commentId) {
    // Update your repository interface to accept both postId and commentId
    return dataSource.deleteComment(postId, commentId);
  }

  @override
  Future<List<Comment>> getCommentsByPost(String postId) {
    return dataSource.getCommentsByPost(postId);
  }

  @override
  Future<void> updateComment(Comment comment) {
    return dataSource.updateComment(comment);
  }
}
