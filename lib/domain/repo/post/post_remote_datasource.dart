// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:graduation_project/data/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> fetchPostsByRestaurant(String restaurantId);
  Future<void> createPost(PostModel post);
  Future<void> updatePost(PostModel post);
  Future<void> likePost(String postId);
  Future<void> deletePost(String postId);
  Future<List<PostModel>> getAllPosts();
  Future<void> unlikePost(String postId);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final FirebaseFirestore firestore;

  PostRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<PostModel>> fetchPostsByRestaurant(String restaurantId) async {
    debugPrint(
        'PostRemoteDataSource: Fetching posts for restaurant: $restaurantId');
    try {
      final snapshot = await firestore
          .collection('posts')
          .where('restaurantId', isEqualTo: restaurantId)
          .orderBy('createdAt', descending: true)
          .get();

      final posts =
          snapshot.docs.map((doc) => _documentToPostModel(doc)).toList();
      debugPrint('PostRemoteDataSource: Fetched ${posts.length} posts');
      return posts;
    } catch (e, stackTrace) {
      debugPrint('PostRemoteDataSource: Error fetching posts: $e');
      debugPrint('PostRemoteDataSource: Stack trace: $stackTrace');
      throw Exception('Failed to fetch posts by restaurant: $e');
    }
  }

  @override
  Future<List<PostModel>> getAllPosts() async {
    debugPrint('PostRemoteDataSource: Fetching all posts');
    try {
      final snapshot = await firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .get();

      final posts =
          snapshot.docs.map((doc) => _documentToPostModel(doc)).toList();
      debugPrint('PostRemoteDataSource: Fetched ${posts.length} posts');
      return posts;
    } catch (e, stackTrace) {
      debugPrint('PostRemoteDataSource: Error fetching all posts: $e');
      debugPrint('PostRemoteDataSource: Stack trace: $stackTrace');
      throw Exception('Failed to fetch all posts: $e');
    }
  }

  @override
  Future<void> createPost(PostModel post) async {
    debugPrint('PostRemoteDataSource: Creating post with ID: ${post.id}');
    try {
      final postData = {
        'userId': post.userId,
        'username': post.username,
        'restaurantId': post.restaurantId,
        'description': post.description,
        'image': post.image,
        'likes': post.likes,
        'createdAt': Timestamp.fromDate(post.createdAt),
        'comments': post.comments.map((comment) => comment.toMap()).toList(),
      };

      await firestore.collection('posts').doc(post.id).set(postData);
      debugPrint('PostRemoteDataSource: Post created successfully');
    } catch (e, stackTrace) {
      debugPrint('PostRemoteDataSource: Error creating post: $e');
      debugPrint('PostRemoteDataSource: Stack trace: $stackTrace');
      throw Exception('Failed to create post: $e');
    }
  }

  @override
  Future<void> updatePost(PostModel post) async {
    debugPrint('PostRemoteDataSource: Updating post: ${post.id}');
    try {
      await firestore.collection('posts').doc(post.id).update({
        'description': post.description,
        'image': post.image,
        'likes': post.likes,
      });
      debugPrint('PostRemoteDataSource: Post updated successfully');
    } catch (e, stackTrace) {
      debugPrint('PostRemoteDataSource: Error updating post: $e');
      debugPrint('PostRemoteDataSource: Stack trace: $stackTrace');
      throw Exception('Failed to update post: $e');
    }
  }

  @override
  Future<void> likePost(String postId) async {
    debugPrint('PostRemoteDataSource: Liking post: $postId');
    try {
      final docRef = firestore.collection('posts').doc(postId);
      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        if (!snapshot.exists) {
          throw Exception('Post not found');
        }

        final currentLikes = (snapshot.data()?['likes'] as num?)?.toInt() ?? 0;
        transaction.update(docRef, {'likes': currentLikes + 1});
      });
      debugPrint('PostRemoteDataSource: Post liked successfully');
    } catch (e, stackTrace) {
      debugPrint('PostRemoteDataSource: Error liking post: $e');
      debugPrint('PostRemoteDataSource: Stack trace: $stackTrace');
      throw Exception('Failed to like post: $e');
    }
  }

  @override
  Future<void> unlikePost(String postId) async {
    debugPrint('PostRemoteDataSource: Unliking post: $postId');
    try {
      final docRef = firestore.collection('posts').doc(postId);
      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        if (!snapshot.exists) {
          throw Exception('Post not found');
        }

        final currentLikes = (snapshot.data()?['likes'] as num?)?.toInt() ?? 0;
        transaction.update(docRef, {'likes': currentLikes - 1});
      });
      debugPrint('PostRemoteDataSource: Post unliked successfully');
    } catch (e, stackTrace) {
      debugPrint('PostRemoteDataSource: Error unliking post: $e');
      debugPrint('PostRemoteDataSource: Stack trace: $stackTrace');
      throw Exception('Failed to unlike post: $e');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    debugPrint('PostRemoteDataSource: Deleting post: $postId');
    try {
      await firestore.collection('posts').doc(postId).delete();
      debugPrint('PostRemoteDataSource: Post deleted successfully');
    } catch (e, stackTrace) {
      debugPrint('PostRemoteDataSource: Error deleting post: $e');
      debugPrint('PostRemoteDataSource: Stack trace: $stackTrace');
      throw Exception('Failed to delete post: $e');
    }
  }

  PostModel _documentToPostModel(DocumentSnapshot doc) {
    debugPrint(
        'PostRemoteDataSource: Converting document to PostModel: ${doc.id}');
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
      comments: [],
    );
  }
}
