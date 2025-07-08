// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:graduation_project/data/restaurant_model.dart';
import 'package:graduation_project/domain/entities/restaurant.dart';
import 'package:graduation_project/domain/repo/restaurant/restaurant_repository.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final FirebaseFirestore _firestore;

  RestaurantRepositoryImpl(this._firestore);

  @override
  Future<Restaurant> getRestaurant(String id) async {
    final doc = await _firestore.collection('restaurants').doc(id).get();
    return RestaurantModel.fromFirestore(doc);
  }

  @override
  Future<void> updateRestaurant(Restaurant restaurant) async {
    final model = RestaurantModel(
      id: restaurant.id,
      name: restaurant.name,
      description: restaurant.description,
      slogan: restaurant.slogan,
      cuisineType: restaurant.cuisineType,
      address: restaurant.address,
      categories: restaurant.categories,
      coverUrl: restaurant.coverUrl,
      logoUrl: restaurant.logoUrl,
      images: restaurant.images,
      phone: restaurant.phone,
      status: restaurant.status,
      rating: restaurant.rating,
      reviewCount: restaurant.reviewCount,
      experienceYears: restaurant.experienceYears,
      ownerId: restaurant.ownerId,
      createdAt: restaurant.createdAt,
      hours: restaurant.hours,
      openingHours: restaurant.openingHours,
    );

    await _firestore
        .collection('restaurants')
        .doc(restaurant.id)
        .update(model.toFirestore());
  }

  @override
  Future<List<Restaurant>> getAllRestaurants() {
    return _firestore
        .collection('restaurants')
        .where('status', isEqualTo: 'active')
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .map((doc) => RestaurantModel.fromFirestore(doc))
            .toList());
  }

  @override
  Future<List<Restaurant>> getNewRestaurants({int limit = 5}) {
    return _firestore
        .collection('restaurants')
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get()
        .then((querySnapshot) => querySnapshot.docs
            .map((doc) => RestaurantModel.fromFirestore(doc))
            .toList());
  }

  @override
  Future<Restaurant?> getRestaurantById(String restaurantId) async {
    final doc =
        await _firestore.collection('restaurants').doc(restaurantId).get();
    if (!doc.exists) {
      return null;
    }
    return RestaurantModel.fromFirestore(doc);
  }

  @override
  Future<List<Restaurant>> getRestaurantsByCategory(String category) async {
    final querySnapshot = await _firestore
        .collection('restaurants')
        .where('categories', arrayContains: category)
        .where('status', isEqualTo: 'active')
        .get();

    return querySnapshot.docs
        .map((doc) => RestaurantModel.fromFirestore(doc))
        .toList();
  }

  @override
  Future<List<Restaurant>> getRestaurantsByCuisine(String cuisineType) async {
    final querySnapshot = await _firestore
        .collection('restaurants')
        .where('cuisineType', isEqualTo: cuisineType)
        .where('status', isEqualTo: 'active')
        .get();

    return querySnapshot.docs
        .map((doc) => RestaurantModel.fromFirestore(doc))
        .toList();
  }

  @override
  Future<List<Restaurant>> getRestaurantsByLocation(String location) async {
    // Implement location based search, might require geo-hashing or similar techniques
    // This is a placeholder and might not work as expected.
    final querySnapshot = await _firestore
        .collection('restaurants')
        .where('address', isEqualTo: location)
        .where('status', isEqualTo: 'active')
        .get();

    return querySnapshot.docs
        .map((doc) => RestaurantModel.fromFirestore(doc))
        .toList();
  }

  @override
  Future<List<Restaurant>> getTopRatedRestaurants({int limit = 5}) async {
    final querySnapshot = await _firestore
        .collection('restaurants')
        .orderBy(
          'createdAt',
          descending: true,
        )
        .limit(limit)
        .get();

    return querySnapshot.docs
        .map((doc) => RestaurantModel.fromFirestore(doc))
        .toList();
  }

  @override
  Future<List<Restaurant>> searchRestaurantsByName(String query) async {
    final querySnapshot = await _firestore
        .collection('restaurants')
        .where('name', isEqualTo: query)
        .where('status', isEqualTo: 'active')
        .get();

    return querySnapshot.docs
        .map((doc) => RestaurantModel.fromFirestore(doc))
        .toList();
  }

  @override
  Stream<List<Restaurant>> streamAllRestaurants() {
    return _firestore
        .collection('restaurants')
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RestaurantModel.fromFirestore(doc))
            .toList());
  }

  // Stream of liked restaurants (for real-time updates)
  @override
  Stream<List<Restaurant>> streamLikedRestaurants(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('likedRestaurants')
        .orderBy('savedAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      final restaurantRefs = snapshot.docs
          .map((doc) => doc.data()['restaurantRef'] as DocumentReference)
          .toList();

      final restaurants = await Future.wait(
        restaurantRefs.map((ref) => ref.get()),
      );

      return restaurants
          .map((doc) => RestaurantModel.fromFirestore(doc))
          .toList();
    });
  }

  // Like/Save a restaurant
  @override
  Future<void> likeRestaurant(String userId, String restaurantId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('likedRestaurants')
        .doc(restaurantId)
        .set({
      'restaurantRef': _firestore.collection('restaurants').doc(restaurantId),
      'savedAt': FieldValue.serverTimestamp(),
    });
  }

  // Unlike/Remove a restaurant
  @override
  Future<void> unlikeRestaurant(String userId, String restaurantId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('likedRestaurants')
        .doc(restaurantId)
        .delete();
  }

  // Check if restaurant is liked
  @override
  Future<bool> isRestaurantLiked(String userId, String restaurantId) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('likedRestaurants')
        .doc(restaurantId)
        .get();
    return doc.exists;
  }

  // Get all liked restaurants with full restaurant data
  @override
  Future<List<Restaurant>> getLikedRestaurants(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('likedRestaurants')
        .orderBy('savedAt', descending: true)
        .get();

    // Get all restaurant references
    final restaurantRefs = snapshot.docs
        .map((doc) => doc.data()['restaurantRef'] as DocumentReference)
        .toList();

    // Fetch all restaurants in parallel
    final restaurants = await Future.wait(
      restaurantRefs.map((ref) => ref.get()),
    );

    return restaurants
        .map((doc) => RestaurantModel.fromFirestore(doc))
        .toList();
  }

  @override
  Stream<Restaurant?> streamRestaurantById(String restaurantId) {
    return _firestore
        .collection('restaurants')
        .doc(restaurantId)
        .snapshots()
        .map((docSnapshot) {
      if (docSnapshot.exists) {
        return RestaurantModel.fromFirestore(docSnapshot);
      } else {
        return null;
      }
    });
  }
}
