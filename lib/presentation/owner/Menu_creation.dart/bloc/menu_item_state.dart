// presentation/bloc/menu_item_form/menu_item_form_state.dart

// Flutter imports:
import 'package:flutter/widgets.dart';

@immutable
abstract class MenuItemFormState {}

class MenuItemFormInitial extends MenuItemFormState {}

class MenuItemFormSaving extends MenuItemFormState {}

class MenuItemFormSaved extends MenuItemFormState {}

class MenuItemFormError extends MenuItemFormState {
  final String message;

  MenuItemFormError({required this.message});
}
