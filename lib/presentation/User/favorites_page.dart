// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

// Project imports:
import 'package:graduation_project/domain/entities/restaurant.dart';
import 'package:graduation_project/domain/repo/restaurant/restaurant_repository.dart';
import 'package:graduation_project/generated/l10n.dart';
import 'package:graduation_project/utils/widgets/custome_widgets/resturantcard.dart';
import 'package:graduation_project/utils/widgets/shimmer_loader.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        body: Center(child: Text(S.of(context).viewfavorites)),
      );
    }

    final userId = user.uid;
    final restaurantRepository = GetIt.I<RestaurantRepository>();

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/barlogo.png',
          height: 40,
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: StreamBuilder<List<Restaurant>>(
          stream: restaurantRepository.streamLikedRestaurants(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: ShimmerLoader());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text(S.of(context).nofavorites));
            }

            final restaurants = snapshot.data!;

            return ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: 12.0.h,
                      left: 20.w), // Add space between each card
                  child: Center(
                    child: RestaurantCard(
                      restaurant: restaurant,
                      auth: FirebaseAuth.instance,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
