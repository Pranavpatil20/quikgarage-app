import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/api_constants.dart';
import '../models/booking_model.dart';
import '../services/api_client.dart';

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepository(ref.watch(dioProvider));
});

class BookingRepository {
  BookingRepository(this._dio);

  final Dio _dio;

  Future<List<BookingModel>> getCustomerBookings({String? status}) async {
    final response = await _dio.get(
      ApiConstants.bookings,
      queryParameters: status != null ? {'status': status} : null,
    );
    return _parseList(response.data);
  }

  Future<List<BookingModel>> getOwnerBookings({
    String? status,
    String? date,
    int? customerId,
  }) async {
    final response = await _dio.get(
      ApiConstants.ownerBookings,
      queryParameters: {
        if (status != null) 'status': status,
        if (date != null) 'booking_date': date,
        if (customerId != null) 'customer': customerId,
      },
    );
    return _parseList(response.data);
  }

  Future<BookingModel> createBooking(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiConstants.bookings, data: data);
    return BookingModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<BookingModel> createOwnerBooking(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiConstants.ownerBookingCreate, data: data);
    return BookingModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<BookingModel> updateStatus(int id, String status) async {
    final response = await _dio.patch(
      ApiConstants.bookingStatus(id),
      data: {'status': status},
    );
    return BookingModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> cancelBooking(int id) async {
    await _dio.delete('${ApiConstants.bookings}$id/');
  }

  Future<AvailableSlotsResponse> getAvailableSlots(int garageId, String date) async {
    final response = await _dio.get(
      ApiConstants.availableSlots(garageId),
      queryParameters: {'date': date},
    );
    return AvailableSlotsResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<BookingModel>> getTodayBookings() async {
    final response = await _dio.get(ApiConstants.bookingsToday);
    final data = response.data;
    if (data is List) {
      return data.map((e) => BookingModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  List<BookingModel> _parseList(dynamic data) {
    if (data is Map && data['results'] is List) {
      return (data['results'] as List)
          .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (data is List) {
      return data.map((e) => BookingModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }
}
