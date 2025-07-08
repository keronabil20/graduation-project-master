part of 'order_cubit.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrdersLoaded extends OrderState {
  final List<Order> orders;
  const OrdersLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

class OrderCreated extends OrderState {
  final Order order;

  const OrderCreated(this.order);

  @override
  List<Object> get props => [order];
}

class OrderStatusUpdated extends OrderState {
  final String orderId;
  final String newStatus;
  const OrderStatusUpdated(this.orderId, this.newStatus);

  @override
  List<Object> get props => [orderId, newStatus];
}

class OrderError extends OrderState {
  final String message;
  const OrderError(this.message);

  @override
  List<Object> get props => [message];
}
