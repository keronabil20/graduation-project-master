// Flutter imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:graduation_project/domain/repo/post/post_repository.dart';
import 'package:graduation_project/presentation/User/favorites_page.dart';
import 'package:graduation_project/presentation/User/home_pagecontroller.dart';
import 'package:graduation_project/presentation/User/personal_page/personal_page.dart';
import 'package:graduation_project/presentation/auth/AuthWrapperScreen.dart';
import 'package:graduation_project/presentation/auth/forget_password/forget_pass_screen.dart';
import 'package:graduation_project/presentation/auth/login/login_screen.dart';
import 'package:graduation_project/presentation/auth/sign_up/sign_up_screen.dart';
import 'package:graduation_project/presentation/gemini_chat/chat_prompt.dart';
import 'package:graduation_project/presentation/map/map.dart';
import 'package:graduation_project/presentation/owner/Menu_creation.dart/menu_creation_screen.dart';
import 'package:graduation_project/presentation/owner/luxury_restaurant/components/menu_grid.dart';
import 'package:graduation_project/presentation/owner/luxury_restaurant/home/restaurant_home_screen.dart';
import 'package:graduation_project/presentation/owner/main_owner_page/owner_main_screen.dart';
import 'package:graduation_project/presentation/owner/order_robot/choose_tablet_screen.dart';
import 'package:graduation_project/presentation/owner/order_robot/thanking_scree.dart';
import 'package:graduation_project/presentation/owner/restaurant_creation_screen.dart';
import 'package:graduation_project/presentation/posts/upload_post.dart';
import 'package:graduation_project/presentation/splash_screen&onboarding/onboarding_screen_controller.dart';
import 'package:graduation_project/presentation/splash_screen&onboarding/splash_redirector.dart';
import 'package:graduation_project/service_locator.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String homenav = '/home';
  static const String map = '/map';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String authWrapper = '/auth-wrapper';
  static const String createRestaurant = '/owner/create-restaurant';
  static const String restaurantHome = '/owner/restaurant-home';
  static const String forgetPassword = '/forgetpassword';
  static const String ownerMainScreen = '/owner/main-screen';
  static const String favoritesPage = '/favorites-page';
  static const String menuList = '/common/menu-list';
  static const String postDetail = '/postDetail';
  static const String uploadPost = '/upload-post';
  static const String menuGrid = '/owner/menu-grid';
  static const String createMenuItem = '/owner/create-menu-item';
  static const String chooseTablet = '/owner/chooseTablet';
  static const String thanking = '/owner/thanking';
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashRedirector());
      case onboarding:
        return MaterialPageRoute(
            builder: (_) => const OnboardingScreenController());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginContent());
      case forgetPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupContent());
      case homenav:
        return MaterialPageRoute(builder: (_) => const HomePageNavigator());
      case map:
        return MaterialPageRoute(builder: (_) => MapScreen());
      case chat:
        return MaterialPageRoute(builder: (_) => const ChatPage());
      case profile:
        return MaterialPageRoute(builder: (_) => const PersonalPage());
      case authWrapper:
        return MaterialPageRoute(builder: (_) => const AuthWrapperScreen());
      case favoritesPage:
        return MaterialPageRoute(builder: (_) => const FavoritesPage());
      case createRestaurant:
        return MaterialPageRoute(
            builder: (_) => const RestaurantCreationScreen());
      case thanking:
        return MaterialPageRoute(
            builder: (_) => ThankYouScreen(
                  restaurantId: settings.arguments as String ?? '',
                )); // Assuming ThankingScreen exists
      case restaurantHome:
        return MaterialPageRoute(
          builder: (_) => RestaurantHomePage(
            restaurantId: settings.arguments as String ?? '',
          ),
        );
      case ownerMainScreen:
        return MaterialPageRoute(
          builder: (_) => OwnerMainScreen(
            restaurantId: settings.arguments as String ?? '',
          ),
        );
      case createMenuItem:
        return MaterialPageRoute(
          builder: (_) => MenuCreationScreen(
            restaurantId: settings.arguments as String, // Direct cast to String
          ),
        );
      case menuGrid:
        return MaterialPageRoute(
          builder: (_) => MenuGrid(
            restaurantId:
                settings.arguments as String ?? '', // Direct cast to String
          ),
        );
      case chooseTablet:
        return MaterialPageRoute(
          builder: (_) => ChooseTableScreen(
            restaurantId: settings.arguments as String ?? '',
          ),
        );
      case uploadPost:
        final args = settings.arguments as Map<String, dynamic>?;

        if (args == null ||
            !args.containsKey('restaurantId') ||
            !args.containsKey('userId') ||
            !args.containsKey('username')) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text('Missing required arguments for upload post'),
              ),
            ),
          );
        }

        final postRepository = getIt<PostRepository>();
        return MaterialPageRoute(
          builder: (_) => UploadPostScreen(
            restaurantId: args['restaurantId'] as String,
            userId: args['userId'] as String,
            username: args['username'] as String,
            postRepository: postRepository,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
