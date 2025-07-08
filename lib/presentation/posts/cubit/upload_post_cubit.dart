// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:graduation_project/domain/entities/post.dart';
import 'package:graduation_project/domain/repo/post/post_repository.dart';

part 'upload_post_state.dart';

class UploadPostCubit extends Cubit<UploadPostState> {
  final PostRepository postRepository;

  UploadPostCubit({required this.postRepository}) : super(UploadPostInitial());

  Future<void> uploadPost({
    required String userId,
    required String username,
    required String restaurantId,
    required String description,
    required File image,
  }) async {
    debugPrint('Starting post upload...');
    debugPrint('User ID: $userId');
    debugPrint('Username: $username');
    debugPrint('Restaurant ID: $restaurantId');
    debugPrint('Description length: ${description.length}');
    debugPrint('Image path: ${image.path}');

    if (description.trim().isEmpty || image.path.isEmpty) {
      debugPrint('Validation failed: Description or image is empty');
      emit(UploadPostError('Description and image are required'));
      return;
    }

    emit(UploadPostLoading());
    debugPrint('Emitted loading state');

    try {
      // Convert image to base64
      debugPrint('Converting image to base64...');
      final imageBytes = await image.readAsBytes();
      final base64Image = base64Encode(imageBytes);
      debugPrint('Image converted to base64, length: ${base64Image.length}');

      // Generate unique post ID
      final postId = const Uuid().v4();
      debugPrint('Generated post ID: $postId');

      // Create post object
      final post = Post(
        id: postId,
        userId: userId,
        username: username,
        restaurantId: restaurantId,
        description: description.trim(),
        image: base64Image,
        likes: 0,
        createdAt: DateTime.now(),
        comments: [],
      );
      debugPrint('Created post object');

      // Upload post to Firestore
      debugPrint('Uploading post to Firestore...');
      await postRepository.addPost(post);
      debugPrint('Post uploaded successfully');

      emit(UploadPostSuccess());
      debugPrint('Emitted success state');
    } catch (e, stackTrace) {
      debugPrint('Error uploading post: $e');
      debugPrint('Stack trace: $stackTrace');
      emit(UploadPostError('Failed to upload post: ${e.toString()}'));
    }
  }
}
