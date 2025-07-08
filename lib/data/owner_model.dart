// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import '../domain/entities/owner.dart';

class OwnerModel extends Owner {
  OwnerModel({
    required super.id,
    required super.email,
    required super.emailVerified,
    required super.image,
    required super.name,
    required super.restaurantAddress,
    required super.restaurantName,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    required super.userType,
    required super.verified,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) => OwnerModel(
        id: json['id'] ?? '',
        email: json['email'] ?? '',
        emailVerified: json['emailVerified'] ?? false,
        image: json['image'] ?? '',
        name: json['name'] ?? '',
        restaurantAddress: json['restaurantAddress'] ?? '',
        restaurantName: json['restaurantName'] ?? '',
        status: json['status'] ?? '',
        createdAt:
            (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        updatedAt:
            (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        userType: json['userType'] ?? '',
        verified: json['verified'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'emailVerified': emailVerified,
        'image': image,
        'name': name,
        'restaurantAddress': restaurantAddress,
        'restaurantName': restaurantName,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'userType': userType,
        'verified': verified,
      };
}
