import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/api_constants.dart';
import '../models/user_model.dart';
import '../services/api_client.dart';
import '../services/storage_service.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(dioProvider), ref.watch(storageServiceProvider));
});

class UserRepository {
  UserRepository(this._dio, this._storage);

  final Dio _dio;
  final StorageService _storage;

  Future<UserModel> getMe() async {
    final response = await _dio.get(ApiConstants.usersMe);
    final user = UserModel.fromJson(response.data as Map<String, dynamic>);
    await _storage.saveUser(user);
    return user;
  }

  Future<UserModel> updateProfile({String? name, String? fcmToken}) async {
    final response = await _dio.patch(
      ApiConstants.usersMe,
      data: {
        if (name != null) 'name': name,
        if (fcmToken != null) 'fcm_token': fcmToken,
      },
    );
    final user = UserModel.fromJson(response.data as Map<String, dynamic>);
    await _storage.saveUser(user);
    return user;
  }

  Future<UserModel> setRole(String role) async {
    final response = await _dio.post(ApiConstants.usersRole, data: {'role': role});
    final user = UserModel.fromJson(response.data as Map<String, dynamic>);
    await _storage.saveUser(user);
    return user;
  }

  Future<List<UserModel>> getCustomers() async {
    final response = await _dio.get(ApiConstants.usersCustomers);
    final data = response.data;
    if (data is Map && data['results'] is List) {
      return (data['results'] as List)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (data is List) {
      return data.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }
}
