// Dart imports:
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

// Project imports:
import 'package:graduation_project/presentation/gemini_chat/chat_design.dart';
import 'package:graduation_project/utils/constants/constants.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  late final GenerativeModel _model;
  final ImagePicker _picker = ImagePicker();
  String prompt =
      '''Please provide the name of the food item you want detailed nutritional
           and suitability information about. do not answer questions that unrelated to
            food and restaurant topics  make every response related to food topic even if it a joke ,poem ,story''';

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: "put your api",
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
      ),
    );
  }

  // Method to send a text message
  void _sendMessage(String message) async {
    setState(() {
      _messages.add({'role': 'user', 'text': message});
    });
    _controller.clear();

    final chat = _model.startChat(
      history: [
        Content.model([TextPart(prompt)]),
      ],
    );

    final content = Content.text(message);
    final response = await chat.sendMessage(content);
    setState(() {
      _messages.add({
        'role': 'ai',
        'text': response.text ?? "No response text",
      });
    });
  }

  // Method to pick an image and send it
  Future<void> _pickAndSendImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final File file = File(image.path);
      final Uint8List imageBytes = await file.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      setState(() {
        _messages.add({
          'role': 'user',
          'text': 'Image sent',
          'image': base64Image,
        });
      });

      final chat = _model.startChat(
        history: [
          Content.model([TextPart(prompt)]),
        ],
      );

      // Decode the base64 string back to Uint8List
      final Uint8List imageData = base64Decode(base64Image);

      final content = Content.multi([
        TextPart(
          'Identify the food item in this image and provide nutritional information.',
        ),
        DataPart('image/jpeg', imageData), // Pass the Uint8List here
      ]);

      final response = await chat.sendMessage(content);
      setState(() {
        _messages.add({
          'role': 'ai',
          'text': response.text ?? "No response text",
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['role'] == 'user';
                return AnimatedBuilder(
                  animation: Listenable.merge([_controller]),
                  builder: (context, child) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                        );
                      },
                      child: ChatAlign(
                        key: ValueKey(
                          message,
                        ), // Ensure unique key for animation
                        isUser: isUser,
                        message: message,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0.sp),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Write here",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey, width: 1.w),
                      ),
                      filled: true,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.image, color: deeporange),
                        onPressed: _pickAndSendImage,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      _sendMessage(_controller.text.trim());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deeporange,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
