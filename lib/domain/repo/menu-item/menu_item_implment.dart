// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:graduation_project/domain/entities/menu_item.dart';
import 'package:graduation_project/domain/repo/menu-item/menu_repository.dart';
import 'package:graduation_project/utils/image_utils.dart';

class MenuRepositoryImpl implements MenuRepository {
  final FirebaseFirestore _firestore;
  final _uuid = const Uuid();

  MenuRepositoryImpl(this._firestore);

  @override
  Future<List<MenuItem>> getMenuItems(String restaurantId) async {
    final snapshot = await _firestore
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menu')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final imageData = data['image'] ?? '';
      // Ensure the image is in base64 format
      final base64Image = ImageUtils.ensureBase64Image(imageData);

      return MenuItem(
        id: doc.id,
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        price: (data['price'] ?? 0.0).toDouble(),
        category: data['category'] ?? '',
        image: base64Image,
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );
    }).toList();
  }

  @override
  Future<MenuItem> getMenuItemById(String restaurantId, String itemId) async {
    final doc = await _firestore
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menu')
        .doc(itemId)
        .get();

    if (!doc.exists) {
      throw Exception('Menu item not found');
    }

    final data = doc.data()!;
    final imageData = data['image'] ?? '';
    // Ensure the image is in base64 format
    final base64Image = ImageUtils.ensureBase64Image(imageData);

    return MenuItem(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      category: data['category'] ?? '',
      image: base64Image,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  @override
  Future<void> createMenuItem(MenuItem menuItem, String restaurantId) async {
    final menuItemId = _uuid.v4();
    final base64Image = ImageUtils.ensureBase64Image(menuItem.image);

    final menuItemData = {
      'name': menuItem.name,
      'description': menuItem.description,
      'price': menuItem.price,
      'category': menuItem.category,
      'image': base64Image,
      'createdAt': Timestamp.fromDate(menuItem.createdAt),
    };

    await _firestore
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menu')
        .doc(menuItemId)
        .set(menuItemData);
  }

  @override
  Future<void> updateMenuItem(String restaurantId, MenuItem item) async {
    final base64Image = ImageUtils.ensureBase64Image(item.image);

    try {
      await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu')
          .doc(item.id)
          .update({
        'name': item.name,
        'description': item.description,
        'price': item.price,
        'category': item.category,
        'image': base64Image,
      });
    } catch (e) {
      throw Exception('Failed to update menu item: $e');
    }
  }

  @override
  Future<void> deleteMenuItem(String restaurantId, String itemId) async {
    try {
      await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('menu')
          .doc(itemId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete menu item: $e');
    }
  }
}
