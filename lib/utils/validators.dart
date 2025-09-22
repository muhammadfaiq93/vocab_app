class Validators {
  // Email validation
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;

    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    return emailRegex.hasMatch(email.trim());
  }

  // Password validation
  static bool isValidPassword(String password) {
    if (password.isEmpty) return false;
    return password.length >= 6;
  }

  // Age validation
  static bool isValidAge(int age) {
    return age > 0 && age <= 100;
  }

  // Name validation
  static bool isValidName(String name) {
    if (name.isEmpty) return false;
    return name.trim().length >= 2;
  }

  // General required field validation
  static bool isRequired(String value) {
    return value.trim().isNotEmpty;
  }

  // Phone number validation (optional for future use)
  static bool isValidPhoneNumber(String phone) {
    if (phone.isEmpty) return false;

    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    return phoneRegex.hasMatch(phone.replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }

  // URL validation (optional for future use)
  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;

    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  // Numeric validation
  static bool isNumeric(String value) {
    if (value.isEmpty) return false;
    return double.tryParse(value) != null;
  }

  // Get email error message
  static String? getEmailError(String email) {
    if (email.isEmpty) return 'Email is required';
    if (!isValidEmail(email)) return 'Please enter a valid email address';
    return null;
  }

  // Get password error message
  static String? getPasswordError(String password) {
    if (password.isEmpty) return 'Password is required';
    if (!isValidPassword(password))
      return 'Password must be at least 6 characters';
    return null;
  }

  // Get name error message
  static String? getNameError(String name) {
    if (name.isEmpty) return 'Name is required';
    if (!isValidName(name)) return 'Name must be at least 2 characters';
    return null;
  }

  // Get age error message
  static String? getAgeError(String ageString) {
    if (ageString.isEmpty) return 'Age is required';

    final age = int.tryParse(ageString);
    if (age == null) return 'Please enter a valid number';
    if (!isValidAge(age)) return 'Please enter a valid age (1-100)';

    return null;
  }
}
