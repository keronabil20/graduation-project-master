// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseCommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveComment({
    required String restaurantId,
    required String comment,
    required bool commentResult,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not logged in');

      await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('comments')
          .add({
        'comment': comment,
        'commentResult': commentResult,
        'userRef': _firestore.doc('users/${user.uid}'),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to save comment: $e');
    }
  }

  Future<QuerySnapshot> getAllRestaurantComments({
    required String restaurantId,
  }) async {
    try {
      return await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .get();
    } catch (e) {
      throw Exception('Failed to load comments: $e');
    }
  }
}
