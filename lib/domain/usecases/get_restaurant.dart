// Project imports:
import 'package:graduation_project/domain/entities/restaurant.dart';
import 'package:graduation_project/domain/repo/restaurant/restaurant_repository.dart';

class GetAllRestaurants {
  final RestaurantRepository repository;
  GetAllRestaurants(this.repository);

  Future<List<Restaurant>> call() {
    return repository.getAllRestaurants();
  }
}

class GetRestaurantById {
  final RestaurantRepository repository;
  GetRestaurantById(this.repository);

  Future<Restaurant?> call(String restaurantId) {
    return repository.getRestaurantById(restaurantId);
  }
}

class GetRestaurantsByCuisine {
  final RestaurantRepository repository;
  GetRestaurantsByCuisine(this.repository);

  Future<List<Restaurant>> call(String cuisineType) {
    return repository.getRestaurantsByCuisine(cuisineType);
  }
}

class GetRestaurantsByLocation {
  final RestaurantRepository repository;
  GetRestaurantsByLocation(this.repository);

  Future<List<Restaurant>> call(String location) {
    return repository.getRestaurantsByLocation(location);
  }
}

class GetTopRatedRestaurants {
  final RestaurantRepository repository;
  GetTopRatedRestaurants(this.repository);

  Future<List<Restaurant>> call({int limit = 5}) {
    return repository.getTopRatedRestaurants(limit: limit);
  }
}

class GetNewRestaurants {
  final RestaurantRepository repository;
  GetNewRestaurants(this.repository);

  Future<List<Restaurant>> call({int limit = 5}) {
    return repository.getNewRestaurants(limit: limit);
  }
}

class GetRestaurantsByCategory {
  final RestaurantRepository repository;
  GetRestaurantsByCategory(this.repository);

  Future<List<Restaurant>> call(String category) {
    return repository.getRestaurantsByCategory(category);
  }
}

class StreamAllRestaurants {
  final RestaurantRepository repository;
  StreamAllRestaurants(this.repository);

  Stream<List<Restaurant>> call() {
    return repository.streamAllRestaurants();
  }
}

class StreamRestaurantById {
  final RestaurantRepository repository;
  StreamRestaurantById(this.repository);

  Stream<Restaurant?> call(String restaurantId) {
    return repository.streamRestaurantById(restaurantId);
  }
}

class SearchRestaurantsByName {
  final RestaurantRepository repository;
  SearchRestaurantsByName(this.repository);

  Future<List<Restaurant>> call(String query) {
    return repository.searchRestaurantsByName(query);
  }
}
