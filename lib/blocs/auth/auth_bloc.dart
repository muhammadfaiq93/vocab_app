import 'package:bloc/bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    on<AuthLogin>(_onLogin);
    on<AuthRegister>(_onRegister);
    on<AuthLogout>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      // Simulate login API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock successful login
      if (event.email.isNotEmpty && event.password.isNotEmpty) {
        final mockUser = {
          'id': 1,
          'name': 'Demo User',
          'email': event.email,
        };
        emit(AuthAuthenticated(user: mockUser, token: 'demo_token'));
      } else {
        emit(AuthError(message: 'Please enter valid credentials'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onRegister(AuthRegister event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      // Simulate registration API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock successful registration
      if (event.email.isNotEmpty &&
          event.password.isNotEmpty &&
          event.name.isNotEmpty) {
        final mockUser = {
          'id': 1,
          'name': event.name,
          'email': event.email,
          'age': event.age,
        };
        emit(AuthAuthenticated(user: mockUser, token: 'demo_token'));
      } else {
        emit(AuthError(message: 'Please fill in all fields'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogout(AuthLogout event, Emitter<AuthState> emit) async {
    try {
      // Simulate logout API call or cleanup
      await Future.delayed(const Duration(seconds: 1));
      emit(UnauthenticatedState());
    } catch (e) {
      emit(UnauthenticatedState());
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // Check if user is authenticated (check token, etc.)
      // This is a mock implementation
      await Future.delayed(const Duration(seconds: 1));

      // Mock check - replace with actual auth check
      final mockUser = {
        'id': 1,
        'name': 'Demo User',
        'email': 'demo@example.com',
      };
      emit(AuthAuthenticated(user: mockUser, token: 'demo_token'));
    } catch (e) {
      emit(UnauthenticatedState());
    }
  }
}
