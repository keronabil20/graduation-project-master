// create_order.dart

// Project imports:
import 'package:graduation_project/data/order_model.dart';
import 'package:graduation_project/domain/entities/order.dart';
import 'package:graduation_project/domain/repo/order/order_repository.dart';

class CreateOrder {
  final OrderRepository repository;

  CreateOrder(this.repository);

  Future<Order> call(OrderModel order) async {
    return await repository.createOrder(order);
  }
}

class GetOrdersTotalSum {
  final OrderRepository repository;

  GetOrdersTotalSum(this.repository);

  Future<double> call(String restaurantId) async {
    return await repository.getOrdersTotalSum(restaurantId);
  }
}

class GetOrdersCount {
  final OrderRepository repository;

  GetOrdersCount(this.repository);

  Future<int> call(String restaurantId) async {
    return await repository.getOrdersCount(restaurantId);
  }
}

// get_orders.dart
class GetOrders {
  final OrderRepository repository;

  GetOrders(this.repository);

  Stream<List<OrderModel>> call(String restaurantId) {
    return repository.getOrders(restaurantId);
  }
}

// update_order_status.dart
class UpdateOrderStatus {
  final OrderRepository repository;

  UpdateOrderStatus(this.repository);

  Future<void> call({
    required String restaurantId,
    required String orderId,
    required String status,
  }) async {
    return await repository.updateOrderStatus(
      restaurantId: restaurantId,
      orderId: orderId,
      status: status,
    );
  }
}
