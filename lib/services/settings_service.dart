import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings.dart';

class SettingsService {
  static const String _cacheKey = 'app_settings_cache';
  static const String _cacheTimeKey = 'app_settings_cache_time';

  // Replace with your actual API URL
  static const String _apiUrl =
      'https://appapi.tutorselevenplus.co.uk/api/settings';

  /// Fetch settings from API with caching
  Future<AppSettings?> fetchSettings({bool forceRefresh = false}) async {
    try {
      // Check cache first if not forcing refresh
      if (!forceRefresh) {
        final cachedSettings = await _getCachedSettings();
        if (cachedSettings != null) {
          return cachedSettings;
        }
      }

      // Fetch from API
      final response = await http.get(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Connection timeout');
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final settingsResponse = SettingsResponse.fromJson(jsonData);

        if (settingsResponse.success) {
          // Cache the settings
          await _cacheSettings(response.body);
          return settingsResponse.data;
        } else {
          throw Exception(
              'Failed to load settings: ${settingsResponse.message}');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching settings: $e');

      // Try to return cached settings on error
      final cachedSettings = await _getCachedSettings();
      if (cachedSettings != null) {
        return cachedSettings;
      }

      rethrow;
    }
  }

  /// Cache settings locally
  Future<void> _cacheSettings(String jsonData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, jsonData);
      await prefs.setInt(_cacheTimeKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Error caching settings: $e');
    }
  }

  /// Get cached settings if valid
  Future<AppSettings?> _getCachedSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_cacheKey);
      final cacheTime = prefs.getInt(_cacheTimeKey);

      if (cachedData != null && cacheTime != null) {
        // Check if cache is still valid (1 hour)
        final cacheAge = DateTime.now().millisecondsSinceEpoch - cacheTime;
        final cacheValidDuration = const Duration(hours: 1).inMilliseconds;

        if (cacheAge < cacheValidDuration) {
          final jsonData = json.decode(cachedData);
          final settingsResponse = SettingsResponse.fromJson(jsonData);
          return settingsResponse.data;
        }
      }
    } catch (e) {
      print('Error reading cached settings: $e');
    }
    return null;
  }

  /// Clear cached settings
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
      await prefs.remove(_cacheTimeKey);
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  /// Check if app needs update
  Future<bool> needsUpdate(String currentVersion, String platform) async {
    try {
      final settings = await fetchSettings();
      if (settings == null) return false;

      final minVersion = platform == 'ios'
          ? settings.appInfo.minRequiredVersionIos
          : settings.appInfo.minRequiredVersionAndroid;

      return _compareVersions(currentVersion, minVersion) < 0;
    } catch (e) {
      print('Error checking update: $e');
      return false;
    }
  }

  /// Check if app is in maintenance mode
  Future<bool> isInMaintenanceMode() async {
    try {
      final settings = await fetchSettings(forceRefresh: true);
      return settings?.appInfo.maintenanceMode ?? false;
    } catch (e) {
      print('Error checking maintenance mode: $e');
      return false;
    }
  }

  /// Compare version strings (e.g., "1.0.0" vs "1.0.1")
  int _compareVersions(String v1, String v2) {
    final parts1 = v1.split('.').map(int.parse).toList();
    final parts2 = v2.split('.').map(int.parse).toList();

    for (int i = 0; i < 3; i++) {
      final p1 = i < parts1.length ? parts1[i] : 0;
      final p2 = i < parts2.length ? parts2[i] : 0;

      if (p1 < p2) return -1;
      if (p1 > p2) return 1;
    }
    return 0;
  }
}
