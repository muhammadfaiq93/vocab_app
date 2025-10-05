class SettingsResponse {
  final bool success;
  final String message;
  final AppSettings data;

  SettingsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SettingsResponse.fromJson(Map<String, dynamic> json) {
    return SettingsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: AppSettings.fromJson(json['data'] ?? {}),
    );
  }
}

class AppSettings {
  final AppInfo appInfo;
  final ApiConfig apiConfig;
  final VocabularyFeatures vocabularyFeatures;
  final LearningSettings learningSettings;
  final UiPreferences uiPreferences;
  final NotificationSettings notifications;
  final Analytics analytics;
  final Subscription subscription;
  final Social social;
  final Ads ads;
  final Support support;
  final ContentUpdates contentUpdates;

  AppSettings({
    required this.appInfo,
    required this.apiConfig,
    required this.vocabularyFeatures,
    required this.learningSettings,
    required this.uiPreferences,
    required this.notifications,
    required this.analytics,
    required this.subscription,
    required this.social,
    required this.ads,
    required this.support,
    required this.contentUpdates,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      appInfo: AppInfo.fromJson(json['app_info'] ?? {}),
      apiConfig: ApiConfig.fromJson(json['api_config'] ?? {}),
      vocabularyFeatures: VocabularyFeatures.fromJson(json['vocabulary_features'] ?? {}),
      learningSettings: LearningSettings.fromJson(json['learning_settings'] ?? {}),
      uiPreferences: UiPreferences.fromJson(json['ui_preferences'] ?? {}),
      notifications: NotificationSettings.fromJson(json['notifications'] ?? {}),
      analytics: Analytics.fromJson(json['analytics'] ?? {}),
      subscription: Subscription.fromJson(json['subscription'] ?? {}),
      social: Social.fromJson(json['social'] ?? {}),
      ads: Ads.fromJson(json['ads'] ?? {}),
      support: Support.fromJson(json['support'] ?? {}),
      contentUpdates: ContentUpdates.fromJson(json['content_updates'] ?? {}),
    );
  }
}

class AppInfo {
  final String appName;
  final String appVersionIos;
  final String appVersionAndroid;
  final String appBuildIos;
  final String appBuildAndroid;
  final String minRequiredVersionIos;
  final String minRequiredVersionAndroid;
  final bool forceUpdate;
  final bool maintenanceMode;
  final String maintenanceMessage;

  AppInfo({
    required this.appName,
    required this.appVersionIos,
    required this.appVersionAndroid,
    required this.appBuildIos,
    required this.appBuildAndroid,
    required this.minRequiredVersionIos,
    required this.minRequiredVersionAndroid,
    required this.forceUpdate,
    required this.maintenanceMode,
    required this.maintenanceMessage,
  });

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      appName: json['app_name'] ?? '',
      appVersionIos: json['app_version_ios'] ?? '',
      appVersionAndroid: json['app_version_android'] ?? '',
      appBuildIos: json['app_build_ios'] ?? '',
      appBuildAndroid: json['app_build_android'] ?? '',
      minRequiredVersionIos: json['min_required_version_ios'] ?? '',
      minRequiredVersionAndroid: json['min_required_version_android'] ?? '',
      forceUpdate: json['force_update'] ?? false,
      maintenanceMode: json['maintenance_mode'] ?? false,
      maintenanceMessage: json['maintenance_message'] ?? '',
    );
  }
}

class ApiConfig {
  final String apiBaseUrl;
  final int apiTimeout;
  final int apiRetryAttempts;
  final String apiVersion;
  final int cacheDuration;

  ApiConfig({
    required this.apiBaseUrl,
    required this.apiTimeout,
    required this.apiRetryAttempts,
    required this.apiVersion,
    required this.cacheDuration,
  });

  factory ApiConfig.fromJson(Map<String, dynamic> json) {
    return ApiConfig(
      apiBaseUrl: json['api_base_url'] ?? '',
      apiTimeout: json['api_timeout'] ?? 30,
      apiRetryAttempts: json['api_retry_attempts'] ?? 3,
      apiVersion: json['api_version'] ?? 'v1',
      cacheDuration: json['cache_duration'] ?? 3600,
    );
  }
}

class VocabularyFeatures {
  final bool wordOfTheDayEnabled;
  final bool dailyReminderEnabled;
  final String defaultReminderTime;
  final bool quizModeEnabled;
  final bool flashcardEnabled;
  final bool pronunciationEnabled;
  final bool exampleSentencesEnabled;
  final bool synonymsAntonymsEnabled;
  final bool wordEtymologyEnabled;
  final bool offlineModeEnabled;
  final bool favoritesEnabled;
  final bool historyTrackingEnabled;

  VocabularyFeatures({
    required this.wordOfTheDayEnabled,
    required this.dailyReminderEnabled,
    required this.defaultReminderTime,
    required this.quizModeEnabled,
    required this.flashcardEnabled,
    required this.pronunciationEnabled,
    required this.exampleSentencesEnabled,
    required this.synonymsAntonymsEnabled,
    required this.wordEtymologyEnabled,
    required this.offlineModeEnabled,
    required this.favoritesEnabled,
    required this.historyTrackingEnabled,
  });

  factory VocabularyFeatures.fromJson(Map<String, dynamic> json) {
    return VocabularyFeatures(
      wordOfTheDayEnabled: json['word_of_the_day_enabled'] ?? true,
      dailyReminderEnabled: json['daily_reminder_enabled'] ?? true,
      defaultReminderTime: json['default_reminder_time'] ?? '09:00',
      quizModeEnabled: json['quiz_mode_enabled'] ?? true,
      flashcardEnabled: json['flashcard_enabled'] ?? true,
      pronunciationEnabled: json['pronunciation_enabled'] ?? true,
      exampleSentencesEnabled: json['example_sentences_enabled'] ?? true,
      synonymsAntonymsEnabled: json['synonyms_antonyms_enabled'] ?? true,
      wordEtymologyEnabled: json['word_etymology_enabled'] ?? true,
      offlineModeEnabled: json['offline_mode_enabled'] ?? true,
      favoritesEnabled: json['favorites_enabled'] ?? true,
      historyTrackingEnabled: json['history_tracking_enabled'] ?? true,
    );
  }
}

class LearningSettings {
  final List<String> difficultyLevels;
  final String defaultDifficulty;
  final int wordsPerLesson;
  final List<String> categories;
  final String defaultCategory;
  final bool spacedRepetitionEnabled;
  final bool gamificationEnabled;

  LearningSettings({
    required this.difficultyLevels,
    required this.defaultDifficulty,
    required this.wordsPerLesson,
    required this.categories,
    required this.defaultCategory,
    required this.spacedRepetitionEnabled,
    required this.gamificationEnabled,
  });

  factory LearningSettings.fromJson(Map<String, dynamic> json) {
    return LearningSettings(
      difficultyLevels: List<String>.from(json['difficulty_levels'] ?? []),
      defaultDifficulty: json['default_difficulty'] ?? 'intermediate',
      wordsPerLesson: json['words_per_lesson'] ?? 10,
      categories: List<String>.from(json['categories'] ?? []),
      defaultCategory: json['default_category'] ?? 'general',
      spacedRepetitionEnabled: json['spaced_repetition_enabled'] ?? true,
      gamificationEnabled: json['gamification_enabled'] ?? true,
    );
  }
}

class UiPreferences {
  final bool darkModeEnabled;
  final String defaultTheme;
  final List<String> languageOptions;
  final String defaultLanguage;
  final List<String> fontSizeOptions;
  final String defaultFontSize;
  final bool animationsEnabled;

  UiPreferences({
    required this.darkModeEnabled,
    required this.defaultTheme,
    required this.languageOptions,
    required this.defaultLanguage,
    required this.fontSizeOptions,
    required this.defaultFontSize,
    required this.animationsEnabled,
  });

  factory UiPreferences.fromJson(Map<String, dynamic> json) {
    return UiPreferences(
      darkModeEnabled: json['dark_mode_enabled'] ?? true,
      defaultTheme: json['default_theme'] ?? 'auto',
      languageOptions: List<String>.from(json['language_options'] ?? []),
      defaultLanguage: json['default_language'] ?? 'en',
      fontSizeOptions: List<String>.from(json['font_size_options'] ?? []),
      defaultFontSize: json['default_font_size'] ?? 'medium',
      animationsEnabled: json['animations_enabled'] ?? true,
    );
  }
}

class NotificationSettings {
  final bool pushNotificationsEnabled;
  final bool dailyReminder;
  final bool weeklyProgressReport;
  final bool achievementNotifications;
  final bool newContentAlerts;
  final bool studyStreakReminders;

  NotificationSettings({
    required this.pushNotificationsEnabled,
    required this.dailyReminder,
    required this.weeklyProgressReport,
    required this.achievementNotifications,
    required this.newContentAlerts,
    required this.studyStreakReminders,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      pushNotificationsEnabled: json['push_notifications_enabled'] ?? true,
      dailyReminder: json['daily_reminder'] ?? true,
      weeklyProgressReport: json['weekly_progress_report'] ?? true,
      achievementNotifications: json['achievement_notifications'] ?? true,
      newContentAlerts: json['new_content_alerts'] ?? true,
      studyStreakReminders: json['study_streak_reminders'] ?? true,
    );
  }
}

class Analytics {
  final bool analyticsEnabled;
  final bool crashlyticsEnabled;
  final bool performanceMonitoring;

  Analytics({
    required this.analyticsEnabled,
    required this.crashlyticsEnabled,
    required this.performanceMonitoring,
  });

  factory Analytics.fromJson(Map<String, dynamic> json) {
    return Analytics(
      analyticsEnabled: json['analytics_enabled'] ?? true,
      crashlyticsEnabled: json['crashlytics_enabled'] ?? true,
      performanceMonitoring: json['performance_monitoring'] ?? true,
    );
  }
}

class Subscription {
  final int freeTierWordLimit;
  final List<String> premiumFeatures;
  final int trialPeriodDays;

  Subscription({
    required this.freeTierWordLimit,
    required this.premiumFeatures,
    required this.trialPeriodDays,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      freeTierWordLimit: json['free_tier_word_limit'] ?? 50,
      premiumFeatures: List<String>.from(json['premium_features'] ?? []),
      trialPeriodDays: json['trial_period_days'] ?? 7,
    );
  }
}

class Social {
  final bool shareEnabled;
  final bool leaderboardEnabled;
  final bool friendChallengesEnabled;

  Social({
    required this.shareEnabled,
    required this.leaderboardEnabled,
    required this.friendChallengesEnabled,
  });

  factory Social.fromJson(Map<String, dynamic> json) {
    return Social(
      shareEnabled: json['share_enabled'] ?? true,
      leaderboardEnabled: json['leaderboard_enabled'] ?? true,
      friendChallengesEnabled: json['friend_challenges_enabled'] ?? false,
    );
  }
}

class Ads {
  final bool adsEnabled;
  final bool bannerAds;
  final bool interstitialAds;
  final bool rewardedAds;
  final bool adFreeForPremium;

  Ads({
    required this.adsEnabled,
    required this.bannerAds,
    required this.interstitialAds,
    required this.rewardedAds,
    required this.adFreeForPremium,
  });

  factory Ads.fromJson(Map<String, dynamic> json) {
    return Ads(
      adsEnabled: json['ads_enabled'] ?? true,
      bannerAds: json['banner_ads'] ?? true,
      interstitialAds: json['interstitial_ads'] ?? true,
      rewardedAds: json['rewarded_ads'] ?? true,
      adFreeForPremium: json['ad_free_for_premium'] ?? true,
    );
  }
}

class Support {
  final String supportEmail;
  final String supportPhone;
  final String helpUrl;
  final String faqUrl;
  final String privacyPolicyUrl;
  final String termsOfServiceUrl;
  final String contactFormUrl;
  final bool feedbackEnabled;

  Support({
    required this.supportEmail,
    required this.supportPhone,
    required this.helpUrl,
    required this.faqUrl,
    required this.privacyPolicyUrl,
    required this.termsOfServiceUrl,
    required this.contactFormUrl,
    required this.feedbackEnabled,
  });

  factory Support.fromJson(Map<String, dynamic> json) {
    return Support(
      supportEmail: json['support_email'] ?? '',
      supportPhone: json['support_phone'] ?? '',
      helpUrl: json['help_url'] ?? '',
      faqUrl: json['faq_url'] ?? '',
      privacyPolicyUrl: json['privacy_policy_url'] ?? '',
      termsOfServiceUrl: json['terms_of_service_url'] ?? '',
      contactFormUrl: json['contact_form_url'] ?? '',
      feedbackEnabled: json['feedback_enabled'] ?? true,
    );
  }
}

class ContentUpdates {
  final String lastContentUpdate;
  final String nextScheduledUpdate;
  final bool autoDownloadUpdates;

  ContentUpdates({
    required this.lastContentUpdate,
    required this.nextScheduledUpdate,
    required this.autoDownloadUpdates,
  });

  factory ContentUpdates.fromJson(Map<String, dynamic> json) {
    return ContentUpdates(
      lastContentUpdate: json['last_content_update'] ?? '',
      nextScheduledUpdate: json['next_scheduled_update'] ?? '',
      autoDownloadUpdates: json['auto_download_updates'] ?? true,
    );
  }
}