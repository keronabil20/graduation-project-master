// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:graduation_project/data/order_model.dart';
import 'package:graduation_project/domain/entities/order.dart';
import 'package:graduation_project/domain/usecases/order_usecases.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final CreateOrder _createOrder;
  final GetOrders _getOrders;
  final UpdateOrderStatus _updateOrderStatus;

  OrderCubit({
    required CreateOrder createOrder,
    required GetOrders getOrders,
    required UpdateOrderStatus updateOrderStatus,
  })  : _createOrder = createOrder,
        _getOrders = getOrders,
        _updateOrderStatus = updateOrderStatus,
        super(OrderInitial());

  Future<void> createOrder(Order order) async {
    emit(OrderLoading());
    try {
      final createdOrder = await _createOrder(OrderModel.fromEntity(order));
      emit(OrderCreated(createdOrder));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Stream<List<Order>> getOrdersStream(String restaurantId) {
    return _getOrders(restaurantId).map((orders) {
      emit(OrdersLoaded(orders));
      print('get order');
      return orders;
    }).handleError((error) {
      emit(OrderError(error.toString()));
    });
  }

  Future<void> updateStatus({
    required String restaurantId,
    required String orderId,
    required String newStatus,
  }) async {
    emit(OrderLoading());
    try {
      await _updateOrderStatus(
        restaurantId: restaurantId,
        orderId: orderId,
        status: newStatus,
      );
      emit(OrderStatusUpdated(orderId, newStatus));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> getRecentOrders(String restaurantId) async {
    try {
      emit(OrderLoading());
      final ordersStream = _getOrders(restaurantId);
      final orders = await ordersStream.first;
      final recentOrders = orders.take(3).toList();
      emit(OrdersLoaded(recentOrders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
