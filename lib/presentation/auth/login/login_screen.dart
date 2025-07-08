// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:graduation_project/generated/l10n.dart';
import 'package:graduation_project/presentation/auth/forget_password/forget_pass_screen.dart';
import 'package:graduation_project/presentation/auth/login/auth_service.dart';
import 'package:graduation_project/presentation/auth/login/login_handler.dart';
import 'package:graduation_project/utils/constants/constants.dart';
import 'package:graduation_project/utils/services/error_handler.dart';
import 'package:graduation_project/utils/widgets/custome_widgets/custome-textform.dart';
import 'package:graduation_project/utils/widgets/custome_widgets/dialog_helper.dart';
import 'package:graduation_project/utils/widgets/custome_widgets/wide_button.dart';

class LoginContent extends StatefulWidget {
  const LoginContent({super.key});

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  final LoginHandler _loginHandler = LoginHandler(FirebaseFirestore.instance);
  final ErrorHandler _errorHandler = ErrorHandler();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    try {
      final user = await AuthService().signInWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (user != null) {
        await _loginHandler.handleUserNavigation(user.uid, context);
      }
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.code);
    } on FirebaseException catch (e) {
      _showErrorDialog(e.code);
    } catch (e) {
      _showErrorDialog('generic-error');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showErrorDialog(String errorCode) {
    DialogHelper.showAwesomeDialog(
      context: context,
      title: "Login Failed",
      message: _errorHandler.getAuthErrorMessage(errorCode),
      dialogType: DialogType.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextFormField(
              labelText: S.of(context).email,
              controller: emailController,
              validator: (value) => _validateEmail(value),
            ),
            SizedBox(height: 20.h),
            CustomTextFormField(
              labelText: S.of(context).password,
              obscureText: true,
              controller: passwordController,
              validator: (value) => _validatePassword(value),
            ),
            SizedBox(height: 20.h),
            WideButton(
              text: isLoading ? S.of(context).loading : S.of(context).login,
              onTap: isLoading ? null : _login,
            ),
            SizedBox(height: 20.h),
            TextButton(
              onPressed: () => _navigateToForgotPassword(),
              child: Text(
                S.of(context).forgotPassword,
                style: TextStyle(color: deeporange),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  void _navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordScreen(),
      ),
    );
  }
}
