import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';

// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling background message: ${message.messageId}');
}

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  // Initialize Firebase - this should be called AFTER Firebase.initializeApp()
  Future<void> initialize() async {
    try {
      // Register background handler
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      // Request permissions
      await _requestPermissions();

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Get FCM token
      await _getFCMToken();

      // Listen to token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        print('FCM Token refreshed: $newToken');
        _sendTokenToBackend(newToken);
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle notification taps
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Check if app was opened from a notification
      RemoteMessage? initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }

      print('Firebase Service initialized successfully');
    } catch (e) {
      print('Error initializing Firebase Service: $e');
      rethrow;
    }
  }

  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    print('Notification permission: ${settings.authorizationStatus}');
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('Notification tapped: ${response.payload}');
      },
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  Future<void> _getFCMToken() async {
    try {
      _fcmToken = await _messaging.getToken();
      print('FCM Token: $_fcmToken');

      if (_fcmToken != null) {
        await _sendTokenToBackend(_fcmToken!);
      }
    } catch (e) {
      print('Error getting FCM token: $e');
    }
  }

  Future<void> _sendTokenToBackend(String token) async {
    try {
      // TODO: Implement your API call
      print('Token to send to backend: $token');
      // await ApiService().saveFCMToken(token: token);
    } catch (e) {
      print('Error sending token to backend: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print('Foreground message: ${message.notification?.title}');

    if (message.notification != null) {
      _showLocalNotification(message);
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      details,
      payload: message.data.toString(),
    );
  }

  void _handleNotificationTap(RemoteMessage message) {
    print('Notification tapped: ${message.notification?.title}');

    if (message.data.containsKey('route')) {
      print('Navigate to: ${message.data['route']}');
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    print('Subscribed to topic: $topic');
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    print('Unsubscribed from topic: $topic');
  }
}
