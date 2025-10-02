import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyChildId = 'child_id';
  static const String _keyUserName = 'user_name';
  static const String _keyEmail = 'email';
  static const String _keyAuthToken = 'auth_token';

  static SharedPreferences? _preferences;

  // Initialize shared preferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Check if user is logged in
  static bool isLoggedIn() {
    return _preferences?.getBool(_keyIsLoggedIn) ?? false;
  }

  // Save login data
  static Future<bool> saveLoginData({
    required int userId,
    required int childId,
    required String userName,
    required String email,
    String? authToken,
  }) async {
    await _preferences?.setBool(_keyIsLoggedIn, true);
    await _preferences?.setInt(_keyUserId, userId);
    await _preferences?.setInt(_keyChildId, childId);
    await _preferences?.setString(_keyUserName, userName);
    await _preferences?.setString(_keyEmail, email);
    if (authToken != null) {
      await _preferences?.setString(_keyAuthToken, authToken);
    }
    return true;
  }

  // Get user ID
  static int? getUserId() {
    return _preferences?.getInt(_keyUserId);
  }

  // Get child ID
  static int? getChildId() {
    return _preferences?.getInt(_keyChildId);
  }

  // Get user name
  static String? getUserName() {
    return _preferences?.getString(_keyUserName);
  }

  // Get email
  static String? getEmail() {
    return _preferences?.getString(_keyEmail);
  }

  // Get auth token
  static String? getAuthToken() {
    return _preferences?.getString(_keyAuthToken);
  }

  // Clear all login data (logout)
  static Future<bool> clearLoginData() async {
    await _preferences?.remove(_keyIsLoggedIn);
    await _preferences?.remove(_keyUserId);
    await _preferences?.remove(_keyChildId);
    await _preferences?.remove(_keyUserName);
    await _preferences?.remove(_keyEmail);
    await _preferences?.remove(_keyAuthToken);
    return true;
  }

  // Clear all data
  static Future<bool> clearAll() async {
    await _preferences?.clear();
    return true;
  }
}
