// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

// Project imports:
import 'package:graduation_project/data/post_model.dart';
import 'package:graduation_project/domain/entities/post.dart';
import 'package:graduation_project/domain/repo/post/post_remote_datasource.dart';
import 'package:graduation_project/domain/repo/post/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PostRepositoryImpl({required this.remoteDataSource});
  @override
  Future<List<Post>> getPostsByRestaurant(String restaurantId) async {
    final querySnapshot = await _firestore
        .collection('posts')
        .where('restaurantId', isEqualTo: restaurantId)
        .get();

    return querySnapshot.docs
        .map((doc) => PostModel.fromFirestore(doc).toDomain())
        .toList();
  }

  @override
  Future<List<Post>> getAllPosts() async {
    debugPrint('PostRepositoryImpl: Getting all posts');
    try {
      final postDtos = await remoteDataSource.getAllPosts();
      debugPrint('PostRepositoryImpl: Fetched ${postDtos.length} posts');
      return postDtos.map((dto) => dto.toDomain()).toList();
    } catch (e) {
      debugPrint('PostRepositoryImpl: Error getting all posts: $e');
      throw Exception('Failed to get all posts: $e');
    }
  }

  @override
  Future<void> addPost(Post post) async {
    debugPrint('PostRepositoryImpl: Starting addPost');
    try {
      final postModel = PostModel(
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
      debugPrint('PostRepositoryImpl: Created PostModel');

      await remoteDataSource.createPost(postModel);
      debugPrint('PostRepositoryImpl: Post created successfully');
    } catch (e, stackTrace) {
      debugPrint('PostRepositoryImpl: Error adding post: $e');
      debugPrint('PostRepositoryImpl: Stack trace: $stackTrace');
      throw Exception('Failed to add post: $e');
    }
  }

  @override
  Future<void> updatePost(Post post) async {
    debugPrint('PostRepositoryImpl: Updating post: ${post.id}');
    try {
      final postModel = PostModel(
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
      await remoteDataSource.updatePost(postModel);
      debugPrint('PostRepositoryImpl: Post updated successfully');
    } catch (e) {
      debugPrint('PostRepositoryImpl: Error updating post: $e');
      throw Exception('Failed to update post: $e');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    debugPrint('PostRepositoryImpl: Deleting post: $postId');
    try {
      await remoteDataSource.deletePost(postId);
      debugPrint('PostRepositoryImpl: Post deleted successfully');
    } catch (e) {
      debugPrint('PostRepositoryImpl: Error deleting post: $e');
      throw Exception('Failed to delete post: $e');
    }
  }

  @override
  Future<void> likePost(String postId, String userId) async {
    debugPrint('PostRepositoryImpl: Liking post: $postId by user: $userId');
    try {
      await _firestore.runTransaction((transaction) async {
        final userRef = _firestore.collection('users').doc(userId);
        transaction.update(userRef, {
          'likedPosts': FieldValue.arrayUnion([postId])
        });

        final postRef = _firestore.collection('posts').doc(postId);
        transaction.update(postRef, {'likes': FieldValue.increment(1)});
      });
      debugPrint('PostRepositoryImpl: Post liked successfully');
    } catch (e) {
      debugPrint('PostRepositoryImpl: Error liking post: $e');
      throw Exception('Failed to like post: $e');
    }
  }

  @override
  Future<void> unlikePost(String postId, String userId) async {
    debugPrint('PostRepositoryImpl: Unliking post: $postId by user: $userId');
    try {
      await _firestore.runTransaction((transaction) async {
        final userRef = _firestore.collection('users').doc(userId);
        transaction.update(userRef, {
          'likedPosts': FieldValue.arrayRemove([postId])
        });

        final postRef = _firestore.collection('posts').doc(postId);
        transaction.update(postRef, {'likes': FieldValue.increment(-1)});
      });
      debugPrint('PostRepositoryImpl: Post unliked successfully');
    } catch (e) {
      debugPrint('PostRepositoryImpl: Error unliking post: $e');
      throw Exception('Failed to unlike post: $e');
    }
  }

  @override
  Future<bool> isPostLikedByUser(String postId, String userId) async {
    debugPrint(
        'PostRepositoryImpl: Checking if post: $postId is liked by user: $userId');
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final likedPosts = List<String>.from(userDoc.data()?['likedPosts'] ?? []);
      final isLiked = likedPosts.contains(postId);
      debugPrint(
          'PostRepositoryImpl: Post is ${isLiked ? 'liked' : 'not liked'} by user');
      return isLiked;
    } catch (e) {
      debugPrint('PostRepositoryImpl: Error checking post like status: $e');
      throw Exception('Failed to check if post is liked: $e');
    }
  }

  @override
  Future<int> getPostLikeCount(String postId) async {
    debugPrint('PostRepositoryImpl: Getting like count for post: $postId');
    try {
      final doc = await _firestore.collection('posts').doc(postId).get();
      if (doc.exists) {
        final likes = (doc.data()?['likes'] as num?)?.toInt() ?? 0;
        debugPrint('PostRepositoryImpl: Post has $likes likes');
        return likes;
      }
      debugPrint('PostRepositoryImpl: Post not found');
      return 0;
    } catch (e) {
      debugPrint('PostRepositoryImpl: Error getting like count: $e');
      throw Exception('Failed to get like count');
    }
  }

  @override
  Future<void> uploadImage(String imageBase64, String postId) async {
    debugPrint('PostRepositoryImpl: Uploading image for post: $postId');
    try {
      final databaseRef = FirebaseDatabase.instance.ref("images/$postId");
      await databaseRef.set({
        'base64': imageBase64,
        'timestamp': DateTime.now().toIso8601String(),
      });
      debugPrint('PostRepositoryImpl: Image uploaded successfully');
    } catch (e) {
      debugPrint('PostRepositoryImpl: Error uploading image: $e');
      throw Exception('Failed to upload image to Realtime DB');
    }
  }
}
