import 'package:bloc/bloc.dart';
import '../../constants/app_strings.dart';
import '../../models/child_user.dart';
import '../../services/api_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService _apiService;

  AuthBloc({ApiService? apiService})
      : _apiService = apiService ?? ApiService(),
        super(AuthInitialState()) {
    on<AuthLogin>(_onLogin);
    on<AuthRegister>(_onRegister);
    on<AuthLogout>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  /// Handles user login
  Future<void> _onLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final response = await _apiService.login(
        email: event.email,
        password: event.password,
      );

      if (response.success && response.data != null) {
        final loginData = response.data!;

        // Emit authenticated state with user data and token
        emit(AuthAuthenticated(
          user: loginData.user
              .toMap(), // Convert to Map for backward compatibility
          token: loginData.token,
        ));

        // Log successful login for debugging
        _logInfo('User logged in successfully: ${loginData.user.email}');
      } else {
        // Handle login failure
        final errorMessage = response.message ?? AppStrings.loginFailed;
        emit(AuthError(message: errorMessage));

        _logError('Login failed: $errorMessage');
      }
    } catch (e) {
      // Handle unexpected errors
      const errorMessage = AppStrings.unexpectedError;
      emit(AuthError(message: errorMessage));

      _logError('Login error: $e');
    }
  }

  /// Handles user registration
  Future<void> _onRegister(AuthRegister event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final response = await _apiService.register(
        name: event.name,
        email: event.email,
        password: event.password,
        age: event.age,
      );

      if (response.success && response.data != null) {
        final registerData = response.data!;

        // Emit authenticated state with user data and token
        emit(AuthAuthenticated(
          user: registerData.user
              .toMap(), // Convert to Map for backward compatibility
          token: registerData.token,
        ));

        // Log successful registration for debugging
        _logInfo('User registered successfully: ${registerData.user.email}');
      } else {
        // Handle registration failure
        final errorMessage = response.message ?? AppStrings.registrationFailed;
        emit(AuthError(message: errorMessage));

        _logError('Registration failed: $errorMessage');
      }
    } catch (e) {
      // Handle unexpected errors
      const errorMessage = AppStrings.unexpectedError;
      emit(AuthError(message: errorMessage));

      _logError('Registration error: $e');
    }
  }

  /// Handles user logout
  Future<void> _onLogout(AuthLogout event, Emitter<AuthState> emit) async {
    try {
      // Get current state to extract token if needed
      String? token;
      if (state is AuthAuthenticated) {
        token = (state as AuthAuthenticated).token;
      }

      // Call logout API if token exists
      if (token != null) {
        await _apiService.logout(token);
      }

      // Always emit unauthenticated state (even if API call fails)
      emit(UnauthenticatedState());

      _logInfo('User logged out successfully');
    } catch (e) {
      // Even if logout fails, we should still log out locally
      emit(UnauthenticatedState());

      _logError('Logout error: $e');
    }
  }

  /// Checks authentication status (useful for app startup)
  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // TODO: Implement token storage and validation
      // For now, we'll emit unauthenticated state
      // In a real app, you would:
      // 1. Check if token exists in secure storage
      // 2. Validate token with API
      // 3. Emit appropriate state

      emit(UnauthenticatedState());

      _logInfo('Auth status checked - no stored authentication found');
    } catch (e) {
      emit(UnauthenticatedState());

      _logError('Auth status check error: $e');
    }
  }

  /// Logs info messages for debugging
  void _logInfo(String message) {
    print('[AuthBloc] INFO: $message');
  }

  /// Logs error messages for debugging
  void _logError(String message) {
    print('[AuthBloc] ERROR: $message');
  }

  /// Disposes resources when bloc is closed
  @override
  Future<void> close() {
    _apiService.dispose();
    return super.close();
  }
}
