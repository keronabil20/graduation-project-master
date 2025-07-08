// presentation/bloc/menu/menu_bloc.dart

// Dart imports:
import 'dart:async';

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:graduation_project/domain/entities/menu_item.dart';
import 'package:graduation_project/domain/repo/menu-item/menu_repository.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository menuRepository;
  final String restaurantId;

  MenuBloc({
    required this.menuRepository,
    required this.restaurantId,
  }) : super(MenuInitial()) {
    on<LoadMenuEvent>(_onLoadMenu);
    on<DeleteMenuItemEvent>(_onDeleteItem);
    on<RefreshMenuEvent>(_onRefreshMenu);
  }

  Future<void> _onLoadMenu(
    LoadMenuEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
      final menuItems = await menuRepository.getMenuItems(restaurantId);
      emit(MenuLoaded(menuItems: menuItems));
    } catch (e) {
      emit(MenuError(message: 'Failed to load menu: $e'));
    }
  }

  Future<void> _onDeleteItem(
    DeleteMenuItemEvent event,
    Emitter<MenuState> emit,
  ) async {
    if (state is MenuLoaded) {
      final currentState = state as MenuLoaded;
      final updatedItems = [...currentState.menuItems];
      updatedItems.removeWhere((item) => item.id == event.itemId);

      emit(MenuLoaded(menuItems: updatedItems));

      try {
        await menuRepository.deleteMenuItem(restaurantId, event.itemId);
      } catch (e) {
        emit(MenuError(message: 'Failed to delete item: $e'));
        emit(MenuLoaded(menuItems: currentState.menuItems));
      }
    }
  }

  Future<void> _onRefreshMenu(
    RefreshMenuEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
      final menuItems = await menuRepository.getMenuItems(restaurantId);
      emit(MenuLoaded(menuItems: menuItems));
    } catch (e) {
      emit(MenuError(message: 'Failed to refresh menu: $e'));
    }
  }
}
