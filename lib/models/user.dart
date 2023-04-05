class User {
  User({
    required this.id,
    required this.username,
    this.role,
  });
  int id;
  String username;
  String? role;
  bool get isAdmin => role == 'admin';
  User.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as int,
          username: json['username'] as String,
          role: json['role'] as String?,
        );
}
