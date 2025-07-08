// presentation/bloc/menu_item_form/menu_item_form_bloc.dart

// Dart imports:
import 'dart:async';

// Package imports:
import 'package:bloc/bloc.dart';

// Project imports:
import 'package:graduation_project/domain/entities/menu_item.dart';
import 'package:graduation_project/domain/repo/menu-item/menu_repository.dart';
import 'package:graduation_project/presentation/owner/Menu_creation.dart/bloc/menu_item_event.dart';
import 'package:graduation_project/presentation/owner/Menu_creation.dart/bloc/menu_item_state.dart';

class MenuItemFormBloc extends Bloc<MenuItemFormEvent, MenuItemFormState> {
  final MenuRepository menuRepository;
  final String restaurantId;
  final MenuItem? initialItem;

  MenuItemFormBloc({
    required this.menuRepository,
    required this.restaurantId,
    this.initialItem,
  }) : super(MenuItemFormInitial()) {
    on<SaveMenuItemEvent>(_onSaveItem);
  }

  Future<void> _onSaveItem(
    SaveMenuItemEvent event,
    Emitter<MenuItemFormState> emit,
  ) async {
    emit(MenuItemFormSaving());
    try {
      final menuItem = MenuItem(
        id: initialItem?.id ?? '',
        name: event.name,
        description: event.description,
        price: event.price,
        category: event.category,
        image: event.image,
        createdAt: initialItem?.createdAt ?? DateTime.now(),
      );

      if (initialItem == null) {
        await menuRepository.createMenuItem(menuItem, restaurantId);
      } else {
        await menuRepository.updateMenuItem(restaurantId, menuItem);
      }

      emit(MenuItemFormSaved());
    } catch (e) {
      emit(MenuItemFormError(message: 'Failed to save item: $e'));
    }
  }
}
