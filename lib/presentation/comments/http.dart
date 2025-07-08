// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Posts a review and returns `true` if the predicted rating is 1 (positive), `false` otherwise.
Future<bool> postComment(String review) async {
  final Uri url = Uri.parse('put your api here');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'review': review}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        final jsonResponse = jsonDecode(response.body);

        // ✅ Corrected key access
        final predictedRating = jsonResponse['predicted_rating'];
        final bool isPositive = predictedRating == 1;

        if (kDebugMode) {
          print('Success: $jsonResponse');
        }
        return isPositive;
      } else {
        if (kDebugMode) {
          print('Error: Expected JSON, got: ${response.body}');
        }
        return false;
      }
    } else {
      if (kDebugMode) {
        print('Error: HTTP ${response.statusCode} - ${response.body}');
      }
      return false;
    }
  } catch (e) {
    if (kDebugMode) {
      print('Request failed: $e');
    }
    return false;
  }
}
