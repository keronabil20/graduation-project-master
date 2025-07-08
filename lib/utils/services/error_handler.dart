// Package imports:
import 'package:firebase_core/firebase_core.dart';

class ErrorHandler {
  String getAuthErrorMessage(String code) {
    switch (code) {
      // Firebase Auth Errors
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'user-not-found':
        return 'No account found for this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      case 'account-exists-with-different-credential':
        return 'Account already exists with different credentials';
      case 'invalid-credential':
        return 'Invalid authentication credentials';
      case 'invalid-verification-code':
        return 'Invalid verification code';
      case 'invalid-verification-id':
        return 'Invalid verification ID';
      case 'requires-recent-login':
        return 'This operation requires recent authentication. Please log in again';

      // Firebase Firestore Errors
      case 'permission-denied':
        return 'You don\'t have permission to access this resource';
      case 'not-found':
        return 'Requested document not found';
      case 'already-exists':
        return 'Document already exists';
      case 'resource-exhausted':
        return 'Resource limit reached. Please try again later';
      case 'failed-precondition':
        return 'Operation was rejected';
      case 'aborted':
        return 'Operation aborted';
      case 'unavailable':
        return 'Service is currently unavailable';

      // Generic Errors
      case 'network-error':
        return 'Network error occurred. Please check your connection';
      case 'generic-error':
      default:
        return 'An error occurred. Please try again';
    }
  }

  String getFirestoreErrorMessage(FirebaseException e) {
    return getAuthErrorMessage(e.code);
  }

  String getGenericErrorMessage() {
    return getAuthErrorMessage('generic-error');
  }
}
