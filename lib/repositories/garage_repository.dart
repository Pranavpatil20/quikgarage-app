import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/api_constants.dart';
import '../models/garage_model.dart';
import '../services/api_client.dart';

final garageRepositoryProvider = Provider<GarageRepository>((ref) {
  return GarageRepository(ref.watch(dioProvider));
});

class GarageRepository {
  GarageRepository(this._dio);

  final Dio _dio;

  Future<List<GarageModel>> getGarages() async {
    final response = await _dio.get(ApiConstants.garages);
    final data = response.data;
    if (data is Map && data['results'] is List) {
      return (data['results'] as List)
          .map((e) => GarageModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (data is List) {
      return data.map((e) => GarageModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<GarageModel> getMyGarage() async {
    final response = await _dio.get(ApiConstants.garagesMine);
    return GarageModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<GarageModel> createGarage(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiConstants.garages, data: data);
    return GarageModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<GarageModel> updateGarage(int id, Map<String, dynamic> data) async {
    final response = await _dio.patch('${ApiConstants.garages}$id/', data: data);
    return GarageModel.fromJson(response.data as Map<String, dynamic>);
  }
}
