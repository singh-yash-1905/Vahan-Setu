class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.lastLoginAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      isActive: json['is_active'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      lastLoginAt: DateTime.parse(json['last_login_at']),
    );
  }
}
