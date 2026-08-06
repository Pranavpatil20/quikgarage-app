import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/dashboard_model.dart';
import '../../repositories/dashboard_repository.dart';
import 'auth_provider.dart';

final dashboardMetricsProvider = FutureProvider.autoDispose<DashboardMetrics>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    throw StateError('Not authenticated');
  }
  return ref.watch(dashboardRepositoryProvider).getOwnerMetrics();
});
