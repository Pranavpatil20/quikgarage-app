import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/garage_model.dart';
import '../../repositories/garage_repository.dart';
import 'auth_provider.dart';

final garagesProvider = FutureProvider.autoDispose<List<GarageModel>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];
  return ref.watch(garageRepositoryProvider).getGarages();
});

final myGarageProvider = FutureProvider.autoDispose<GarageModel>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    throw StateError('Not authenticated');
  }
  return ref.watch(garageRepositoryProvider).getMyGarage();
});
