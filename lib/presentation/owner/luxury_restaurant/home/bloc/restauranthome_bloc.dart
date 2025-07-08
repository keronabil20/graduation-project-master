// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

// Project imports:
import 'package:graduation_project/domain/entities/event_model.dart';
import 'package:graduation_project/domain/entities/menu_item.dart';
import 'package:graduation_project/domain/repo/menu-item/menu_repository.dart';
import 'package:graduation_project/domain/repo/restaurant/restaurant_repository.dart';

part 'restauranthome_event.dart';
part 'restauranthome_state.dart';

class RestaurantHomeBloc
    extends Bloc<RestaurantHomeEvent, RestaurantHomeState> {
  final RestaurantRepository _restaurantRepository =
      GetIt.I<RestaurantRepository>();
  final MenuRepository _menuRepository;
  final String restaurantId;

  RestaurantHomeBloc({
    required this.restaurantId,
    required MenuRepository menuRepository,
  })  : _menuRepository = menuRepository,
        super(RestaurantHomeInitial()) {
    on<LoadRestaurantHomeData>(_onLoadRestaurantHomeData);
  }

  Future<void> _onLoadRestaurantHomeData(
    LoadRestaurantHomeData event,
    Emitter<RestaurantHomeState> emit,
  ) async {
    emit(RestaurantHomeLoading());
    try {
      final restaurant =
          await _restaurantRepository.getRestaurantById(restaurantId);
      final menuItems = await _menuRepository.getMenuItems(restaurantId);

      if (restaurant == null) {
        emit(RestaurantHomeError(message: 'Restaurant not found'));
        return;
      }

      emit(RestaurantHomeLoaded(
        restaurant: {
          'id': restaurant.id,
          'name': restaurant.name,
          'description': restaurant.description,
          'slogan': restaurant.slogan,
          'cuisineType': restaurant.cuisineType,
          'address': restaurant.address,
          'categories': restaurant.categories,
          'coverUrl': restaurant.coverUrl,
          'logoUrl': restaurant.logoUrl,
          'images': restaurant.images,
          'phone': restaurant.phone,
          'status': restaurant.status,
          'rating': restaurant.rating,
          'reviewCount': restaurant.reviewCount,
          'experienceYears': restaurant.experienceYears,
          'ownerId': restaurant.ownerId,
          'createdAt': restaurant.createdAt.toIso8601String(),
          'hours': restaurant.hours,
          'openingHours': restaurant.openingHours,
        },
        menuItems: menuItems,
        events: const [], // TODO: Implement events if needed
      ));
    } catch (e) {
      emit(RestaurantHomeError(message: e.toString()));
    }
  }
}
