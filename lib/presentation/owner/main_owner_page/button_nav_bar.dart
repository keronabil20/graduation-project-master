// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:graduation_project/utils/constants/constants.dart';

class LuxuryBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const LuxuryBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: SizedBox(
        height: 60.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              Icons.home,
              0,
            ),
            _buildNavItem(
              Icons.analytics,
              1,
            ),
            const SizedBox(width: 40),
            _buildNavItem(
              Icons.search,
              2,
            ),
            _buildNavItem(
              Icons.settings,
              3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    int index,
  ) {
    return IconButton(
      iconSize: 32.sp,
      icon: Icon(icon, size: 28.sp),
      onPressed: () => onTap(index),
      color: currentIndex == index ? deeporange : Colors.grey[400],
    );
  }
}
