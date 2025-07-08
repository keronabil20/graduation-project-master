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

class RestaurantSearchResultsPage extends StatefulWidget {
  final String cuisineType;
  final String categoryName;

  const RestaurantSearchResultsPage({
    super.key,
    required this.cuisineType,
    required this.categoryName,
  });

  @override
  _RestaurantSearchResultsPageState createState() =>
      _RestaurantSearchResultsPageState();
}

class _RestaurantSearchResultsPageState
    extends State<RestaurantSearchResultsPage> {
  late Future<List<Restaurant>> _restaurantsFuture;
  FirebaseAuth auth = FirebaseAuth.instance;
  final RestaurantRepository _restaurantRepository =
      GetIt.I<RestaurantRepository>();

  @override
  void initState() {
    super.initState();
    _restaurantsFuture =
        _restaurantRepository.getRestaurantsByCuisine(widget.cuisineType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryName} Restaurants'),
      ),
      body: FutureBuilder<List<Restaurant>>(
        future: _restaurantsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: ShimmerLoader());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading restaurants'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No restaurants found'));
          }

          final restaurants = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.only(bottom: 12.0.h, left: 20.w),
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return RestaurantCard(
                restaurant: restaurant,
                auth: auth,
              );
            },
          );
        },
      ),
    );
  }
}
