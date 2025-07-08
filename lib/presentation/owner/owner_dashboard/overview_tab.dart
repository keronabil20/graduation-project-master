// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// Project imports:
import 'package:graduation_project/data/order_model.dart';
import 'package:graduation_project/domain/entities/order.dart';
import 'package:graduation_project/domain/repo/order/order_repository.dart';
import 'package:graduation_project/domain/usecases/order_usecases.dart';
import 'package:graduation_project/presentation/owner/owner_dashboard/cubit/dashboard_cubit.dart';
import 'package:graduation_project/service_locator.dart';

class OverviewTab extends StatelessWidget {
  final DashboardLoaded state;
  final String restaurantId;

  const OverviewTab(
      {super.key, required this.state, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildQuickStatsRow(context),
          SizedBox(height: 24.h),
          _buildRevenueChart(),
          SizedBox(height: 24.h),
          _buildRecentActivity(context), // Pass context if needed
        ],
      ),
    );
  }

  Widget _buildQuickStatsRow(BuildContext context) {
    final getOrdersTotalSum = getIt<GetOrdersTotalSum>(); // Use getIt directly
    return FutureBuilder<double>(
        future: getOrdersTotalSum(restaurantId),
        builder: (context, snapshot) {
          final totalSum = snapshot.data ?? 0;

          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            children: [
              _buildStatCard(
                title: 'Total Orders',
                value: state.totalOrders,
                icon: Icons.shopping_basket,
                color: Colors.blue,
              ),
              _buildStatCard(
                title: 'Total Revenue',
                value: totalSum,
                icon: Icons.money,
                color: Colors.green,
                isCurrency: true,
              ),
              _buildStatCard(
                title: 'Reservations',
                value: state.activeReservations,
                icon: Icons.book_online,
                color: Colors.orange,
              ),
              _buildStatCard(
                title: 'Avg Rating',
                value: state.averageRating,
                icon: Icons.star,
                color: Colors.amber,
              ),
            ],
          );
        });
  }

  Widget _buildStatCard({
    required String title,
    required dynamic value,
    required IconData icon,
    required Color color,
    bool isCurrency = false,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.w)),
      elevation: 5,
      child: Container(
        height: 160.h,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.w),
          color: color.withOpacity(0.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24.w, color: color),
            SizedBox(height: 4.h),
            Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              value.toString(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart() {
    final getOrdersTotalSum = getIt<GetOrdersTotalSum>(); // Use getIt directly

    return FutureBuilder<double>(
      future: getOrdersTotalSum(restaurantId),
      builder: (context, snapshot) {
        final totalSum = snapshot.data ?? 0;

        return Card(
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: <CartesianSeries<ChartData, String>>[
              ColumnSeries<ChartData, String>(
                dataSource: [
                  ChartData('Total', totalSum),
                ],
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  labelAlignment: ChartDataLabelAlignment.top,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
            title: ChartTitle(
                text: 'Total Revenue: \$${totalSum.toStringAsFixed(2)}'),
          ),
        );
      },
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.w)),
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Recent Orders',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
              ],
            ),
            SizedBox(height: 12.h),
            _buildRecentOrdersList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOrdersList() {
    return FutureBuilder<List<OrderModel>>(
      future: GetIt.I.call<OrderRepository>().getOrders(restaurantId).first,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              children: [
                Text('Failed to load orders',
                    style: TextStyle(fontSize: 12.sp)),
                SizedBox(height: 8.h),
                ElevatedButton(
                  onPressed: () => _buildRecentOrdersList(),
                  child: Text('Retry', style: TextStyle(fontSize: 12.sp)),
                ),
              ],
            ),
          );
        }
        final orders = snapshot.data ?? [];
        if (orders.isEmpty) {
          return Center(
            child: Text(
              'No recent orders',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
          );
        }
        return Column(
          children: orders.map(_buildOrderTile).toList(),
        );
      },
    );
  }

  Widget _buildOrderTile(Order order) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: ListTile(
        leading: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: _getStatusColor(order.status).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getStatusIcon(order.status),
            color: _getStatusColor(order.status),
            size: 20.w,
          ),
        ),
        title: Text(
          order.items.first.name,
          style: TextStyle(fontSize: 12.sp),
        ),
        subtitle: Text(
          '${DateFormat('MMM dd, hh:mm a').format(order.createdAt)} • ${order.status.capitalize()}',
          style: TextStyle(fontSize: 12.sp),
        ),
        trailing: Text(
          order.total.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.green[700],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'pending':
        return Icons.pending;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.receipt;
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
