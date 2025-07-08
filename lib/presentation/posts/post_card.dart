// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

// Project imports:
import 'package:graduation_project/domain/entities/post.dart';
import 'package:graduation_project/domain/repo/post/post_repository.dart';
import 'package:graduation_project/presentation/posts/like_post.dart';

final PostRepository repository = GetIt.I<PostRepository>();

class PostCard extends StatefulWidget {
  final Post post;
  final String currentUserId;
  final void Function(String postId, bool isLiked)? onLikeChanged;

  const PostCard({
    super.key,
    required this.post,
    required this.currentUserId,
    this.onLikeChanged,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late int _likes;
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    _likes = widget.post.likes;
    _isLiked = false; // Will be set correctly by the button
  }

  void _handleLikeChanged(bool isLiked) {
    setState(() {
      _isLiked = isLiked;
      _likes += isLiked ? 1 : -1;
    });

    widget.onLikeChanged?.call(widget.post.id, isLiked);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 20.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      elevation: 3,
      shadowColor: Colors.grey.withOpacity(0.3),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Image ───
          Image.memory(
            base64Decode(widget.post.image),
            height: 200.h,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 200.h,
              width: double.infinity,
              color: Colors.grey[200],
              child: Icon(Icons.broken_image, size: 40.sp),
            ),
          ),

          // ─── Post Body ───
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Description ───
                Text(
                  widget.post.description,
                  style: TextStyle(
                    fontSize: 15.sp,
                    height: 1.5,
                    color: Colors.grey[900],
                  ),
                ),
                SizedBox(height: 16.h),

                // ─── Like and Date ───
                Row(
                  children: [
                    PostLikeButton(
                      postId: widget.post.id,
                      userId: widget.currentUserId,
                      repository: repository,
                      onLikeChanged: _handleLikeChanged,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      _likes.toString(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.access_time, size: 16.sp, color: Colors.grey),
                    SizedBox(width: 4.w),
                    Text(
                      DateFormat('MMM d, y').format(widget.post.createdAt),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
