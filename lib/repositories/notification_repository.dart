import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/api_constants.dart';
import '../models/notification_model.dart';
import '../services/api_client.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(ref.watch(dioProvider));
});

class NotificationRepository {
  NotificationRepository(this._dio);

  final Dio _dio;

  Future<List<NotificationModel>> getNotifications() async {
    final response = await _dio.get(
      ApiConstants.notifications,
      queryParameters: {'page_size': 100},
    );
    final data = response.data;
    if (data is Map && data['results'] is List) {
      return (data['results'] as List)
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (data is List) {
      return data.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<void> markRead(int id) async {
    await _dio.post(ApiConstants.notificationRead(id));
  }

  Future<void> markAllRead() async {
    await _dio.post(ApiConstants.notificationsReadAll);
  }
}
