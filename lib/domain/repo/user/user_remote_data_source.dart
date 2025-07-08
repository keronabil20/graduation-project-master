abstract class UserRemoteDataSource {
  Future<Map<String, dynamic>> getUser(String userId);
  Future updateUser(String userId, Map<String, dynamic> data);
}
