// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  DashboardCubit({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore,
        super(DashboardInitial());

  Future<void> loadDashboardData(String restaurantId) async {
    emit(DashboardLoading());

    try {
      final restaurantDoc =
          await _firestore.collection('restaurants').doc(restaurantId).get();

      if (!restaurantDoc.exists) {
        emit(DashboardNoRestaurant());
        return;
      }

      final restaurantData = restaurantDoc.data()!;

      // Load statistics and analytics
      final stats = await _loadStatistics(restaurantId);
      final analytics = await _loadAnalyticsData(restaurantId);

      emit(DashboardLoaded(
        restaurantId: restaurantId,
        restaurantData: restaurantData,
        totalOrders: stats['totalOrders'],
        totalRevenue: stats['totalRevenue'],
        activeReservations: stats['activeReservations'],
        averageRating: stats['averageRating'],
        revenueData: analytics['revenueData'],
        orderCategories: analytics['orderCategories'],
      ));
    } catch (e) {
      emit(DashboardError(message: 'Failed to load dashboard data: $e'));
    }
  }

  Future<Map<String, dynamic>> _loadStatistics(String restaurantId) async {
    // Implement actual data fetching from Firestore
    return {
      'totalOrders': 150,
      'totalRevenue': 8542.50,
      'activeReservations': 23,
      'averageRating': 4.5,
    };
  }

  Future<Map<String, dynamic>> _loadAnalyticsData(String restaurantId) async {
    // Implement actual data fetching from Firestore
    return {
      'revenueData': [
        ChartData('Mon', 1200),
        ChartData('Tue', 2500),
        ChartData('Wed', 1800),
        ChartData('Thu', 3200),
        ChartData('Fri', 4100),
        ChartData('Sat', 5800),
        ChartData('Sun', 3900),
      ],
      'orderCategories': [
        ChartData('Dine-in', 45),
        ChartData('Takeaway', 30),
        ChartData('Delivery', 25),
      ],
    };
  }

  Future<void> updateRestaurantInfo(Map<String, dynamic> updatedData) async {
    if (state is! DashboardLoaded) return;

    final currentState = state as DashboardLoaded;

    try {
      emit(DashboardLoading());
      await _firestore
          .collection('restaurants')
          .doc(currentState.restaurantId)
          .update(updatedData);

      // Reload data after update
      await loadDashboardData(currentState.restaurantId);
    } catch (e) {
      emit(DashboardError(message: 'Failed to update restaurant info: $e'));
      emit(currentState); // Revert to previous state
    }
  }
}
