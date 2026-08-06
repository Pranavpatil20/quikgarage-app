import 'package:freezed_annotation/freezed_annotation.dart';

import 'garage_model.dart';
import 'user_model.dart';
import 'vehicle_model.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

@freezed
class BookingModel with _$BookingModel {
  const factory BookingModel({
    required int id,
    int? customer,
    @JsonKey(name: 'customer_detail') UserModel? customerDetail,
    int? garage,
    @JsonKey(name: 'garage_detail') GarageModel? garageDetail,
    int? vehicle,
    @JsonKey(name: 'vehicle_detail') VehicleModel? vehicleDetail,
    @JsonKey(name: 'service_type') required String serviceType,
    @JsonKey(name: 'booking_date') required String bookingDate,
    @JsonKey(name: 'time_slot') required String timeSlot,
    @Default('') String notes,
    @Default('pending') String status,
    @JsonKey(name: 'can_cancel') @Default(false) bool canCancel,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);
}

@freezed
class TimeSlotModel with _$TimeSlotModel {
  const factory TimeSlotModel({
    required String time,
    required bool available,
  }) = _TimeSlotModel;

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotModelFromJson(json);
}

@freezed
class AvailableSlotsResponse with _$AvailableSlotsResponse {
  const factory AvailableSlotsResponse({
    @JsonKey(name: 'garage_id') required int garageId,
    required String date,
    required List<TimeSlotModel> slots,
  }) = _AvailableSlotsResponse;

  factory AvailableSlotsResponse.fromJson(Map<String, dynamic> json) =>
      _$AvailableSlotsResponseFromJson(json);
}
