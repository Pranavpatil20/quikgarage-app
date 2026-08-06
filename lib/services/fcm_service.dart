import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase_options.dart';
import '../repositories/user_repository.dart';
import 'api_client.dart';
import 'storage_service.dart';

final fcmServiceProvider = Provider<FcmService>((ref) {
  return FcmService(
    ref.watch(userRepositoryProvider),
    ref.watch(storageServiceProvider),
  );
});

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages
}

class FcmService {
  FcmService(this._userRepo, this._storage);

  final UserRepository _userRepo;
  final StorageService _storage;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  Future<void> initialize() async {
    if (!DefaultFirebaseOptions.isConfigured) {
      debugPrint('FCM skipped: Firebase not configured (run flutterfire configure)');
      return;
    }

    try {
      await _requestPermission();
      await _initLocalNotifications();

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      final token = await _messaging.getToken();
      if (token != null) {
        await _syncToken(token);
      }

      _messaging.onTokenRefresh.listen(_syncToken);

      FirebaseMessaging.onMessage.listen(_onForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpened);
    } catch (e, st) {
      debugPrint('FCM init failed (non-fatal): $e\n$st');
    }
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _localNotifications.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
  }

  Future<void> _syncToken(String token) async {
    final loggedIn = await _storage.getAccessToken();
    if (loggedIn != null) {
      try {
        await _userRepo.updateProfile(fcmToken: token);
      } catch (_) {}
    }
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'quikgarage_channel',
          'QuikGarage Notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  void _onMessageOpened(RemoteMessage message) {
    // Navigation handled by app router based on message.data
  }
}
