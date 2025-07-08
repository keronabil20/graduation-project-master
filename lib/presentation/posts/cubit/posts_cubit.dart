// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:graduation_project/domain/entities/post.dart';
import 'package:graduation_project/domain/repo/post/post_repository.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  final PostRepository postRepository;

  PostsCubit({required this.postRepository}) : super(PostsInitial()) {
    fetchPosts(); // Fetch posts on cubit creation
  }

  Future<void> fetchPosts() async {
    emit(PostsLoading());
    try {
      final posts = await postRepository.getAllPosts();
      emit(PostsLoaded(posts: posts));
    } catch (e) {
      emit(PostsError(message: e.toString()));
    }
  }

  void updatePostLikeStatus(String postId, bool isLiked) {
    if (state is PostsLoaded) {
      final currentState = state as PostsLoaded;

      final updatedPosts = currentState.posts.map((post) {
        if (post.id == postId) {
          final updatedLikes = isLiked ? post.likes + 1 : post.likes - 1;
          return post.copyWith(
            likes: updatedLikes,
          ); // Ensure you have `copyWith` method in `Post`
        }
        return post;
      }).toList();

      emit(PostsLoaded(posts: updatedPosts));
    }
  }

  Future<void> refreshPosts() async {
    await fetchPosts();
  }
}
