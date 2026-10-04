abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

class RegisterRequested extends AuthEvent {
  final String accessCode;
  final String email;
  final String name;
  final String password;
  final String phone;
  final String role;

  RegisterRequested({
    required this.accessCode,
    required this.email,
    required this.name,
    required this.password,
    required this.phone,
    required this.role,
  });
}

class LogoutRequested extends AuthEvent {}

class FetchAdminProfile extends AuthEvent {}

class ChangePasswordRequested extends AuthEvent {
  final String oldPassword;
  final String newPassword;
  ChangePasswordRequested({
    required this.oldPassword,
    required this.newPassword,
  });
}
