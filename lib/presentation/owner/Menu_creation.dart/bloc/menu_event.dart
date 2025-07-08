// presentation/bloc/menu/menu_event.dart
part of 'menu_bloc.dart';

@immutable
abstract class MenuEvent {}

class LoadMenuEvent extends MenuEvent {}

class DeleteMenuItemEvent extends MenuEvent {
  final String itemId;

  DeleteMenuItemEvent(this.itemId);
}

class RefreshMenuEvent extends MenuEvent {}
