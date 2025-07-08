// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:graduation_project/generated/l10n.dart';
import 'package:graduation_project/presentation/User/personal_page/personal_page.dart';
import 'package:graduation_project/presentation/User/search_restaurant_by%20name.dart';
import 'package:graduation_project/presentation/User/userhome/home_page.dart';
import 'package:graduation_project/presentation/map/map.dart';
import 'package:graduation_project/utils/constants/constants.dart';

class HomePageNavigator extends StatefulWidget {
  const HomePageNavigator({super.key});

  @override
  State<HomePageNavigator> createState() => _HomePageNavigatorState();
}

class _HomePageNavigatorState extends State<HomePageNavigator> {
  var _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          HomePage(),
          const RestaurantSearchScreen(),
          MapScreen(),
          const PersonalPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
          );
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 24.sp),
            label: S.of(context).home, // Use localized string
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 24.sp),
            label: S.of(context).search, // Use localized string
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_rounded, size: 24.sp),
            label: S.of(context).map, // Use localized string
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 24.sp),
            label: S.of(context).person, // Use localized string
          ),
        ],
        selectedItemColor: deeporange,
        selectedLabelStyle: textTheme.bodySmall,
        unselectedLabelStyle: textTheme.bodySmall,
      ),
    );
  }
}
