// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

// Project imports:
import 'package:graduation_project/domain/entities/menu_item.dart';
import 'package:graduation_project/domain/repo/menu-item/menu_repository.dart';
import 'package:graduation_project/presentation/menu_item/menu_item_detaild_screen.dart';
import 'package:graduation_project/utils/image_utils.dart';

class MenuGrid extends StatefulWidget {
  final String restaurantId;
  const MenuGrid({
    super.key,
    required this.restaurantId,
  });

  @override
  State<MenuGrid> createState() => _MenuGridState();
}

class _MenuGridState extends State<MenuGrid> {
  final _menuRepo = GetIt.I<MenuRepository>();
  List<MenuItem> _menuItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMenuItems();
  }

  Future<void> _loadMenuItems() async {
    try {
      final items = await _menuRepo.getMenuItems(widget.restaurantId);
      if (mounted) {
        setState(() {
          _menuItems = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading menu items: $e')),
        );
      }
    }
  }

  void _navigateToMenuItemDetail(BuildContext context, MenuItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MenuItemDetailsScreen(
          item: item,
          restaurantId: widget.restaurantId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_menuItems.isEmpty) {
      return Center(
        child: Text(
          'No menu items available',
          style: theme.textTheme.bodyLarge,
        ),
      );
    }

    return SingleChildScrollView(
      child: Container(
        color: theme.colorScheme.secondary,
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16.r,
              mainAxisSpacing: 16.r,
            ),
            itemCount: _menuItems.length,
            itemBuilder: (context, index) {
              final item = _menuItems[index];
              return GestureDetector(
                onTap: () => _navigateToMenuItemDetail(context, item),
                child: Card(
                  elevation: 10,
                  shadowColor: theme.colorScheme.shadow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16.r),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ImageUtils.imageFromBase64String(
                                item.image,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              Positioned(
                                top: 8.r,
                                right: 8.r,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.r,
                                    vertical: 4.r,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Text(
                                    item.price.toStringAsFixed(2),
                                    style:
                                        theme.textTheme.labelMedium?.copyWith(
                                      color: theme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.all(12.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                item.description,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.r,
                                  vertical: 4.r,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  item.category,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
