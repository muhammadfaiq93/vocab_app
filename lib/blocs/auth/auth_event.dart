abstract class AuthEvent {
  const AuthEvent();
}

class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  const AuthLogin({
    required this.email,
    required this.password,
  });

  @override
  String toString() => 'AuthLogin { email: $email }';
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
  String toString() => 'AuthRegister { name: $name, email: $email, age: $age }';
}

class AuthLogout extends AuthEvent {
  const AuthLogout();

  @override
  String toString() => 'AuthLogout';
}

class AuthCheckStatus extends AuthEvent {
  const AuthCheckStatus();

  @override
  String toString() => 'AuthCheckStatus';
}

class AuthRefreshToken extends AuthEvent {
  const AuthRefreshToken();

  @override
  String toString() => 'AuthRefreshToken';
}

class AuthUpdateProfile extends AuthEvent {
  final Map<String, dynamic> profileData;

  const AuthUpdateProfile({
    required this.profileData,
  });

  @override
  String toString() => 'AuthUpdateProfile { profileData: $profileData }';
}

class AuthChangePassword extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  const AuthChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  String toString() => 'AuthChangePassword';
}

class AuthForgotPassword extends AuthEvent {
  final String email;

  const AuthForgotPassword({
    required this.email,
  });

  @override
  String toString() => 'AuthForgotPassword { email: $email }';
}

class AuthResetPassword extends AuthEvent {
  final String token;
  final String email;
  final String password;

  const AuthResetPassword({
    required this.token,
    required this.email,
    required this.password,
  });

  @override
  String toString() => 'AuthResetPassword { email: $email }';
}
