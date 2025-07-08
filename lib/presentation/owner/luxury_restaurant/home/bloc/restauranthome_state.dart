part of 'restauranthome_bloc.dart';

abstract class RestaurantHomeState {
  const RestaurantHomeState();
}

class RestaurantHomeInitial extends RestaurantHomeState {
  const RestaurantHomeInitial();
}

class RestaurantHomeLoading extends RestaurantHomeState {
  const RestaurantHomeLoading();
}

class RestaurantHomeLoaded extends RestaurantHomeState {
  final Map<String, dynamic> restaurant;
  final List<MenuItem> menuItems;
  final List<EventModel> events;

  const RestaurantHomeLoaded({
    required this.restaurant,
    required this.menuItems,
    required this.events,
  });
}

class RestaurantHomeError extends RestaurantHomeState {
  final String message;

  const RestaurantHomeError({required this.message});
}
