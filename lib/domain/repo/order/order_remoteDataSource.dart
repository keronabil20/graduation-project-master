// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import 'package:graduation_project/data/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> createOrder(OrderModel order);
  Stream<List<OrderModel>> getOrders(String restaurantId);
  Future<double> getOrdersTotalSum(String restaurantId);

  Future<void> updateOrderStatus({
    required String restaurantId,
    required String orderId,
    required String status,
  });
  Future<void> deleteOrder({
    required String restaurantId,
    required String orderId,
  });
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final FirebaseFirestore firestore;

  OrderRemoteDataSourceImpl({required this.firestore});

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    final docRef = firestore
        .collection('restaurants')
        .doc(order.restaurantId)
        .collection('orders')
        .doc(); // generate new ID

    final orderWithId = order.copyWith(id: docRef.id);

    await docRef.set(orderWithId.toFirestore()); // Save to Firestore

    return OrderModel.fromEntity(orderWithId); // Return saved model
  }

  @override
  Stream<List<OrderModel>> getOrders(String restaurantId) {
    return firestore
        .collection('restaurants')
        .doc(restaurantId)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromFirestore(doc.id, doc.data());
      }).toList();
    });
  }

  @override
  Future<void> updateOrderStatus({
    required String restaurantId,
    required String orderId,
    required String status,
  }) async {
    await firestore
        .collection('restaurants')
        .doc(restaurantId)
        .collection('orders')
        .doc(orderId)
        .update({'status': status});
  }

  @override
  Future<void> deleteOrder({
    required String restaurantId,
    required String orderId,
  }) async {
    await firestore
        .collection('restaurants')
        .doc(restaurantId)
        .collection('orders')
        .doc(orderId)
        .delete();
  }

  @override
  Future<int> getOrdersCount(String restaurantId) async {
    final querySnapshot = await firestore
        .collection('restaurants')
        .doc(restaurantId)
        .collection('orders')
        .get();

    return querySnapshot.docs.length; // Return the count of orders
  }

  @override
  Future<double> getOrdersTotalSum(String restaurantId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Authentication required');

      final querySnapshot = await firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('orders')
          .get();

      return querySnapshot.docs.fold<double>(
        0.0,
        (sum, doc) => sum + (doc.data()['total'] as num).toDouble(),
      );
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        debugPrint('Permission denied for restaurant $restaurantId');
      }
      rethrow;
    }
  }
}
