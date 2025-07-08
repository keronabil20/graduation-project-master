// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

class ImageUtils {
  static Image imageFromBase64String(String base64String,
      {double? width, double? height}) {
    // Remove the data URI prefix if present
    String cleanBase64 = base64String;
    if (base64String.contains(',')) {
      cleanBase64 = base64String.split(',')[1];
    }

    try {
      return Image.memory(
        base64Decode(cleanBase64),
        width: width,
        height: height,
        key: ValueKey(base64String),
        gaplessPlayback: true, // Use the base64 string as a key
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Error loading image: $error');
          return Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: const Icon(Icons.error_outline, color: Colors.grey),
          );
        },
      );
    } catch (e) {
      debugPrint('Error decoding base64: $e');
      return Image.network(
        'https://via.placeholder.com/150',
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: const Icon(Icons.error_outline, color: Colors.grey),
          );
        },
      );
    }
  }

  static String base64StringFromImage(String imageUrl) {
    // This is a placeholder. In a real implementation, you would need to:
    // 1. Download the image from the URL
    // 2. Convert it to base64
    // For now, we'll return the URL as is
    return imageUrl;
  }

  static Widget buildImageWidget(String imageSource,
      {double? width, double? height}) {
    if (imageSource.startsWith('data:image') ||
        imageSource.startsWith('data:image')) {
      // Handle base64 image
      return imageFromBase64String(imageSource, width: width, height: height);
    } else {
      // Handle URL image
      return Image.network(
        imageSource,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Error loading network image: $error');
          return Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: const Icon(Icons.error_outline, color: Colors.grey),
          );
        },
      );
    }
  }

  static String ensureBase64Image(String imageData) {
    if (imageData.isEmpty) return '';

    // If it's already a base64 string, return it
    if (imageData.startsWith('data:image')) {
      return imageData;
    }

    // If it's a URL, convert it to base64
    if (imageData.startsWith('http')) {
      return base64StringFromImage(imageData);
    }

    // If it's a raw base64 string without the data URI prefix, add it
    if (!imageData.startsWith('data:image')) {
      try {
        // Try to decode to verify it's valid base64
        base64Decode(imageData);
        return 'data:image/jpeg;base64,$imageData';
      } catch (e) {
        // If it's not valid base64, return as is
        return imageData;
      }
    }

    return imageData;
  }
}
