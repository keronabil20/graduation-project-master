part of 'dashboard_cubit.dart';

class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}

abstract class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardNoRestaurant extends DashboardState {}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError({required this.message});
}

class DashboardLoaded extends DashboardState {
  final String restaurantId;
  final Map<String, dynamic> restaurantData;
  final int totalOrders;
  final double totalRevenue;
  final int activeReservations;
  final double averageRating;
  final List<ChartData> revenueData;
  final List<ChartData> orderCategories;

  const DashboardLoaded({
    required this.restaurantId,
    required this.restaurantData,
    required this.totalOrders,
    required this.totalRevenue,
    required this.activeReservations,
    required this.averageRating,
    required this.revenueData,
    required this.orderCategories,
  });
}
