// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:graduation_project/utils/image_utils.dart';

class LuxuryAppBar extends StatelessWidget {
  final Map<String, dynamic> restaurant;
  const LuxuryAppBar({super.key, required this.restaurant, required menuItems});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250.h,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Cover Image using ImageUtils
            ImageUtils.imageFromBase64String(
              restaurant['coverUrl'] ?? '',
              height: 250.h,
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
        title: Text(
          restaurant['name'] ?? 'Restaurant',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            shadows: const [
              Shadow(
                color: Colors.black,
                blurRadius: 10,
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
    );
  }
}
