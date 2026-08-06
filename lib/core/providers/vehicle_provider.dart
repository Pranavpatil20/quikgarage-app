import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/vehicle_model.dart';
import '../../repositories/vehicle_repository.dart';
import 'auth_provider.dart';

final vehiclesProvider = FutureProvider.autoDispose<List<VehicleModel>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];
  return ref.watch(vehicleRepositoryProvider).getVehicles();
});
