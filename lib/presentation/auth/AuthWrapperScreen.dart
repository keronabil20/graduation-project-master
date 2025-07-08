// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:graduation_project/presentation/auth/login/login_screen.dart';
import 'package:graduation_project/presentation/auth/sign_up/sign_up_screen.dart';
import 'package:graduation_project/presentation/auth/widgets/Background_text.dart';
import 'package:graduation_project/presentation/auth/widgets/clipper.dart';
import 'package:graduation_project/presentation/auth/widgets/toggle_buttons.dart';
import 'package:graduation_project/utils/constants/constants.dart';

class AuthWrapperScreen extends StatefulWidget {
  const AuthWrapperScreen({super.key});

  @override
  State<AuthWrapperScreen> createState() => _AuthWrapperScreenState();
}

class _AuthWrapperScreenState extends State<AuthWrapperScreen> {
  bool showLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with clipper
          ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              color: deeporange,
              height: MediaQuery.of(context).size.height * 0.5,
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 50.h),
                  const BackgroundText(),
                  SizedBox(height: 20.h),

                  // Toggle buttons container
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(30.r),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: SlidingToggleButtons(
                            onToggle: (index) {
                              setState(() {
                                showLogin = index == 0;
                              });
                            },
                            delegate: DefaultToggleButtonDelegate(),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Smooth sliding transition between login and signup
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder: (child, animation) {
                            final offsetAnimation = Tween<Offset>(
                              begin: Offset(showLogin ? 1 : -1, 0),
                              end: Offset.zero,
                            ).animate(animation);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                          child: showLogin
                              ? const LoginContent(
                                  key: ValueKey('LoginContent'))
                              : const SignupContent(
                                  key: ValueKey('SignupContent')),
                        ),
                      ],
                    ),
                  ),

                  // Google and Facebook buttons
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
