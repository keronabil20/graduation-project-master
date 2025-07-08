// Dart imports:
import 'dart:async';

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

class RestaurantSearchScreen extends StatefulWidget {
  const RestaurantSearchScreen({super.key});

  @override
  State<RestaurantSearchScreen> createState() => _RestaurantSearchScreenState();
}

class _RestaurantSearchScreenState extends State<RestaurantSearchScreen> {
  final RestaurantRepository _restaurantRepository =
      GetIt.I<RestaurantRepository>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController();
  List<Restaurant> _searchResults = [];
  bool _isSearching = false;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });
        return;
      }

      setState(() => _isSearching = true);

      final results =
          await _restaurantRepository.searchRestaurantsByName(query);

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    });
  }

  Widget buildSearchField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => _performSearch(value),
        decoration: InputDecoration(
          hintText: S.of(context).searchForRestaurants,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: Colors.grey, width: 1.w),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              _performSearch('');
            },
          ),
        ),
      ),
    );
  }

  Widget buildSearchResults() {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchController.text.isEmpty) {
      return Center(
        child: Text(
          S.of(context).searchForRestaurants,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Text(
          S.of(context).noResultsFound,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final restaurant = _searchResults[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: RestaurantCard(
            restaurant: restaurant,
            auth: _auth,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Image.asset('assets/images/barlogo.png'),
        ),
        body: Column(
          children: [
            buildSearchField(),
            Expanded(
              child: buildSearchResults(),
            )
          ],
        ));
  }
}
