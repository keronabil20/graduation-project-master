// Flutter imports:
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

// Project imports:
import '../../utils/image_utils.dart';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String slogan;
  final String cuisineType;
  final String address;
  final List<String> categories;
  final String coverUrl;
  final String logoUrl;
  final List<String> images;
  final String phone;
  final String status;
  final String rating;
  final int? reviewCount;
  final int experienceYears;
  final String ownerId;
  final DateTime createdAt;
  final Map<String, String> hours;
  final String openingHours;
  LatLng? geoLocation;

  Restaurant({
    this.geoLocation,
    required this.id,
    required this.name,
    required this.description,
    required this.slogan,
    required this.cuisineType,
    required this.address,
    required this.categories,
    required this.coverUrl,
    required this.logoUrl,
    required this.images,
    required this.phone,
    required this.status,
    required this.rating,
    this.reviewCount,
    required this.experienceYears,
    required this.ownerId,
    required this.createdAt,
    required this.hours,
    required this.openingHours,
  });

  Widget getCoverImage({double? width, double? height}) {
    return ImageUtils.buildImageWidget(coverUrl, width: width, height: height);
  }

  Widget getLogoImage({double? width, double? height}) {
    return ImageUtils.buildImageWidget(logoUrl, width: width, height: height);
  }

  List<Widget> getImageGallery({double? width, double? height}) {
    return images
        .map((imageUrl) =>
            ImageUtils.buildImageWidget(imageUrl, width: width, height: height))
        .toList();
  }
}
