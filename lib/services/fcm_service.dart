import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../firebase_options.dart';
import '../models/booking_model.dart';
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
  // System tray shows the FCM payload when the app is backgrounded.
}

class FcmService {
  FcmService(this._userRepo, this._storage);

  final UserRepository _userRepo;
  final StorageService _storage;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'quikgarage_channel';
  static const _channelName = 'QuikGarage Notifications';
  static const _reminderPrefix = 910000;

  bool _ready = false;
  List<int> _lastReminderIds = const [];

  FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  Future<void> initialize() async {
    if (_ready) return;
    try {
      tzdata.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
      await _initLocalNotifications();
      await _requestLocalPermission();

      if (DefaultFirebaseOptions.isConfigured) {
        await _requestFcmPermission();
        FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
        final token = await _messaging.getToken();
        if (token != null) await _syncToken(token);
        _messaging.onTokenRefresh.listen(_syncToken);
        FirebaseMessaging.onMessage.listen(_onForegroundMessage);
        FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpened);
        final initial = await _messaging.getInitialMessage();
        if (initial != null) _onMessageOpened(initial);
      }
      _ready = true;
    } catch (e, st) {
      debugPrint('Notification init failed (non-fatal): $e\n$st');
    }
  }

  Future<void> syncAfterAuth() async {
    await initialize();
    if (!DefaultFirebaseOptions.isConfigured) return;
    try {
      final token = await _messaging.getToken();
      if (token != null) await _syncToken(token);
    } catch (e) {
      debugPrint('FCM token sync failed: $e');
    }
  }

  /// Outside-app reminder 3 months after a completed service.
  Future<void> syncServiceReminders(List<BookingModel> bookings) async {
    final ids = bookings
        .where((b) => b.status == 'completed')
        .map((b) => b.id)
        .toList()
      ..sort();
    if (listEquals(ids, _lastReminderIds)) {
      return;
    }
    _lastReminderIds = ids;
    await initialize();
    for (final booking in bookings) {
      if (booking.status != 'completed') continue;
      final completed = booking.completedAt ?? booking.updatedAt ?? booking.createdAt;
      if (completed == null) continue;
      await _scheduleServiceReminder(
        bookingId: booking.id,
        completedAt: completed.toLocal(),
        vehicleLabel: booking.vehicleDetail?.vehicleNumber ?? 'your vehicle',
      );
    }
  }

  Future<void> _scheduleServiceReminder({
    required int bookingId,
    required DateTime completedAt,
    required String vehicleLabel,
  }) async {
    final fireAt = completedAt.add(const Duration(days: 90));
    if (!fireAt.isAfter(DateTime.now())) return;

    final id = _reminderPrefix + (bookingId % 80000);
    await _localNotifications.zonedSchedule(
      id,
      'Time for a service',
      'It has been 3 months since $vehicleLabel was serviced. Book your next visit with QuikGarage.',
      tz.TZDateTime.from(fireAt, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: 'Booking updates and service reminders',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> showLocal({required String title, required String body}) async {
    await initialize();
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: 'Booking updates and service reminders',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> _requestLocalPermission() async {
    final android = _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
    if (Platform.isIOS) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  Future<void> _requestFcmPermission() async {
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
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: 'Booking updates and service reminders',
        importance: Importance.high,
      ),
    );
  }

  Future<void> _syncToken(String token) async {
    final loggedIn = await _storage.getAccessToken();
    if (loggedIn == null || loggedIn.isEmpty) return;
    try {
      await _userRepo.updateProfile(fcmToken: token);
    } catch (_) {}
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    final title = notification?.title ?? message.data['title'] as String?;
    final body = notification?.body ?? message.data['message'] as String?;
    if (title == null && body == null) return;
    await showLocal(title: title ?? 'QuikGarage', body: body ?? '');
  }

  void _onMessageOpened(RemoteMessage message) {
    debugPrint('Notification opened: ${message.data}');
  }
}
