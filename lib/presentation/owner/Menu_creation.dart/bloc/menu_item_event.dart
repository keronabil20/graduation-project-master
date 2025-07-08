// presentation/bloc/menu_item_form/menu_item_form_event.dart

// Flutter imports:
import 'package:flutter/material.dart';

@immutable
abstract class MenuItemFormEvent {}

class SaveMenuItemEvent extends MenuItemFormEvent {
  final String name;
  final String description;
  final double price;
  final String category;
  final String image;

  SaveMenuItemEvent({
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
  });
}
