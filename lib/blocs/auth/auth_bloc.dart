import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  // TEMPORARY: Simple mock implementation to stop compilation errors
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      // Mock successful login for testing
      await Future.delayed(Duration(milliseconds: 500));

      // Create a simple mock user - replace with actual user model
      final mockUser = {
        'id': 1,
        'name': 'Test User',
        'email': event.email,
        'age': 12,
      };

      emit(AuthenticatedState(user: mockUser, token: 'demo_token'));
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      // Mock successful registration for testing
      await Future.delayed(Duration(milliseconds: 500));

      final mockUser = {
        'id': 1,
        'name': event.name,
        'email': event.email,
        'age': event.age,
      };

      emit(AuthenticatedState(user: mockUser, token: 'demo_token'));
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      // Mock logout
      await Future.delayed(Duration(milliseconds: 300));
      emit(UnauthenticatedState());
    } catch (e) {
      emit(UnauthenticatedState());
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    // For testing, assume always authenticated
    final mockUser = {
      'id': 1,
      'name': 'Test User',
      'email': 'test@example.com',
      'age': 12,
    };

    emit(AuthenticatedState(user: mockUser, token: 'demo_token'));
  }
}
