// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:graduation_project/domain/entities/menu_item.dart';

class MenuItemModel extends MenuItem {
  MenuItemModel(
      {required super.id,
      required super.name,
      required super.price,
      required super.category,
      required super.createdAt,
      required super.description,
      required super.image});

  factory MenuItemModel.fromJson(Map<String, dynamic> json, String id) {
    return MenuItemModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] as num).toDouble(),
      category: json['category'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'id': id,
      'category': category,
      'createdAt': createdAt,
    };
  }
}
