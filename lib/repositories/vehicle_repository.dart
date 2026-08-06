import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/api_constants.dart';
import '../models/vehicle_model.dart';
import '../services/api_client.dart';

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  return VehicleRepository(ref.watch(dioProvider));
});

class VehicleRepository {
  VehicleRepository(this._dio);

  final Dio _dio;

  Future<List<VehicleModel>> getVehicles() async {
    final response = await _dio.get(ApiConstants.vehicles);
    final data = response.data;
    if (data is Map && data['results'] is List) {
      return (data['results'] as List)
          .map((e) => VehicleModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (data is List) {
      return data.map((e) => VehicleModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<VehicleModel> createVehicle(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiConstants.vehicles, data: data);
    return VehicleModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<VehicleModel> updateVehicle(int id, Map<String, dynamic> data) async {
    final response = await _dio.patch('${ApiConstants.vehicles}$id/', data: data);
    return VehicleModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteVehicle(int id) async {
    await _dio.delete('${ApiConstants.vehicles}$id/');
  }
}
