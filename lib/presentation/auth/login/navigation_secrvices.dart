// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:graduation_project/presentation/owner/main_owner_page/owner_main_screen.dart';
import 'package:graduation_project/routes/routes.dart';

class NavigationService {
  static void navigateToUserHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.homenav,
      (route) => false,
    );
  }

  static void navigateToCreateRestaurant(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.createRestaurant,
      (route) => false,
    );
  }

  static void navigateToRestaurantHome(
      BuildContext context, String restaurantId) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => OwnerMainScreen(restaurantId: restaurantId),
        ),
        (route) => false);
  }
}
