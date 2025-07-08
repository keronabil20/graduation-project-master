part of 'posts_cubit.dart';

abstract class PostsState {}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  final List<Post> posts;

  PostsLoaded({required this.posts});
}

class PostsError extends PostsState {
  final String message;

  PostsError({required this.message});
}
