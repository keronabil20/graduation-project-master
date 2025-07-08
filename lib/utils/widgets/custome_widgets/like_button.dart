// components/like_button.dart

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:graduation_project/domain/repo/restaurant/restaurant_repository.dart';

class LikeButton extends StatefulWidget {
  final String restaurantId;
  final String userId;
  final RestaurantRepository repository;

  const LikeButton({
    super.key,
    required this.restaurantId,
    required this.userId,
    required this.repository,
  });

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    setState(() => _isLoading = true);
    _isLiked = await widget.repository.isRestaurantLiked(
      widget.userId,
      widget.restaurantId,
    );
    setState(() => _isLoading = false);
  }

  Future<void> _toggleLike() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      if (_isLiked) {
        await widget.repository.unlikeRestaurant(
          widget.userId,
          widget.restaurantId,
        );
      } else {
        await widget.repository.likeRestaurant(
          widget.userId,
          widget.restaurantId,
        );
      }
      setState(() => _isLiked = !_isLiked);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Failed to ${_isLiked ? 'unlike' : 'like'} restaurant')),
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
              width: 12.w,
              height: 12.h,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border,
              color: _isLiked ? Colors.red : Colors.red,
              size: 18.sp,
            ),
      onPressed: _toggleLike,
    );
  }
}
