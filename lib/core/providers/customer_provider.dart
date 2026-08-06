import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user_model.dart';
import '../../repositories/user_repository.dart';
import 'auth_provider.dart';

final customersProvider = FutureProvider.autoDispose<List<UserModel>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];
  return ref.watch(userRepositoryProvider).getCustomers();
});
