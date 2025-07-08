// presentation/bloc/menu/menu_state.dart
part of 'menu_bloc.dart';

@immutable
abstract class MenuState {}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final List<MenuItem> menuItems;

  MenuLoaded({required this.menuItems});
}

class MenuError extends MenuState {
  final String message;

  MenuError({required this.message});
}
