// Project imports:
import 'package:graduation_project/domain/entities/menu_item.dart';

abstract class MenuRepository {
  Future<List<MenuItem>> getMenuItems(String restaurantId);
  Future<MenuItem> getMenuItemById(String restaurantId, String itemId);
  Future<void> createMenuItem(MenuItem menuItem, String restaurantId);

  Future<void> updateMenuItem(String restaurantId, MenuItem item);
  Future<void> deleteMenuItem(String restaurantId, String itemId);
}
