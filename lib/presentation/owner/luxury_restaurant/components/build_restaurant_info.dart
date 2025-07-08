// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantInfo extends StatelessWidget {
  final Map<String, dynamic> restaurant;

  const RestaurantInfo({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            restaurant['name'] ?? 'Restaurant',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (restaurant['slogan'] != null &&
              restaurant['slogan'].toString().isNotEmpty) ...[
            SizedBox(height: 6.h),
            Text(
              restaurant['slogan'],
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
          SizedBox(height: 8.h),
          Text(
            restaurant['description'] ?? 'Fine dining experience',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 16.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Icon(Icons.location_on, size: 16.sp, color: Colors.grey[400]),
                SizedBox(width: 4.w),
                Text(
                  restaurant['address'] ?? 'Unknown location',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[400],
                  ),
                ),
                SizedBox(width: 16.w),
                Icon(Icons.star, size: 16.sp, color: Colors.amber),
                SizedBox(width: 4.w),
                Text(
                  '${restaurant['rating'] ?? '0.0'} (${restaurant['reviewCount'] ?? '0'} reviews)',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[400],
                  ),
                ),
                SizedBox(width: 16.w),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Icon(Icons.restaurant_menu,
                  size: 18.sp, color: theme.colorScheme.primary),
              SizedBox(width: 6.w),
              Text(
                restaurant['cuisineType'] ?? 'Cuisine',
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(Icons.phone, size: 18.sp, color: theme.colorScheme.primary),
              SizedBox(width: 6.w),
              Text(
                restaurant['phone'] ?? 'No phone',
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(Icons.verified,
                  size: 18.sp, color: theme.colorScheme.primary),
              SizedBox(width: 6.w),
              Text(
                'Status: ${restaurant['status'] ?? 'Unknown'}',
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(Icons.work, size: 18.sp, color: theme.colorScheme.primary),
              SizedBox(width: 6.w),
              Text(
                'Experience: ${restaurant['experienceYears'] ?? '0'} years',
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.schedule,
                  size: 18.sp, color: theme.colorScheme.primary),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  'Opening Hours: ${restaurant['openingHours'] ?? 'N/A'}',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
