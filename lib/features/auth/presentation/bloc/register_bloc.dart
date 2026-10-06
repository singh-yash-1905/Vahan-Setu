import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/repository/auth_repo/register_repository.dart';
import 'register_event.dart';
import 'register_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    // All event handlers MUST be registered strictly inside this constructor
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<FetchAdminProfile>(_onFetchAdminProfile);
    on<ChangePasswordRequested>(_onChangePasswordRequested);
    on<FetchUserByIdEvent>(_onFetchUserById);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Executing the actual login network call
      await authRepository.login(email: event.email, password: event.password);
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Map the UI dropdown role exactly to what the API expects
      final String apiRole = event.role == 'Admin (Auditor & Approver)'
          ? 'admin'
          : event.role.toLowerCase();

      await authRepository.register(
        accessCode: event.accessCode,
        email: event.email,
        name: event.name,
        password: event.password,
        phone: event.phone,
        role: apiRole,
      );

      emit(AuthAuthenticated());
    } catch (e) {
      // Cleans up standard dart exception prefixes for cleaner UI SnackBars
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      // Clears the securely stored tokens
      await authRepository.logout();
    } catch (_) {
      // Force unauthenticated state even if local storage deletion throws an error
    }

    // Emits unauthenticated state so the UI kicks the user back to the login screen
    emit(AuthUnauthenticated());
  }

  Future<void> _onFetchAdminProfile(
    FetchAdminProfile event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await authRepository.getCurrentUser();
      emit(AuthProfileLoaded(user));
    } catch (e) {
      // Fallback to error if profile fetch fails
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onChangePasswordRequested(
    ChangePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.changePassword(
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
      );
      emit(AuthPasswordChanged());
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onFetchUserById(
    FetchUserByIdEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(UserDetailLoading());
    try {
      final user = await authRepository.getUserById(event.userId);
      emit(UserDetailLoaded(user));
    } catch (e) {
      emit(UserDetailError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
