// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:graduation_project/utils/services/image_upload_service.dart';

class ImageUploadWidget extends StatefulWidget {
  final String? initialImageUrl;
  final String? initialBase64Image;
  final Function(String base64Image) onImageSelected;
  final double? width;
  final double? height;
  final String? label;
  final bool showDeleteButton;
  final String storagePath;

  const ImageUploadWidget({
    super.key,
    this.initialImageUrl,
    this.initialBase64Image,
    required this.onImageSelected,
    this.width,
    this.height,
    this.label,
    this.showDeleteButton = true,
    required this.storagePath,
  });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  final ImageUploadService _imageUploadService = ImageUploadService();
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialBase64Image != null) {
      // Handle initial base64 image if provided
    }
  }

  Future<void> _pickAndUploadImage() async {
    setState(() => _isLoading = true);
    try {
      final image = await _imageUploadService.pickImage();
      if (image != null) {
        setState(() => _selectedImage = image);
        final base64Image =
            await _imageUploadService.uploadImageToStorageAndGetBase64(
          image,
          widget.storagePath,
        );
        if (base64Image != null) {
          widget.onImageSelected(base64Image);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
    widget.onImageSelected('');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        GestureDetector(
          onTap: _isLoading ? null : _pickAndUploadImage,
          child: Container(
            width: widget.width ?? double.infinity,
            height: widget.height ?? 200.h,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _selectedImage != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          if (widget.showDeleteButton)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                onPressed: _removeImage,
                              ),
                            ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate,
                            size: 48.sp,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Tap to upload image',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
          ),
        ),
      ],
    );
  }
}
