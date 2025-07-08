// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

// Project imports:
import 'package:graduation_project/domain/entities/owner.dart';
import 'package:graduation_project/domain/repo/owner/owner_repository.dart';
import 'package:graduation_project/utils/services/image_upload_service.dart';

class OwnerProfileHeader extends StatefulWidget {
  final String ownerId;

  const OwnerProfileHeader({super.key, required this.ownerId});

  @override
  State<OwnerProfileHeader> createState() => _OwnerProfileHeaderState();
}

class _OwnerProfileHeaderState extends State<OwnerProfileHeader> {
  late final OwnerRepository _ownerRepository;
  Owner? _owner;
  bool _isLoading = true;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _ownerRepository = GetIt.I<OwnerRepository>();
    _loadOwnerData();
  }

  Future<void> _loadOwnerData() async {
    try {
      final owner = await _ownerRepository.getOwnerById(widget.ownerId);
      setState(() {
        _owner = owner;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load owner data: $e')),
        );
      }
    }
  }

  Future<void> _updateOwnerImage(String base64Image) async {
    setState(() => _isUploading = true);

    try {
      await _ownerRepository.uploadOwnerImage(widget.ownerId, base64Image);

      // Update local state by creating a new Owner object with the updated image
      setState(() {
        _owner = Owner(
          id: _owner!.id,
          name: _owner!.name,
          email: _owner!.email,
          emailVerified: _owner!.emailVerified,
          userType: _owner!.userType,
          createdAt: _owner!.createdAt,
          updatedAt: _owner!.updatedAt,
          image: base64Image,
          restaurantName: _owner!.restaurantName,
          restaurantAddress: _owner!.restaurantAddress,
          status: _owner!.status,
          verified: _owner!.verified,
        );
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update image: $e')),
        );
      }
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_owner == null) {
      return const Center(child: Text("Owner data not available"));
    }

    final name = _owner!.name ?? 'Owner Name';
    final email = _owner!.email ?? 'No Email';
    final imageBase64 = _owner!.image;

    ImageProvider avatarProvider;
    if (imageBase64.isNotEmpty) {
      try {
        avatarProvider = MemoryImage(base64Decode(imageBase64));
      } catch (_) {
        avatarProvider = const AssetImage('assets/1.png');
      }
    } else {
      avatarProvider = const AssetImage('assets/1.png');
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 8.h),
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundImage: avatarProvider,
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: GestureDetector(
                onTap: () async {
                  if (_isUploading) return;

                  final file = await ImageUploadService().pickImage();
                  if (file != null) {
                    final base64 =
                        await ImageUploadService().fileToBase64(file);
                    if (base64 != null) {
                      await _updateOwnerImage(base64);
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.edit,
                    size: 18,
                    color: _isUploading ? Colors.grey : Colors.deepOrange,
                  ),
                ),
              ),
            ),
            if (_isUploading)
              Positioned.fill(
                child: Container(
                  color: Colors.black26,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          name,
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          email,
          style: textTheme.bodyMedium,
        ),
        if (_owner?.restaurantName != null) ...[
          SizedBox(height: 4.h),
          Text(
            _owner!.restaurantName,
            style: textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }
}
