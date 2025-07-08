// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

// Project imports:
import 'package:graduation_project/domain/repo/restaurant/restaurant_repository.dart';
import 'package:graduation_project/generated/l10n.dart';
import 'package:graduation_project/presentation/User/userhome/components/build_category_list.dart';
import 'package:graduation_project/presentation/User/userhome/components/build_feature_view.dart';
import 'package:graduation_project/utils/constants/constants.dart';

import 'package:graduation_project/presentation/posts/post_List_screen.dart'; // Import PostsListScreen
import 'package:graduation_project/presentation/gemini_chat/chat_prompt.dart'; // Import ChatPage

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final RestaurantRepository restaurantRepository =
      GetIt.I<RestaurantRepository>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Image.asset('assets/images/barlogo.png'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Luxury Carousel
            _buildLuxuryCarousel(context),

            // Categories Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Text(
                S.of(context).categories,
                style: textTheme.bodyLarge,
              ),
            ),
            buildCategoryList(context),

            // Featured Restaurants
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Text(
                S.of(context).premiumDining,
                style: textTheme.bodyLarge,
              ),
            ),
            BuildFeatureRestaurants(),

            // Posts Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Text(
                'Posts',
                style: textTheme.bodyLarge,
              ),
            ),
            _buildPostsSection(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: SizedBox(
                width: 300.w,
                height: 400.h,
                child: Column(
                  children: [
                    AppBar(
                      automaticallyImplyLeading: false,
                      title: const Text('Chat Bot'),
                      backgroundColor: deeporange,
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    Expanded(
                      child:
                          ChatPage(), // Embed ChatPage in the floating screen
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        backgroundColor: deeporange,
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }

  Widget _buildLuxuryCarousel(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 180.h,
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          viewportFraction: 0.85,
        ),
        items: [
          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
          'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1374&q=80',
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1480&q=80',
        ].map((imageUrl) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8.r,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.2),
                    colorBlendMode: BlendMode.darken,
                  ),
                  Positioned(
                    bottom: 16.h,
                    left: 16.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).premiumExperience,
                          style: textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          S.of(context).bookYourTable,
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPostsSection(BuildContext context) {
    return SizedBox(
      height: 400.h, // Adjust height as needed
      child: PostsListScreen(), // Display posts using PostsListScreen
    );
  }
}
