import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// Event names matching your screen code
class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  const AuthLogin({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthRegister extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final int age;

  const AuthRegister({
    required this.name,
    required this.email,
    required this.password,
    required this.age,
  });

  @override
  List<Object> get props => [name, email, password, age];
}

class AuthLogout extends AuthEvent {}

// Keep the original names as aliases
class LoginEvent extends AuthLogin {
  const LoginEvent({required String email, required String password})
      : super(email: email, password: password);
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const RegisterEvent({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, password];
}

class LogoutEvent extends AuthLogout {}

class CheckAuthStatusEvent extends AuthEvent {}
