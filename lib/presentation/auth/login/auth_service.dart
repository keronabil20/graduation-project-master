// Dart imports:
import 'dart:async';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      // Validate email format first
      if (!_isValidEmail(email)) {
        throw FirebaseAuthException(
          code: 'invalid-email',
          message: 'The email address is badly formatted',
        );
      }

      // Trim inputs and validate non-empty
      final trimmedEmail = email.trim();
      final trimmedPassword = password.trim();

      if (trimmedPassword.isEmpty) {
        throw FirebaseAuthException(
          code: 'empty-password',
          message: 'Password cannot be empty',
        );
      }

      // Perform sign-in with timeout
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(
            email: trimmedEmail,
            password: trimmedPassword,
          )
          .timeout(const Duration(seconds: 30));

      // Check email verification
      if (!userCredential.user!.emailVerified) {
        await _auth.signOut(); // Sign out unverified users
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Please verify your email first',
        );
      }

      return userCredential.user;
    } on FirebaseAuthException {
      rethrow; // Re-throw specific auth errors
    } on TimeoutException {
      throw FirebaseAuthException(
        code: 'timeout',
        message: 'Connection timed out. Please try again.',
      );
    } catch (e) {
      throw FirebaseAuthException(
        code: 'login-failed',
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    ).hasMatch(email.trim());
  }
}
