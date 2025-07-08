class Order {
  final String? id;
  final String restaurantId;
  final String customerId;
  final String customerName;
  final String status;
  final List<OrderItem> items;
  final double subtotal;
  final double tax;
  final double total;
  final String? notes;
  final DateTime createdAt;

  Order({
    this.id,
    required this.restaurantId,
    required this.customerId,
    required this.customerName,
    this.status = 'pending',
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    this.notes,
    required this.createdAt,
  });

  Order copyWith({
    String? id,
    String? status,
    List<OrderItem>? items,
    double? subtotal,
    double? tax,
    double? total,
    String? notes,
  }) {
    return Order(
      id: id ?? this.id,
      restaurantId: restaurantId,
      customerId: customerId,
      customerName: customerName,
      status: status ?? this.status,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      notes: notes ?? this.notes,
      createdAt: createdAt,
    );
  }
}

class OrderItem {
  final String itemId;
  final String name;
  final double price;
  final int quantity;
  final String image;

  const OrderItem({
    required this.image,
    required this.itemId,
    required this.name,
    required this.price,
    required this.quantity,
  });
}
