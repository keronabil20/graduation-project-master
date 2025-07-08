// Package imports:
import 'package:firebase_auth/firebase_auth.dart' as auth;

// Project imports:
import 'package:graduation_project/data/user_model.dart';
import 'package:graduation_project/domain/entities/user.dart';
import 'package:graduation_project/domain/repo/user/user_remote_data_source.dart';
import 'package:graduation_project/domain/repo/user/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> getUser(String userId) async {
    final userData = await remoteDataSource.getUser(userId);
    return UserModel.fromMap(userData, userId);
  }

  @override
  Future<void> updateUser(User user) async {
    await remoteDataSource.updateUser(
      user.id,
      UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        emailVerified: user.emailVerified,
        userType: user.userType,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
        image: user.image,
      ).toFirestore(),
    );
  }

  @override
  Future<String?> getCurrentOwnerRestaurantId() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return null;

    final userData = await remoteDataSource.getUser(currentUser.uid);
    return userData['restaurantId'] as String?;
  }

  @override
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }
}
