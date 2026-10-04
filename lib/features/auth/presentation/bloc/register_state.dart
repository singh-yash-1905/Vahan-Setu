import 'package:vahan_setu/features/dashboard/data/user_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class AuthProfileLoaded extends AuthState {
  final UserModel user;
  AuthProfileLoaded(this.user);
}

class AuthPasswordChanged extends AuthState {}
