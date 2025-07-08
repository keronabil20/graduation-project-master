// Project imports:
import 'package:graduation_project/domain/entities/post.dart';

abstract class PostRepository {
  /// Get all posts for a specific restaurant
  Future<List<Post>> getPostsByRestaurant(String restaurantId);

  /// Add a new post
  Future<void> addPost(Post post);

  /// Update an existing post
  Future<void> updatePost(Post post);

  /// Check if a post is liked by a user
  Future<bool> isPostLikedByUser(String postId, String userId);

  /// Like a post
  Future<void> likePost(String postId, String userId);

  /// Unlike a post
  Future<void> unlikePost(String postId, String userId);

  /// Delete a post
  Future<void> deletePost(String postId);

  /// Get all posts
  Future<List<Post>> getAllPosts();

  /// Get total like count for a post
  Future<int> getPostLikeCount(String postId);

  /// Uploads a base64 encoded image to Realtime Database
  /// NOTE: The `imageBase64` is the encoded string, not a File.
  Future<void> uploadImage(String imageBase64, String postId);
}
