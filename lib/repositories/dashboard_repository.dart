import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/api_constants.dart';
import '../models/dashboard_model.dart';
import '../services/api_client.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(ref.watch(dioProvider));
});

class DashboardRepository {
  DashboardRepository(this._dio);

  final Dio _dio;

  Future<DashboardMetrics> getOwnerMetrics() async {
    final response = await _dio.get(ApiConstants.dashboardMetrics);
    return DashboardMetrics.fromJson(response.data as Map<String, dynamic>);
  }
}
