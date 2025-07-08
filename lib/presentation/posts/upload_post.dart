// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:graduation_project/domain/repo/post/post_repository.dart';
import 'package:graduation_project/presentation/posts/cubit/upload_post_cubit.dart';
import 'package:graduation_project/utils/widgets/image_upload_widget.dart';

class UploadPostScreen extends StatefulWidget {
  final String userId;
  final String username;
  final String restaurantId;
  final PostRepository postRepository;

  const UploadPostScreen({
    super.key,
    required this.userId,
    required this.username,
    required this.restaurantId,
    required this.postRepository,
  });

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  String? _base64Image;
  File? _imageFile;

  void _submitPost() {
    if (_base64Image == null || _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image and add a description'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<UploadPostCubit>().uploadPost(
          userId: widget.userId,
          username: widget.username,
          restaurantId: widget.restaurantId,
          description: _descriptionController.text.trim(),
          image: _imageFile!, // assuming backend needs File
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UploadPostCubit(postRepository: widget.postRepository),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Post'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<UploadPostCubit, UploadPostState>(
            listener: (context, state) {
              if (state is UploadPostSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Post uploaded successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              } else if (state is UploadPostError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is UploadPostLoading;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    const Text(
                      'Upload an Image',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ImageUploadWidget(
                          label: null,
                          storagePath:
                              'posts/${widget.restaurantId}_${DateTime.now().millisecondsSinceEpoch}',
                          onImageSelected: (base64Image) {
                            setState(() {
                              _base64Image = base64Image;
                              final bytes = base64Decode(base64Image);
                              final tempDir = Directory.systemTemp;
                              final file = File(
                                  '${tempDir.path}/temp_image_${DateTime.now().millisecondsSinceEpoch}.jpg');
                              file.writeAsBytesSync(bytes);
                              _imageFile = file;
                            });
                          },
                        ),
                      ),
                    ),
                    const Text(
                      'Add a Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Write something about your post...',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      maxLines: 4,
                      enabled: !isLoading,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.upload, size: 22),
                        label: isLoading
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              )
                            : const Text(
                                'Submit Post',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                        onPressed: isLoading ? null : _submitPost,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.deepOrange,
                          disabledBackgroundColor: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
