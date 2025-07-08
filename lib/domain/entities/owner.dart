class Owner {
  final String id;
  final String email;
  final bool emailVerified;
  String image; // base64 string
  final String name;
  final String restaurantAddress;
  final String restaurantName;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userType;
  final bool verified;

  Owner({
    required this.id,
    required this.email,
    required this.emailVerified,
    required this.image,
    required this.name,
    required this.restaurantAddress,
    required this.restaurantName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.userType,
    required this.verified,
  });
}
