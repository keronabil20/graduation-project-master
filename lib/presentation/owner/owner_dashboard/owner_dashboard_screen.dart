// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:graduation_project/presentation/owner/owner_dashboard/analytics_tab.dart';
import 'package:graduation_project/presentation/owner/owner_dashboard/cubit/dashboard_cubit.dart';
import 'package:graduation_project/presentation/owner/owner_dashboard/management_tab.dart';
import 'package:graduation_project/presentation/owner/owner_dashboard/overview_tab.dart';
import 'package:graduation_project/utils/constants/constants.dart';
import 'package:graduation_project/utils/widgets/shimmer_loader.dart';

class OwnerDashboardScreen extends StatelessWidget {
  final String restaurantId;

  const OwnerDashboardScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit(
        auth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
      )..loadDashboardData(restaurantId),
      child: Scaffold(
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardInitial || state is DashboardLoading) {
              return const ShimmerLoader();
            }

            if (state is DashboardError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(color: Colors.red, fontSize: 14.sp),
                ),
              );
            }

            if (state is DashboardLoaded) {
              final restaurantName = state.restaurantData['name'] ?? '';

              return DefaultTabController(
                animationDuration: const Duration(milliseconds: 500),
                length: 3,
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(
                      restaurantName,
                      style: TextStyle(fontSize: 16.sp, color: white),
                    ),
                    bottom: TabBar(
                      labelColor: white,
                      indicatorColor: white,
                      labelStyle: TextStyle(fontSize: 10.sp),
                      tabs: const [
                        Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
                        Tab(icon: Icon(Icons.tune), text: 'Manage'),
                        Tab(icon: Icon(Icons.insights), text: 'Analytics'),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      OverviewTab(
                        state: state,
                        restaurantId: restaurantId,
                      ),
                      ManagementTab(state: state),
                      AnalyticsTab(state: state),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
