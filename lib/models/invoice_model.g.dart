// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InvoiceModelImpl _$$InvoiceModelImplFromJson(Map<String, dynamic> json) =>
    _$InvoiceModelImpl(
      id: (json['id'] as num).toInt(),
      booking: (json['booking'] as num?)?.toInt(),
      bookingDetail: json['booking_detail'] == null
          ? null
          : BookingModel.fromJson(
              json['booking_detail'] as Map<String, dynamic>,
            ),
      serviceCost: json['service_cost'] as String? ?? '0.00',
      partsCost: json['parts_cost'] as String? ?? '0.00',
      totalAmount: json['total_amount'] as String? ?? '0.00',
      paymentStatus: json['payment_status'] as String? ?? 'pending',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$InvoiceModelImplToJson(_$InvoiceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'booking': instance.booking,
      'booking_detail': instance.bookingDetail,
      'service_cost': instance.serviceCost,
      'parts_cost': instance.partsCost,
      'total_amount': instance.totalAmount,
      'payment_status': instance.paymentStatus,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
