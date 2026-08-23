import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/api_constants.dart';
import '../core/errors/app_exception.dart';
import '../core/providers/storage_provider.dart';
import '../core/subscription_lock_handler.dart';
import 'storage_service.dart';

export '../core/providers/storage_provider.dart' show storageServiceProvider;

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return ApiClient(storage).dio;
});

class ApiClient {
  ApiClient(this._storage) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 90),
        receiveTimeout: const Duration(seconds: 90),
        sendTimeout: const Duration(seconds: 90),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 403) {
            final data = error.response?.data;
            if (data is Map && data['code'] == 'subscription_required') {
              notifySubscriptionLockDetected();
            }
          }
          if (error.response?.statusCode == 401) {
            final refreshed = await _refreshToken();
            if (refreshed) {
              final opts = error.requestOptions;
              opts.headers['Authorization'] = 'Bearer ${await _storage.getAccessToken()}';
              try {
                final response = await dio.fetch(opts);
                return handler.resolve(response);
              } catch (e) {
                return handler.next(error);
              }
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  final StorageService _storage;
  late final Dio dio;

  Future<bool> _refreshToken() async {
    final refresh = await _storage.getRefreshToken();
    if (refresh == null) return false;
    try {
      final response = await Dio().post(
        '${ApiConstants.baseUrl}${ApiConstants.authRefresh}',
        data: {'refresh': refresh},
      );
      final access = response.data['access'] as String?;
      if (access != null) {
        await _storage.saveTokens(access: access, refresh: refresh);
        return true;
      }
    } catch (_) {}
    return false;
  }

  static AppException mapError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const NetworkException(
        'Server is waking up. Please wait a few seconds and try again.',
      );
    }
    final data = e.response?.data;
    if (data is Map) {
      final detail = data['detail'];
      if (detail is String && detail.trim().isNotEmpty) {
        return ServerException(detail, statusCode: e.response?.statusCode);
      }
      final parts = <String>[];
      data.forEach((key, value) {
        if (key == 'detail') return;
        if (value is List && value.isNotEmpty) {
          parts.add(value.first.toString());
        } else if (value is String && value.trim().isNotEmpty) {
          parts.add(value);
        }
      });
      if (parts.isNotEmpty) {
        return ServerException(
          parts.join('\n'),
          statusCode: e.response?.statusCode,
        );
      }
    }
    if (e.response?.statusCode == 400) {
      return ServerException(
        'Please check your booking details and try again.',
        statusCode: 400,
      );
    }
    return ServerException(e.message ?? 'Request failed');
  }
}
