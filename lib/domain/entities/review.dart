class Review {
  final String id;
  final String userRef;
  final String comment;
  final bool commentResult;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userRef,
    required this.comment,
    required this.commentResult,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userRef': userRef,
      'comment': comment,
      'commentResult': commentResult,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userRef: json['userRef'],
      comment: json['comment'],
      commentResult: json['commentResult'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
