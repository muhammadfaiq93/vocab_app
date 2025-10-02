import 'package:shared_preferences/shared_preferences.dart';
import '../models/child_user.dart';

class StorageService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserAge = 'user_age';
  static const String _keyUserAvatar = 'user_avatar';
  static const String _keyAuthToken = 'auth_token';

  // Singleton
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // Cached data
  bool _isLoggedIn = false;
  ChildUser? _currentUser;
  String? _authToken;

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  ChildUser? get currentUser => _currentUser;
  String? get authToken => _authToken;
  int? get userId => _currentUser?.id;
  String? get userAvatar => _currentUser?.avatar;

  // Initialize - Load saved data
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    _isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    _authToken = prefs.getString(_keyAuthToken);

    if (_isLoggedIn) {
      // Reconstruct user object from saved data
      final userId = prefs.getInt(_keyUserId);
      final userName = prefs.getString(_keyUserName);
      final userEmail = prefs.getString(_keyUserEmail);
      final userAge = prefs.getInt(_keyUserAge);
      final userAvatar = prefs.getString(_keyUserAvatar);

      if (userId != null && userName != null && userEmail != null) {
        _currentUser = ChildUser(
          id: userId,
          name: userName,
          email: userEmail,
          age: userAge ?? 0,
          avatar: userAvatar,
        );
      }
    }
  }

  // Save login data after successful login
  Future<void> saveLoginData(ChildUser user, String token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setInt(_keyUserId, user.id);
    await prefs.setString(_keyUserName, user.name);
    await prefs.setString(_keyUserEmail, user.email);
    await prefs.setInt(_keyUserAge, user.age!);
    if (user.avatar != null) {
      await prefs.setString(_keyUserAvatar, user.avatar!);
    }
    await prefs.setString(_keyAuthToken, token);

    // Update cached values
    _isLoggedIn = true;
    _currentUser = user;
    _authToken = token;
  }

  // Clear all data on logout
  Future<void> clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    _isLoggedIn = false;
    _currentUser = null;
    _authToken = null;
  }

  // Check if token exists
  bool hasValidToken() {
    return _authToken != null && _authToken!.isNotEmpty;
  }
}
