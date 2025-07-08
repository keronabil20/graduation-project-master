// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:graduation_project/domain/entities/order.dart' as entity;
import 'package:graduation_project/domain/entities/order.dart';

class OrderModel extends entity.Order {
  OrderModel({
    super.id,
    required super.restaurantId,
    required super.customerId,
    required super.customerName,
    super.status,
    required super.items,
    required super.subtotal,
    required super.tax,
    required super.total,
    super.notes,
    required super.createdAt,
  });

  factory OrderModel.fromEntity(entity.Order order) {
    return OrderModel(
      id: order.id,
      restaurantId: order.restaurantId,
      customerId: order.customerId,
      customerName: order.customerName,
      status: order.status,
      items: order.items,
      subtotal: order.subtotal,
      tax: order.tax,
      total: order.total,
      notes: order.notes,
      createdAt: order.createdAt,
    );
  }

  factory OrderModel.fromFirestore(
    String id,
    Map<String, dynamic> map,
  ) {
    return OrderModel(
      id: id,
      restaurantId: map['restaurantId'],
      customerId: map['customerId'],
      customerName: map['customerName'],
      status: map['status'],
      items: List<OrderItem>.from(
        map['items']?.map((x) => OrderItem(
              image: x['image'] ?? '',
              itemId: x['itemId'],
              name: x['name'],
              price: x['price'],
              quantity: x['quantity'],
            )),
      ),
      subtotal: map['subtotal'],
      tax: map['tax'],
      total: map['total'],
      notes: map['notes'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
  @override
  OrderModel copyWith({
    String? id,
    String? restaurantId,
    String? customerId,
    String? customerName,
    String? status,
    List<OrderItem>? items,
    double? subtotal,
    double? tax,
    double? total,
    String? notes,
    DateTime? createdAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      status: status ?? this.status,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'restaurantId': restaurantId,
      'customerId': customerId,
      'customerName': customerName,
      'status': status,
      'items': items
          .map((item) => {
                'itemId': item.itemId,
                'name': item.name,
                'price': item.price,
                'quantity': item.quantity,
              })
          .toList(),
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
