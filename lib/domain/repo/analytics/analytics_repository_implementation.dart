// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:graduation_project/data/analytics_model.dart';
import 'package:graduation_project/domain/entities/analytics.dart';
import 'package:graduation_project/domain/repo/analytics/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final FirebaseFirestore firestore;

  AnalyticsRepositoryImpl(this.firestore);

  @override
  Future<List<Analytics>> getAnalytics(String restaurantId) async {
    try {
      final snapshot = await firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('analytics')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => AnalyticsModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching analytics: $e');
      }
      return [];
    }
  }

  @override
  Future<void> saveAnalytics(String restaurantId, Analytics analytics) async {
    try {
      final analyticsModel = AnalyticsModel.fromEntity(analytics);
      final docRef = firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('analytics')
          .doc(analyticsModel.id.isNotEmpty
              ? analyticsModel.id
              : DateTime.now()
                  .millisecondsSinceEpoch
                  .toString()); // Use a valid document ID

      await docRef.set(analyticsModel.toFirestore(), SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print('Error saving analytics: $e');
      }
    }
  }
}
