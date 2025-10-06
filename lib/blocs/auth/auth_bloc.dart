import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService _apiService;
  final StorageService _storageService;

  AuthBloc({
    required ApiService apiService,
    required StorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService,
        super(AuthInitial()) {
    on<AuthCheckStatus>(_onCheckStatus);
    on<AuthLogin>(_onLogin);
    on<AuthRegister>(_onRegister);
    on<AuthLogout>(_onLogout);
  }

  // Check if user is already logged in
  Future<void> _onCheckStatus(
    AuthCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    await _storageService.initialize();

    if (_storageService.isLoggedIn &&
        _storageService.currentUser != null &&
        _storageService.authToken != null) {
      emit(AuthAuthenticated(
        user: _storageService.currentUser!,
        token: _storageService.authToken!,
      ));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  // Handle login
  Future<void> _onLogin(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final response =
          await _apiService.login(email: event.email, password: event.password);

      if (response.success && response.data != null) {
        // Save to storage for persistence
        await _storageService.saveLoginData(
          response.data!.user,
          response.data!.token,
        );

        emit(AuthAuthenticated(
          user: response.data!.user,
          token: response.data!.token,
        ));
      } else {
        emit(AuthError(response.message ?? 'Login failed'));
      }
    } catch (e) {
      emit(AuthError('An error occurred: ${e.toString()}'));
    }
  }

  // Handle registration
  Future<void> _onRegister(
    AuthRegister event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final response = await _apiService.register(
        name: event.name,
        email: event.email,
        password: event.password,
        age: event.age,
      );

      if (response.success && response.data != null) {
        // Save to storage for persistence
        await _storageService.saveLoginData(
          response.data!.user,
          response.data!.token,
        );

        emit(AuthAuthenticated(
          user: response.data!.user,
          token: response.data!.token,
        ));
      } else {
        emit(AuthError(response.message ?? 'Registration failed'));
      }
    } catch (e) {
      emit(AuthError('An error occurred: ${e.toString()}'));
    }
  }

  // Handle logout
  Future<void> _onLogout(
    AuthLogout event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final token = _storageService.authToken;

      // Call API logout
      if (token != null) {
        await _apiService.logout(token);
      }

      // Clear storage
      await _storageService.clearLoginData();

      emit(AuthUnauthenticated());
    } catch (e) {
      // Even if API fails, still logout locally
      await _storageService.clearLoginData();
      emit(AuthUnauthenticated());
    }
  }
}
