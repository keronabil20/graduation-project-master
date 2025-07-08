// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get_it/get_it.dart';

// Project imports:
import 'package:graduation_project/domain/entities/post.dart';
import 'package:graduation_project/domain/repo/post/post_repository.dart';
import 'package:graduation_project/presentation/auth/login/auth_service.dart';
import 'package:graduation_project/presentation/posts/post_card.dart';

class RestaurantPostsScreen extends StatefulWidget {
  final String restaurantId;

  const RestaurantPostsScreen({super.key, required this.restaurantId});

  @override
  State<RestaurantPostsScreen> createState() => _RestaurantPostsScreenState();
}

class _RestaurantPostsScreenState extends State<RestaurantPostsScreen> {
  late Future<List<Post>> _postsFuture;
  final PostRepository _postRepo = GetIt.instance.get<PostRepository>();

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  void _loadPosts() {
    _postsFuture = _postRepo.getPostsByRestaurant(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final posts = snapshot.data ?? [];

          if (posts.isEmpty) {
            return const Center(child: Text('No posts found'));
          }

          return _PostList(posts: posts);
        },
      ),
    );
  }
}

class _PostList extends StatelessWidget {
  final List<Post> posts;

  const _PostList({required this.posts});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostCard(
              post: post,
              currentUserId: AuthService().currentUser?.uid ?? '',
            ),
          ],
        );
      },
    );
  }
}
