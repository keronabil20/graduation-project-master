// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:graduation_project/presentation/auth/login/navigation_secrvices.dart';
import 'package:graduation_project/presentation/auth/sign_up/pending_dialog.dart';

class LoginHandler {
  final FirebaseFirestore _firestore;

  LoginHandler(this._firestore);

  Future<void> handleUserNavigation(String userId, BuildContext context) async {
    try {
      final ownerDoc = await _firestore.collection('owners').doc(userId).get();
      ownerDoc.exists
          ? await _handleOwnerNavigation(ownerDoc, context)
          : NavigationService.navigateToUserHome(context);
    } catch (e) {
      _showNavigationError(context, 'Failed to verify user type');
      rethrow;
    }
  }

  Future<void> _handleOwnerNavigation(
      DocumentSnapshot ownerDoc, BuildContext context) async {
    try {
      final ownerData = ownerDoc.data() as Map<String, dynamic>;
      final isVerified = ownerData['verified'] ?? false;
      final userId = ownerDoc.id;

      if (!isVerified) {
        showPendingDialog(context);
        return;
      }

      final restaurantId = await _getRestaurantId(userId, ownerData);
      restaurantId == null
          ? NavigationService.navigateToCreateRestaurant(context)
          : await _verifyAndNavigateToRestaurant(userId, restaurantId, context);
    } catch (e) {
      _showNavigationError(context, 'Failed to process owner navigation');
      rethrow;
    }
  }

  Future<String?> _getRestaurantId(
      String userId, Map<String, dynamic> ownerData) async {
    try {
      // Check owner document first
      final restaurantIdFromOwner = ownerData['restaurantId'];

      // Check restaurants collection if not found in owner doc
      if (restaurantIdFromOwner == null) {
        final restaurantQuery = await _firestore
            .collection('restaurants')
            .where('ownerId', isEqualTo: userId)
            .limit(1)
            .get();

        return restaurantQuery.docs.isNotEmpty
            ? restaurantQuery.docs.first.id
            : null;
      }

      return restaurantIdFromOwner;
    } catch (e) {
      throw Exception('Failed to retrieve restaurant ID: $e');
    }
  }

  Future<void> _verifyAndNavigateToRestaurant(
      String userId, String restaurantId, BuildContext context) async {
    try {
      // Verify restaurant exists
      final restaurantDoc =
          await _firestore.collection('restaurants').doc(restaurantId).get();

      if (!restaurantDoc.exists) {
        // Clean up references if restaurant was deleted
        await _cleanUpRestaurantReferences(userId);
        NavigationService.navigateToCreateRestaurant(context);
        return;
      }

      // Ensure owner document has correct restaurantId
      if (restaurantDoc.data()?['ownerId'] != userId) {
        await _firestore.collection('owners').doc(userId).update({
          'restaurantId': FieldValue.delete(),
        });
        NavigationService.navigateToCreateRestaurant(context);
        return;
      }

      NavigationService.navigateToRestaurantHome(context, restaurantId);
    } catch (e) {
      _showNavigationError(context, 'Failed to verify restaurant');
      rethrow;
    }
  }

  Future<void> _cleanUpRestaurantReferences(String userId) async {
    try {
      await _firestore.collection('owners').doc(userId).update({
        'restaurantId': FieldValue.delete(),
      });
    } catch (e) {
      throw Exception('Failed to clean up restaurant references: $e');
    }
  }

  void _showNavigationError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }
}
