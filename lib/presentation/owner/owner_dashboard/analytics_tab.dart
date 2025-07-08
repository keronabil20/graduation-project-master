// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// Project imports:
import 'package:graduation_project/presentation/owner/owner_dashboard/cubit/dashboard_cubit.dart';

class AnalyticsTab extends StatelessWidget {
  final DashboardLoaded state;

  const AnalyticsTab({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.w)),
            elevation: 5,
            child: Container(
              padding: EdgeInsets.all(16.w),
              height: 250.h,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(),
                series: <CartesianSeries<ChartData, String>>[
                  ColumnSeries<ChartData, String>(
                    dataSource: state.revenueData,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.w)),
            elevation: 5,
            child: Container(
              padding: EdgeInsets.all(16.w),
              height: 250.h,
              child: SfCircularChart(
                series: <CircularSeries>[
                  PieSeries<ChartData, String>(
                    dataSource: state.orderCategories,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
