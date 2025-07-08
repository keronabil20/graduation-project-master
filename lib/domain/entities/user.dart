class User {
  final String id;
  final String name;
  final String email;
  final bool emailVerified;
  final String userType;
  DateTime? createdAt;
  final DateTime updatedAt;
  String? image; // Optional image URL

  User({
    this.image,
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerified,
    required this.userType,
    this.createdAt,
    required this.updatedAt,
  });
}
