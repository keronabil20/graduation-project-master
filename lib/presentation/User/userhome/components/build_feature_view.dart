// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

// Project imports:
import 'package:graduation_project/domain/entities/restaurant.dart';
import 'package:graduation_project/domain/repo/restaurant/restaurant_repository.dart';
import 'package:graduation_project/utils/widgets/custome_widgets/resturantcard.dart';
import 'package:graduation_project/utils/widgets/shimmer_loader.dart';

class BuildFeatureRestaurants extends StatefulWidget {
  const BuildFeatureRestaurants({
    super.key,
  });

  @override
  State<BuildFeatureRestaurants> createState() =>
      _BuildFeatureRestaurantsState();
}

class _BuildFeatureRestaurantsState extends State<BuildFeatureRestaurants> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RestaurantRepository restaurantRepository =
      GetIt.I<RestaurantRepository>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Restaurant>>(
      future: restaurantRepository.getTopRatedRestaurants(limit: 5),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 250.h,
            child: Center(child: ShimmerLoader()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox(
            height: 250.h,
            child: Center(child: Text('No restaurants found')),
          );
        }

        final restaurants = snapshot.data!;

        return SizedBox(
          height: 270.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return RestaurantCard(restaurant: restaurant, auth: _auth);
            },
          ),
        );
      },
    );
  }
}
