// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:graduation_project/domain/repo/user/user_remote_data_source.dart';

class FirebaseUserDataSource implements UserRemoteDataSource {
  final FirebaseFirestore firestore;

  FirebaseUserDataSource({required this.firestore});

  @override
  Future<Map<String, dynamic>> getUser(String userId) async {
    final doc = await firestore.collection('users').doc(userId).get();
    return doc.data() ?? {};
  }

  @override
  Future updateUser(String userId, Map<String, dynamic> data) async {
    await firestore.collection('users').doc(userId).update(data);
  }
}
