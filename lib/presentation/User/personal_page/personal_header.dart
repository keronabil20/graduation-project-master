// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

// Project imports:
import 'package:graduation_project/domain/entities/user.dart' as domain;
import 'package:graduation_project/domain/repo/user/user_repository.dart';
import 'package:graduation_project/utils/services/image_upload_service.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  late final UserRepository _userRepository;
  domain.User? _user;
  bool _isLoading = true;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _userRepository = GetIt.I<UserRepository>();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userId = _userRepository.getCurrentUserId();
    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final user = await _userRepository.getUser(userId);
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data: $e')),
        );
      }
    }
  }

  Future<void> _updateUserImage(String base64Image) async {
    final userId = _userRepository.getCurrentUserId();
    if (userId == null || _user == null) return;

    setState(() => _isUploading = true);

    try {
      final updatedUser = domain.User(
        id: _user!.id,
        name: _user!.name,
        email: _user!.email,
        emailVerified: _user!.emailVerified,
        userType: _user!.userType,
        createdAt: _user!.createdAt,
        updatedAt: DateTime.now(),
        image: base64Image,
      );

      await _userRepository.updateUser(updatedUser);

      setState(() {
        _user = updatedUser;
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

    if (_user == null) {
      return const Center(child: Text("User not available"));
    }

    final name = _user!.name ?? 'No Name';
    final email = _user!.email ?? 'No Email';
    final imageBase64 = _user!.image;

    ImageProvider avatarProvider;
    if (imageBase64 != null && imageBase64.isNotEmpty) {
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
                      await _updateUserImage(base64);
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
      ],
    );
  }
}
