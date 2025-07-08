// lib/data/api/sentiment_analysis_api.dart

// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:http/http.dart' as http;

class SentimentAnalysisApi {
  final http.Client client;

  SentimentAnalysisApi({required this.client});

  Future<bool> analyze(String text) async {
    final response = await client.post(
      Uri.parse('put your api key '),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'review': text}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['prediction'] ?? false;
    } else {
      throw Exception('Failed to analyze sentiment');
    }
  }
}
