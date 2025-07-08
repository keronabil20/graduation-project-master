// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:graduation_project/domain/entities/menu_item.dart';
import 'package:graduation_project/presentation/owner/Menu_creation.dart/bloc/menu_bloc.dart';
import 'package:graduation_project/presentation/owner/Menu_creation.dart/bloc/menu_item_bloc.dart';
import 'package:graduation_project/presentation/owner/Menu_creation.dart/menu_item_form.dart';
import 'package:graduation_project/presentation/owner/luxury_restaurant/home/restaurant_home_screen.dart';
import 'package:graduation_project/service_locator.dart';

class MenuCreationScreen extends StatelessWidget {
  final String restaurantId;

  const MenuCreationScreen({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<MenuBloc>(param1: restaurantId)..add(LoadMenuEvent()),
      child: const _MenuCreationView(),
    );
  }
}

class _MenuCreationView extends StatefulWidget {
  const _MenuCreationView();

  @override
  State<_MenuCreationView> createState() => __MenuCreationViewState();
}

class __MenuCreationViewState extends State<_MenuCreationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<MenuBloc, MenuState>(
              listener: (context, state) {
                if (state is MenuError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is MenuLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is MenuError) {
                  return Center(child: Text(state.message));
                }

                if (state is MenuLoaded) {
                  return ListView.builder(
                    itemCount: state.menuItems.length,
                    itemBuilder: (context, index) {
                      final item = state.menuItems[index];
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text('\$${item.price}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _navigateToMenuItemForm(
                                context,
                                item: item,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => context.read<MenuBloc>().add(
                                    DeleteMenuItemEvent(item.id),
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }

                return const Center(child: Text('No data available'));
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0.sp),
            child: ElevatedButton(
              onPressed: () => RestaurantHomePage(
                restaurantId: context.read<MenuBloc>().restaurantId,
              ),
              child: const Text('Skip to Restaurant Home'),
            ),
          ),
        ],
      ),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () => _navigateToMenuItemForm(context),
      ),
    );
  }

  void _navigateToMenuItemForm(BuildContext context, {MenuItem? item}) {
    final restaurantId = context.read<MenuBloc>().restaurantId;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => getIt<MenuItemFormBloc>(
            param1: restaurantId,
            param2: item,
          ),
          child: MenuItemFormScreen(menuItem: item),
        ),
      ),
    ).then((result) {
      if (result == true) {
        context.read<MenuBloc>().add(RefreshMenuEvent());
      }
    });
  }
}
