// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:graduation_project/presentation/auth/login/auth_service.dart';
import 'package:graduation_project/presentation/posts/cubit/posts_cubit.dart';
import 'package:graduation_project/presentation/posts/post_card.dart';

class PostsListScreen extends StatelessWidget {
  const PostsListScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<PostsCubit, PostsState>(
        listener: (context, state) {
          if (state is PostsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PostsInitial || state is PostsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PostsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<PostsCubit>().fetchPosts(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is PostsLoaded) {
            final posts = state.posts;
            if (posts.isEmpty) {
              return const Center(
                child: Text('No posts available. Create your first post!'),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<PostsCubit>().fetchPosts(),
              child: ListView.separated(
                padding: EdgeInsets.all(16.sp),
                itemCount: posts.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) => PostCard(
                  post: posts[index],
                  currentUserId: AuthService().currentUser?.uid ?? '',
                  onLikeChanged: (postId, isLiked) {
                    context
                        .read<PostsCubit>()
                        .updatePostLikeStatus(postId, isLiked);
                  },
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
