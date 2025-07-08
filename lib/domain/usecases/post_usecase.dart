// Dart imports:
import 'dart:io';

// Project imports:
import 'package:graduation_project/domain/entities/post.dart';
import 'package:graduation_project/domain/repo/post/post_repository.dart';

class GetPostsByRestaurant {
  final PostRepository repository;

  GetPostsByRestaurant(this.repository);

  Future<List<Post>> call(String restaurantId) {
    return repository.getPostsByRestaurant(restaurantId);
  }
}

class AddPost {
  final PostRepository repository;

  AddPost(this.repository);

  Future<void> call(Post post) {
    return repository.addPost(post);
  }
}

class UpdatePost {
  final PostRepository repository;

  UpdatePost(this.repository);

  Future<void> call(Post post) {
    return repository.updatePost(post);
  }
}

class LikePost {
  final PostRepository repository;

  LikePost(this.repository);

  Future<void> call(String postId, String userId) {
    return repository.likePost(postId, userId);
  }
}

class UnLikePost {
  final PostRepository repository;

  UnLikePost(this.repository);

  Future<void> call(String postId, String userId) {
    return repository.unlikePost(postId, userId); // Fixed method call here
  }
}

class DeletePost {
  final PostRepository repository;

  DeletePost(this.repository);

  Future<void> call(String postId) {
    return repository.deletePost(postId);
  }
}

class UploadPostImage {
  final PostRepository repository;

  UploadPostImage(this.repository);

  Future<void> call(File image, String postId) {
    // If repository expects a File path, send image.path
    // If it expects a File object, send the image directly
    return repository.uploadImage(image.path, postId);
  }
}
