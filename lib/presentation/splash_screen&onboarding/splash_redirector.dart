// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:graduation_project/routes/on_boarding_helper.dart';
import 'package:graduation_project/routes/routes.dart';

class SplashRedirector extends StatefulWidget {
  const SplashRedirector({super.key});

  @override
  State<SplashRedirector> createState() => _SplashRedirectorState();
}

class _SplashRedirectorState extends State<SplashRedirector> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    // Wait for native splash to complete
    await Future.delayed(const Duration(milliseconds: 500));

    final isOnboardingCompleted =
        await OnboardingHelper.isOnboardingCompleted();
    if (!mounted) return;

    Navigator.of(context).pushReplacementNamed(
      isOnboardingCompleted ? AppRoutes.authWrapper : AppRoutes.onboarding,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Fallback if needed
      ),
    );
  }
}
