// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import '../../domain/entities/restaurant.dart';

class RestaurantModel extends Restaurant {
  RestaurantModel({
    required super.id,
    required super.name,
    required super.description,
    required super.slogan,
    required super.cuisineType,
    required super.address,
    required super.categories,
    required super.coverUrl,
    required super.logoUrl,
    required super.images,
    required super.phone,
    required super.status,
    required super.rating,
    required super.reviewCount,
    required super.experienceYears,
    required super.ownerId,
    required super.createdAt,
    required super.hours,
    required super.openingHours,
  });

  factory RestaurantModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RestaurantModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      slogan: data['slogan'] ?? '',
      cuisineType: data['cuisineType'] ?? '',
      address: data['address'] ?? '',
      categories: (data['categories'] as List?)
              ?.map((e) => e?.toString() ?? '')
              .toList() ??
          <String>[],
      coverUrl: data['coverUrl'] ?? '',
      logoUrl: data['logoUrl'] ?? '',
      images:
          (data['images'] as List?)?.map((e) => e?.toString() ?? '').toList() ??
              <String>[],
      phone: data['phone'] ?? '',
      status: data['status'] ?? 'active',
      rating: data['rating']?.toString() ?? '0',
      reviewCount: data['reviewCount'] ?? 0,
      experienceYears: data['experienceYears'] ?? 0,
      ownerId: data['ownerId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      hours: (data['hours'] as Map?)
              ?.map((k, v) => MapEntry(k.toString(), v?.toString() ?? '')) ??
          <String, String>{},
      openingHours: data['openingHours'] ?? '',
    );
  }

  static double _parseRating(dynamic rating) {
    if (rating is double) return rating;
    if (rating is int) return rating.toDouble();
    if (rating is String) return double.tryParse(rating) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'slogan': slogan,
      'cuisineType': cuisineType,
      'address': address,
      'categories': categories,
      'coverUrl': coverUrl,
      'logoUrl': logoUrl,
      'images': images,
      'phone': phone,
      'status': status,
      'rating': rating.toString(),
      'reviewCount': reviewCount,
      'experienceYears': experienceYears,
      'ownerId': ownerId,
      'createdAt': Timestamp.fromDate(createdAt),
      'hours': hours,
      'openingHours': openingHours,
    };
  }
}
