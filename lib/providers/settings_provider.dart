import 'package:flutter/foundation.dart';
import '../models/settings.dart';
import '../services/settings_service.dart';

class SettingsProvider with ChangeNotifier {
  final SettingsService _settingsService = SettingsService();

  AppSettings? _settings;
  bool _isLoading = false;
  String? _error;

  AppSettings? get settings => _settings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Convenience getters
  bool get isMaintenanceMode => _settings?.appInfo.maintenanceMode ?? false;
  bool get forceUpdate => _settings?.appInfo.forceUpdate ?? false;
  bool get darkModeEnabled => _settings?.uiPreferences.darkModeEnabled ?? false;
  bool get notificationsEnabled =>
      _settings?.notifications.pushNotificationsEnabled ?? true;
  bool get wordOfTheDayEnabled =>
      _settings?.vocabularyFeatures.wordOfTheDayEnabled ?? true;
  bool get adsEnabled => _settings?.ads.adsEnabled ?? true;

  /// Initialize and load settings
  Future<void> initialize() async {
    await loadSettings();
  }

  /// Load settings from API
  Future<void> loadSettings({bool forceRefresh = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _settings =
          await _settingsService.fetchSettings(forceRefresh: forceRefresh);
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading settings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh settings from server
  Future<void> refreshSettings() async {
    await loadSettings(forceRefresh: true);
  }

  /// Clear cached settings
  Future<void> clearCache() async {
    await _settingsService.clearCache();
    _settings = null;
    notifyListeners();
  }

  /// Check if feature is enabled
  bool isFeatureEnabled(String featureName) {
    switch (featureName) {
      case 'word_of_the_day':
        return _settings?.vocabularyFeatures.wordOfTheDayEnabled ?? false;
      case 'quiz_mode':
        return _settings?.vocabularyFeatures.quizModeEnabled ?? false;
      case 'flashcard':
        return _settings?.vocabularyFeatures.flashcardEnabled ?? false;
      case 'pronunciation':
        return _settings?.vocabularyFeatures.pronunciationEnabled ?? false;
      case 'offline_mode':
        return _settings?.vocabularyFeatures.offlineModeEnabled ?? false;
      case 'gamification':
        return _settings?.learningSettings.gamificationEnabled ?? false;
      case 'leaderboard':
        return _settings?.social.leaderboardEnabled ?? false;
      default:
        return false;
    }
  }

  /// Get API configuration
  String getApiBaseUrl() {
    return _settings?.apiConfig.apiBaseUrl ?? '';
  }

  int getApiTimeout() {
    return _settings?.apiConfig.apiTimeout ?? 30;
  }

  /// Get support URLs
  String getPrivacyPolicyUrl() {
    return _settings?.support.privacyPolicyUrl ?? '';
  }

  String getTermsOfServiceUrl() {
    return _settings?.support.termsOfServiceUrl ?? '';
  }

  String getHelpUrl() {
    return _settings?.support.helpUrl ?? '';
  }

  String getSupportEmail() {
    return _settings?.support.supportEmail ?? '';
  }

  /// Check version and maintenance
  Future<bool> needsUpdate(String currentVersion, String platform) async {
    return await _settingsService.needsUpdate(currentVersion, platform);
  }

  Future<bool> checkMaintenanceMode() async {
    return await _settingsService.isInMaintenanceMode();
  }
}
