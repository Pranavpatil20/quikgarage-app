import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/api_constants.dart';
import '../core/errors/app_exception.dart';
import 'storage_service.dart';

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return ApiClient(storage).dio;
});

final storageServiceProvider = Provider<StorageService>((ref) => StorageService());

class ApiClient {
  ApiClient(this._storage) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
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
        e.type == DioExceptionType.connectionTimeout) {
      return const NetworkException();
    }
    final data = e.response?.data;
    if (data is Map) {
      final detail = data['detail'] ?? data.values.first;
      return ServerException(
        detail.toString(),
        statusCode: e.response?.statusCode,
      );
    }
    return ServerException(e.message ?? 'Request failed');
  }
}
