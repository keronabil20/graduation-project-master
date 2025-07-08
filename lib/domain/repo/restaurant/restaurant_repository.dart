// Project imports:
import 'package:graduation_project/domain/entities/restaurant.dart';

abstract class RestaurantRepository {
  Future<List<Restaurant>> getAllRestaurants();
  Future<Restaurant?> getRestaurantById(String restaurantId);
  Future<List<Restaurant>> getRestaurantsByCuisine(String cuisineType);
  Future<List<Restaurant>> getRestaurantsByLocation(String location);
  Future<List<Restaurant>> getTopRatedRestaurants({int limit = 5});
  Future<List<Restaurant>> getNewRestaurants({int limit = 5});
  Future<List<Restaurant>> getRestaurantsByCategory(String category);
  Stream<List<Restaurant>> streamAllRestaurants();
  Stream<Restaurant?> streamRestaurantById(String restaurantId);
  Future<List<Restaurant>> searchRestaurantsByName(String query);
  Stream<List<Restaurant>> streamLikedRestaurants(String userId);
  Future<void> likeRestaurant(String userId, String restaurantId);
  Future<void> unlikeRestaurant(String userId, String restaurantId);
  Future<bool> isRestaurantLiked(String userId, String restaurantId);
  Future<List<Restaurant>> getLikedRestaurants(String userId);
}
