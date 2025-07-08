// domain/entities/menu_item.dart
class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final DateTime createdAt;
  final String image;

  MenuItem({
    required this.image,
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.createdAt,
  });

  MenuItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    String? image,
    DateTime? createdAt,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
