// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Project imports:
import 'package:graduation_project/generated/l10n.dart';
import 'package:graduation_project/presentation/splash_screen&onboarding/onboarding_screen(1).dart';
import 'package:graduation_project/presentation/splash_screen&onboarding/onboarding_screen(2).dart';
import 'package:graduation_project/presentation/splash_screen&onboarding/onboarding_screen(3).dart';
import 'package:graduation_project/routes/on_boarding_helper.dart';
import 'package:graduation_project/routes/routes.dart';
import 'package:graduation_project/utils/constants/constants.dart';
import 'package:graduation_project/utils/widgets/custome_widgets/elevated_button.dart';

class OnboardingScreenController extends StatefulWidget {
  const OnboardingScreenController({
    super.key,
  });

  @override
  State<OnboardingScreenController> createState() =>
      _OnboardingScreenControllerState();
}

class _OnboardingScreenControllerState
    extends State<OnboardingScreenController> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            // PageView for splash screens
            Expanded(
              child: PageView(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                children: const [
                  OnboardingScreen1(),
                  OnboardingScreen2(),
                  OnboardingScreen3(),
                ],
              ),
            ),

            // Smooth Page Indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: const WormEffect(
                  dotColor: Colors.grey,
                  activeDotColor: deeporange,
                ),
              ),
            ),

            // Next button
            createNavigateButton(context),
          ],
        ),
      ),
    );
  }

  Padding createNavigateButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomButton(
            onPressed: () async {
              if (_currentPage < 2) {
                _controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                await OnboardingHelper.setOnboardingCompleted();
                Navigator.pushReplacementNamed(context, AppRoutes.authWrapper);
              }
            },
            text: S.of(context).next,
          ),
        ],
      ),
    );
  }
}
