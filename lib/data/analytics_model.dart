// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:graduation_project/domain/entities/analytics.dart';

class AnalyticsModel extends Analytics {
  AnalyticsModel({
    required super.id,
    required super.totalOrders,
    required super.totalRevenue,
    required super.createdAt,
  });

  factory AnalyticsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AnalyticsModel(
      id: doc.id,
      totalOrders: data['totalOrders'] ?? 0,
      totalRevenue: (data['totalRevenue'] ?? 0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  factory AnalyticsModel.fromEntity(Analytics entity) {
    return AnalyticsModel(
      id: entity.id.isNotEmpty
          ? entity.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      totalOrders: entity.totalOrders,
      totalRevenue: entity.totalRevenue,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'totalOrders': totalOrders,
      'totalRevenue': totalRevenue,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
