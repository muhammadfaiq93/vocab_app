abstract class AuthEvent {}

// Check if user is already logged in (on app start)
class AuthCheckStatus extends AuthEvent {}

class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({
    required this.email,
    required this.password,
  });
}

class AuthRegister extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final int age;

  AuthRegister({
    required this.name,
    required this.email,
    required this.password,
    required this.age,
  });
}

class AuthLogout extends AuthEvent {}
