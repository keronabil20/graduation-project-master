// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:graduation_project/domain/entities/comment.dart';

class CommentDataSourceImplementation {
  final FirebaseFirestore firestore;

  CommentDataSourceImplementation({required this.firestore});

  @override
  Future<List<Comment>> getCommentsByPost(String postId) async {
    final snapshot = await firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Comment(
        id: doc.id,
        postId: postId,
        userId: data['userId'],
        username: data['username'],
        text: data['text'],
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        like: data['like'] ?? false,
      );
    }).toList();
  }

  @override
  Future<void> addComment(Comment comment) async {
    await firestore
        .collection('posts')
        .doc(comment.postId)
        .collection('comments')
        .add({
      'userId': comment.userId,
      'username': comment.username,
      'text': comment.text,
      'createdAt': comment.createdAt,
      'like': comment.like,
    });
  }

  @override
  Future<void> updateComment(Comment comment) async {
    await firestore
        .collection('posts')
        .doc(comment.postId)
        .collection('comments')
        .doc(comment.id)
        .update({
      'text': comment.text,
      // optionally update 'like' or other fields if needed
    });
  }

  @override
  Future<void> deleteComment(String postId, String commentId) async {
    await firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }
}
