// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final dynamic restaurant;
  const ProfileCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundImage: restaurant['logoUrl'] != null &&
                          restaurant['logoUrl'].isNotEmpty
                      ? MemoryImage(base64Decode(restaurant['logoUrl']))
                      : null,
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant['name'] ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 18, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            restaurant['address'] ?? '',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          ...List.generate(
                              4,
                              (i) => Icon(Icons.star,
                                  color: Colors.amber, size: 18)),
                          Icon(Icons.star, color: Colors.grey[400], size: 18),
                          const SizedBox(width: 4),
                          Text('4.0',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
