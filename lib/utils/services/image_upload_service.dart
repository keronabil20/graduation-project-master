// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ImageUploadService {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Pick an image from gallery and return as File
  Future<File?> pickImage({int imageQuality = 50}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error picking image: $e');
      }
      return null;
    }
  }

  /// Convert File to base64 string
  Future<String?> fileToBase64(File file) async {
    try {
      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      if (kDebugMode) {
        print('Error converting file to base64: $e');
      }
      return null;
    }
  }

  /// Upload image to Firebase Storage and return download URL
  Future<String?> uploadImageToStorage(File file, String storagePath) async {
    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}';
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image to storage: $e');
      }
      return null;
    }
    return null;
  }

  /// Upload image to Firebase Storage and return base64 string
  Future<String?> uploadImageToStorageAndGetBase64(
      File file, String storagePath) async {
    try {
      final base64String = await fileToBase64(file);
      if (base64String != null) {
        await uploadImageToStorage(file, storagePath);
        return base64String;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image and getting base64: $e');
      }
      return null;
    }
  }

  /// Delete image from Firebase Storage
  Future<void> deleteImageFromStorage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting image from storage: $e');
      }
    }
  }
}
