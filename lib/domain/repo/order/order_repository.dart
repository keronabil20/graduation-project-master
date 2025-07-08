// Project imports:
import 'package:graduation_project/data/order_model.dart';
import 'package:graduation_project/domain/entities/order.dart';

abstract class OrderRepository {
  Future<Order> createOrder(Order order);
  Stream<List<OrderModel>> getOrders(String restaurantId);
  Future<void> updateOrderStatus({
    required String restaurantId,
    required String orderId,
    required String status,
  });
  Future<void> deleteOrder({
    required String restaurantId,
    required String orderId,
  });
  Future<double> getOrdersTotalSum(String restaurantId);
  Future<int> getOrdersCount(String restaurantId);
}
