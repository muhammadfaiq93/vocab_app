import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {}

// Names matching your screen code
class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final Map<String, dynamic> user;
  final String token;

  const AuthAuthenticated({required this.user, required this.token});

  @override
  List<Object> get props => [user, token];
}

class UnauthenticatedState extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

// Keep aliases for backward compatibility
class AuthLoadingState extends AuthLoading {}

class AuthenticatedState extends AuthAuthenticated {
  const AuthenticatedState(
      {required Map<String, dynamic> user, required String token})
      : super(user: user, token: token);
}

class AuthErrorState extends AuthError {
  const AuthErrorState({required String message}) : super(message: message);
}
