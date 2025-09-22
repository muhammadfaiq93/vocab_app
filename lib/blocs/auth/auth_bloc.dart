import 'package:bloc/bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

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
        emit(AuthenticatedState(user: mockUser, token: 'demo_token'));
      } else {
        emit(const AuthErrorState(message: 'Please enter valid credentials'));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

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
        };
        emit(AuthenticatedState(user: mockUser, token: 'demo_token'));
      } else {
        emit(const AuthErrorState(message: 'Please fill in all fields'));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
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
      emit(AuthenticatedState(user: mockUser, token: 'demo_token'));
    } catch (e) {
      emit(UnauthenticatedState());
    }
  }
}
