// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String title;
  final DateTime date;
  final String imageUrl;

  EventModel({
    required this.title,
    required this.date,
    required this.imageUrl,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      title: json['title'] ?? '',
      date: (json['date'] as Timestamp).toDate(),
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
