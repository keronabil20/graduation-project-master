// Package imports:
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:graduation_project/utils/services/error_handler.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final ErrorHandler _errorHandler;

  AuthCubit({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    ErrorHandler? errorHandler,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _errorHandler = errorHandler ?? ErrorHandler(),
        super(AuthInitial());

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required bool isRestaurantOwner,
    String? restaurantName,
    String? restaurantAddress,
  }) async {
    emit(AuthLoading());
    try {
      _validateSignUpInputs(
        isRestaurantOwner: isRestaurantOwner,
        restaurantName: restaurantName,
        restaurantAddress: restaurantAddress,
      );

      final userCredential = await _createUser(email, password);
      await _sendEmailVerification(userCredential.user!);
      await _storeUserData(
        user: userCredential.user!,
        name: name,
        email: email,
        isRestaurantOwner: isRestaurantOwner,
        restaurantName: restaurantName,
        restaurantAddress: restaurantAddress,
      );

      emit(AuthSuccess(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_errorHandler.getAuthErrorMessage(e.code)));
    } on FirebaseException catch (e) {
      emit(AuthFailure(_errorHandler.getFirestoreErrorMessage(e)));
    } catch (e) {
      emit(AuthFailure(_errorHandler.getGenericErrorMessage()));
    }
  }

  void _validateSignUpInputs({
    required bool isRestaurantOwner,
    String? restaurantName,
    String? restaurantAddress,
  }) {
    if (isRestaurantOwner &&
        (restaurantName == null || restaurantAddress == null)) {
      throw FirebaseAuthException(
        code: 'invalid-argument',
        message: 'Restaurant owners must provide name and address',
      );
    }
  }

  Future<UserCredential> _createUser(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> _sendEmailVerification(User user) async {
    await user.sendEmailVerification();
  }

  Future<void> _storeUserData({
    required User user,
    required String name,
    required String email,
    required bool isRestaurantOwner,
    String? restaurantName,
    String? restaurantAddress,
  }) async {
    final userData = {
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'emailVerified': false,
    };

    final collection = isRestaurantOwner ? 'owners' : 'users';
    final documentData = isRestaurantOwner
        ? {
            ...userData,
            'userType': 'owner',
            'restaurantName': restaurantName,
            'restaurantAddress': restaurantAddress,
            'verified': false,
            'status': 'pending',
          }
        : {
            ...userData,
            'userType': 'user',
          };

    await _firestore.collection(collection).doc(user.uid).set(documentData);
  }
}
