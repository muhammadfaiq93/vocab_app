import 'package:equatable/equatable.dart';
import '../../models/child_user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  String toString() => 'AuthInitial';
}

class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  String toString() => 'AuthLoading';
}

class AuthAuthenticated extends AuthState {
  final ChildUser user;
  final String token;

  const AuthAuthenticated({
    required this.user,
    required this.token,
  });

  @override
  List<Object?> get props => [user, token];

  @override
  String toString() => 'AuthAuthenticated { user: ${user.name} }';

  AuthAuthenticated copyWith({
    ChildUser? user,
    String? token,
  }) {
    return AuthAuthenticated(
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();

  @override
  String toString() => 'AuthUnauthenticated';
}

class AuthError extends AuthState {
  final String message;
  final String? errorCode;
  final DateTime timestamp;

  AuthError({
    required this.message,
    this.errorCode,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? _CurrentDateTime();

  @override
  List<Object?> get props => [message, errorCode, timestamp];

  @override
  String toString() => 'AuthError { message: $message, errorCode: $errorCode }';
}

class AuthLoginLoading extends AuthState {
  const AuthLoginLoading();

  @override
  String toString() => 'AuthLoginLoading';
}

class AuthRegisterLoading extends AuthState {
  const AuthRegisterLoading();

  @override
  String toString() => 'AuthRegisterLoading';
}

class AuthProfileUpdateLoading extends AuthState {
  final ChildUser currentUser;

  const AuthProfileUpdateLoading({
    required this.currentUser,
  });

  @override
  List<Object?> get props => [currentUser];

  @override
  String toString() => 'AuthProfileUpdateLoading';
}

class AuthProfileUpdated extends AuthState {
  final ChildUser user;
  final String successMessage;

  const AuthProfileUpdated({
    required this.user,
    required this.successMessage,
  });

  @override
  List<Object?> get props => [user, successMessage];

  @override
  String toString() => 'AuthProfileUpdated { user: ${user.name} }';
}

class AuthPasswordChangeLoading extends AuthState {
  const AuthPasswordChangeLoading();

  @override
  String toString() => 'AuthPasswordChangeLoading';
}

class AuthPasswordChanged extends AuthState {
  final String successMessage;

  const AuthPasswordChanged({
    required this.successMessage,
  });

  @override
  List<Object?> get props => [successMessage];

  @override
  String toString() => 'AuthPasswordChanged { message: $successMessage }';
}

class AuthForgotPasswordLoading extends AuthState {
  const AuthForgotPasswordLoading();

  @override
  String toString() => 'AuthForgotPasswordLoading';
}

class AuthForgotPasswordSent extends AuthState {
  final String email;
  final String message;

  const AuthForgotPasswordSent({
    required this.email,
    required this.message,
  });

  @override
  List<Object?> get props => [email, message];

  @override
  String toString() => 'AuthForgotPasswordSent { email: $email }';
}

class AuthResetPasswordLoading extends AuthState {
  const AuthResetPasswordLoading();

  @override
  String toString() => 'AuthResetPasswordLoading';
}

class AuthResetPasswordSuccess extends AuthState {
  final String message;

  const AuthResetPasswordSuccess({
    required this.message,
  });

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'AuthResetPasswordSuccess { message: $message }';
}

class AuthTokenExpired extends AuthState {
  const AuthTokenExpired();

  @override
  String toString() => 'AuthTokenExpired';
}

class AuthRefreshingToken extends AuthState {
  const AuthRefreshingToken();

  @override
  String toString() => 'AuthRefreshingToken';
}

// Helper class for default DateTime
class _CurrentDateTime extends DateTime {
  _CurrentDateTime() : super.now();
}
