// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

// Project imports:
import 'package:graduation_project/domain/entities/restaurant.dart';
import 'package:graduation_project/domain/repo/restaurant/restaurant_repository.dart';
import 'package:graduation_project/presentation/map/map.dart';
import 'package:graduation_project/routes/routes.dart';
import 'package:graduation_project/utils/image_utils.dart';
import 'package:graduation_project/utils/widgets/custome_widgets/like_button.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    super.key,
    required this.restaurant,
    required FirebaseAuth auth,
  }) : _auth = auth;

  final Restaurant restaurant;
  final FirebaseAuth _auth;

  @override
  Widget build(BuildContext context) {
    final restaurantRepository = GetIt.I<RestaurantRepository>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 280.w,
        margin: EdgeInsets.only(right: 16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.r,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.restaurantHome,
                    arguments: restaurant.id,
                  );
                },
                child: Stack(
                  children: [
                    ImageUtils.imageFromBase64String(
                      restaurant.images.isNotEmpty
                          ? restaurant.images.first
                          : 'https://via.placeholder.com/300x200?text=Restaurant',
                      height: 140.h,
                      width: double.infinity,
                    ),
                    Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: LikeButton(
                          restaurantId: restaurant.id,
                          userId: _auth.currentUser?.uid ??
                              '', // Get the current user's ID
                          repository: restaurantRepository,
                        )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    restaurant.cuisineType,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                MapScreen(latlongget: restaurant.geoLocation),
                          ));
                    },
                    child: Row(
                      children: [
                        Icon(Icons.location_on,
                            color: Colors.grey, size: 14.sp),
                        SizedBox(width: 4.w),
                        Text(restaurant.address,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            )),
                        Spacer(),

                        // In your restaurant card widget
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
