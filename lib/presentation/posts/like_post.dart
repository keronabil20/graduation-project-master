// components/post_like_button.dart

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:graduation_project/domain/repo/post/post_repository.dart';

class PostLikeButton extends StatefulWidget {
  final String postId;
  final String userId;
  final PostRepository repository;
  final void Function(bool isLiked)? onLikeChanged;
  const PostLikeButton({
    super.key,
    required this.postId,
    required this.userId,
    required this.repository,
    this.onLikeChanged,
  });

  @override
  State<PostLikeButton> createState() => _PostLikeButtonState();
}

class _PostLikeButtonState extends State<PostLikeButton> {
  bool _isLiked = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    setState(() => _isLoading = true);
    _isLiked =
        await widget.repository.isPostLikedByUser(widget.postId, widget.userId);
    setState(() => _isLoading = false);
  }

  Future<void> _toggleLike() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      if (_isLiked) {
        await widget.repository.unlikePost(widget.postId, widget.userId);
      } else {
        await widget.repository.likePost(widget.postId, widget.userId);
      }

      setState(() => _isLiked = !_isLiked);

      if (widget.onLikeChanged != null) {
        widget.onLikeChanged!(_isLiked);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to ${_isLiked ? 'unlike' : 'like'} post'),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _isLoading
          ? SizedBox(
              width: 14.w,
              height: 14.h,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border,
              color: _isLiked ? Colors.red : Colors.grey,
              size: 22.sp,
            ),
      onPressed: _toggleLike,
    );
  }
}
