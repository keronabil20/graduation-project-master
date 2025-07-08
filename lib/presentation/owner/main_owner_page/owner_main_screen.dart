// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get_it/get_it.dart';

// Project imports:
import 'package:graduation_project/domain/repo/user/user_repository.dart';
import 'package:graduation_project/presentation/User/search_restaurant_by%20name.dart';
import 'package:graduation_project/presentation/owner/Personal_page/personal_page_body.dart';
import 'package:graduation_project/presentation/owner/luxury_restaurant/home/restaurant_home_screen.dart';
import 'package:graduation_project/presentation/owner/main_owner_page/button_nav_bar.dart';
import 'package:graduation_project/presentation/owner/owner_dashboard/owner_dashboard_screen.dart';
import 'package:graduation_project/routes/routes.dart';
import 'package:graduation_project/utils/constants/constants.dart';

class OwnerMainScreen extends StatefulWidget {
  final String restaurantId;

  const OwnerMainScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  State<OwnerMainScreen> createState() => _OwnerMainScreenState();
}

class _OwnerMainScreenState extends State<OwnerMainScreen> {
  int _currentIndex = 0;
  late final List<Widget> _pages;
  bool _isInitialized = false;

  final String userId = GetIt.I<UserRepository>().getCurrentUserId() ?? '';

  @override
  void initState() {
    super.initState();
    _initializePages();
  }

  void _initializePages() {
    _pages = [
      RestaurantHomePage(restaurantId: widget.restaurantId),
      OwnerDashboardScreen(restaurantId: widget.restaurantId),
      RestaurantSearchScreen(),
      OwnerPersonalPage(
        ownerId: userId,
        restaurantId: widget.restaurantId,
      ),
    ];
    _isInitialized = true;
  }

  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: LuxuryBottomNav(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _buildCenterFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildCenterFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showFABMenu(context),
      shape: const CircleBorder(),
      backgroundColor: deeporange,
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }

  void _showFABMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.restaurant_menu, color: deeporange),
                  title: const Text('Add to Menu'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      AppRoutes.createMenuItem,
                      arguments: widget.restaurantId,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.store, color: deeporange),
                  title: const Text('Add Restaurant'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.createRestaurant);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.post_add, color: deeporange),
                  title: const Text('Add Post'),
                  onTap: () async {
                    final user =
                        await GetIt.I<UserRepository>().getUser(userId);
                    if (!mounted) return;
                    Navigator.pop(context);

                    Navigator.pushNamed(
                      context,
                      AppRoutes.uploadPost,
                      arguments: {
                        'restaurantId': widget.restaurantId,
                        'userId': userId,
                        'username': user.name ?? 'Unknown User',
                      },
                    );
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
