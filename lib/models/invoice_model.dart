import 'package:freezed_annotation/freezed_annotation.dart';

import 'booking_model.dart';

part 'invoice_model.freezed.dart';
part 'invoice_model.g.dart';

@freezed
class InvoiceModel with _$InvoiceModel {
  const factory InvoiceModel({
    required int id,
    int? booking,
    @JsonKey(name: 'booking_detail') BookingModel? bookingDetail,
    @JsonKey(name: 'service_cost') @Default('0.00') String serviceCost,
    @JsonKey(name: 'parts_cost') @Default('0.00') String partsCost,
    @JsonKey(name: 'total_amount') @Default('0.00') String totalAmount,
    @JsonKey(name: 'payment_status') @Default('pending') String paymentStatus,
    DateTime? createdAt,
  }) = _InvoiceModel;

  factory InvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceModelFromJson(json);
}
