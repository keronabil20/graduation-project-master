// Project imports:
import 'package:graduation_project/data/analytics_model.dart';
import 'package:graduation_project/data/order_model.dart';
import 'package:graduation_project/domain/entities/order.dart';
import 'package:graduation_project/domain/repo/order/order_remoteDataSource.dart';
import 'package:graduation_project/domain/repo/order/order_repository.dart';

import 'package:graduation_project/domain/repo/analytics/analytics_repository.dart'; // Import AnalyticsRepository
import 'package:graduation_project/domain/entities/analytics.dart'; // Import Analytics entity

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final AnalyticsRepository analyticsRepository; // Add AnalyticsRepository

  OrderRepositoryImpl(
      {required this.remoteDataSource,
      required this.analyticsRepository}); // Update constructor

  @override
  Future<OrderModel> createOrder(Order order) async {
    final orderModel = OrderModel.fromEntity(order);
    final createdOrder = await remoteDataSource.createOrder(orderModel);

    // Update analytics after successful order creation
    await _updateAnalytics(createdOrder.restaurantId, createdOrder.total);

    return createdOrder;
  }

  @override
  Stream<List<OrderModel>> getOrders(String restaurantId) {
    return remoteDataSource.getOrders(restaurantId);
  }

  @override
  Future<void> updateOrderStatus({
    required String restaurantId,
    required String orderId,
    required String status,
  }) async {
    await remoteDataSource.updateOrderStatus(
      restaurantId: restaurantId,
      orderId: orderId,
      status: status,
    );
  }

  @override
  Future<void> deleteOrder({
    required String restaurantId,
    required String orderId,
  }) async {
    await remoteDataSource.deleteOrder(
      restaurantId: restaurantId,
      orderId: orderId,
    );
  }

  @override
  getOrdersCount(String restaurantId) async {
    final orders = await remoteDataSource.getOrders(restaurantId).first;
    return orders.length;
  }

  @override
  Future<double> getOrdersTotalSum(String restaurantId) async {
    return await remoteDataSource.getOrdersTotalSum(restaurantId);
  }

  Future<void> _updateAnalytics(String restaurantId, double totalAmount) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Fetch existing analytics for today
    List<Analytics> existingAnalytics =
        await analyticsRepository.getAnalytics(restaurantId);

    AnalyticsModel analytics;
    if (existingAnalytics.isNotEmpty &&
        existingAnalytics.first.createdAt.year == today.year &&
        existingAnalytics.first.createdAt.month == today.month &&
        existingAnalytics.first.createdAt.day == today.day) {
      // Update existing analytics
      analytics = AnalyticsModel(
        id: existingAnalytics.first.id,
        totalOrders: existingAnalytics.first.totalOrders + 1,
        totalRevenue: existingAnalytics.first.totalRevenue + totalAmount,
        createdAt: existingAnalytics.first.createdAt,
      );
    } else {
      // Create new analytics
      analytics = AnalyticsModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        totalOrders: 1,
        totalRevenue: totalAmount,
        createdAt: today,
      );
    }

    // Save analytics
    await analyticsRepository.saveAnalytics(restaurantId, analytics);
  }
}
