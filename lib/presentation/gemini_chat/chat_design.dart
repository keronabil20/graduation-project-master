// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatAlign extends StatelessWidget {
  const ChatAlign({
    super.key,
    required this.isUser,
    required this.message,
  });

  final bool isUser;
  final Map<String, String> message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isUser
              ? Colors.deepOrange
              : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isUser ? const Radius.circular(20) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message['image'] != null)
              Image.memory(
                base64Decode(message['image']!),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            SelectableText.rich(
              TextSpan(
                children:
                    _formatResponseText(message['text']!, isUser, context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<TextSpan> _formatResponseText(
    String text, bool isUser, BuildContext context) {
  List<TextSpan> spans = [];
  RegExp boldPattern = RegExp(r'\*\*(.*?)\*\*'); // Detects **bold text**
  int lastMatchEnd = 0;

  Color textColor =
      isUser ? Colors.white : Theme.of(context).colorScheme.inversePrimary;

  for (RegExpMatch match in boldPattern.allMatches(text)) {
    // Add normal text before the match
    if (match.start > lastMatchEnd) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd, match.start),
        style: TextStyle(
          color: textColor,
          fontSize: 14.sp,
        ),
      ));
    }

    // Add bold text (removing **)
    spans.add(TextSpan(
      text: match.group(1), // Extract text inside **
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: textColor,
        fontSize: 15.sp,
      ),
    ));

    lastMatchEnd = match.end;
  }

  // Add remaining normal text
  if (lastMatchEnd < text.length) {
    spans.add(TextSpan(
      text: text.substring(lastMatchEnd),
      style: TextStyle(
        color: textColor,
        fontSize: 14.sp,
      ),
    ));
  }

  return spans;
}
