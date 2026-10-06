class UserModel {
  final String name;
  final String email;
  final String phone;
  final String role;
  final bool isActive;
  final int id;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.isActive,
    required this.id,
    required this.createdAt,
    required this.lastLoginAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      isActive: json['is_active'] ?? false,
      id: json['id'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'])
          : null,
    );
  }
}
