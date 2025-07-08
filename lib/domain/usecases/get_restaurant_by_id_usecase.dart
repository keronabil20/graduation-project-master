// Project imports:
import '../entities/restaurant.dart';
import '../repo/restaurant/restaurant_repository.dart';

class GetRestaurantByIdUseCase {
  final RestaurantRepository repository;
  GetRestaurantByIdUseCase(this.repository);

  Future<Restaurant?> call(String id) {
    return repository.getRestaurantById(id);
  }
}
