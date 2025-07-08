// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:graduation_project/presentation/User/userhome/restaurant_search_result_page.dart';
import 'package:graduation_project/utils/constants/constants.dart';

Widget buildCategoryList(BuildContext context) {
  final categories = [
    {'icon': Icons.local_pizza, 'name': 'Italian', 'cuisineType': 'italian'},
    {'icon': Icons.ramen_dining, 'name': 'Asian', 'cuisineType': 'asian'},
    {'icon': Icons.emoji_food_beverage, 'name': 'Cafe', 'cuisineType': 'cafe'},
    {
      'icon': Icons.dinner_dining,
      'name': 'Fine Dining',
      'cuisineType': 'fine_dining'
    },
    {
      'icon': Icons.travel_explore,
      'name': 'Egyptian',
      'cuisineType': 'Egyptian'
    },
  ];

  return SizedBox(
    height: 100.h,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Navigate to search results page with the selected cuisine type
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RestaurantSearchResultsPage(
                  cuisineType: categories[index]['cuisineType'] as String,
                  categoryName: categories[index]['name'] as String,
                ),
              ),
            );
          },
          child: Container(
            width: 80.w,
            margin: EdgeInsets.only(right: 12.w),
            child: Column(
              children: [
                Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8.r,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Icon(
                    categories[index]['icon'] as IconData,
                    size: 28.sp,
                    color: deeporange,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  categories[index]['name'] as String,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
