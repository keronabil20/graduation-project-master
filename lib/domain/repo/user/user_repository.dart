// Project imports:
import 'package:graduation_project/domain/entities/user.dart';

abstract class UserRepository {
  Future<User> getUser(String userId);
  Future<void> updateUser(User user);
  String? getCurrentUserId();
}
