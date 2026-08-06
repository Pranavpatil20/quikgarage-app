import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/booking_model.dart';
import '../../repositories/booking_repository.dart';
import 'auth_provider.dart';

final customerBookingsProvider = FutureProvider.autoDispose
    .family<List<BookingModel>, String?>((ref, status) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];
  return ref.watch(bookingRepositoryProvider).getCustomerBookings(status: status);
});

final ownerBookingsProvider = FutureProvider.autoDispose
    .family<List<BookingModel>, ({String? status, String? date})>((ref, params) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];
  return ref.watch(bookingRepositoryProvider).getOwnerBookings(
        status: params.status,
        date: params.date,
      );
});

final availableSlotsProvider = FutureProvider.autoDispose
    .family<AvailableSlotsResponse, ({int garageId, String date})>((ref, params) async {
  return ref.watch(bookingRepositoryProvider).getAvailableSlots(
        params.garageId,
        params.date,
      );
});

final todayBookingsProvider = FutureProvider.autoDispose<List<BookingModel>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];
  return ref.watch(bookingRepositoryProvider).getTodayBookings();
});
