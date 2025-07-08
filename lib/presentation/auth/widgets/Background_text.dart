// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:

class BackgroundText extends StatelessWidget {
  const BackgroundText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        'assets/images/Frame 34458.svg',
        width: 200.w,
        height: 200.h,
      ),
    );
  }
}
