// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingModelImpl _$$BookingModelImplFromJson(Map<String, dynamic> json) =>
    _$BookingModelImpl(
      id: (json['id'] as num).toInt(),
      customer: (json['customer'] as num?)?.toInt(),
      customerDetail: json['customer_detail'] == null
          ? null
          : UserModel.fromJson(json['customer_detail'] as Map<String, dynamic>),
      garage: (json['garage'] as num?)?.toInt(),
      garageDetail: json['garage_detail'] == null
          ? null
          : GarageModel.fromJson(json['garage_detail'] as Map<String, dynamic>),
      vehicle: (json['vehicle'] as num?)?.toInt(),
      vehicleDetail: json['vehicle_detail'] == null
          ? null
          : VehicleModel.fromJson(
              json['vehicle_detail'] as Map<String, dynamic>,
            ),
      serviceType: json['service_type'] as String,
      bookingDate: json['booking_date'] as String,
      timeSlot: json['time_slot'] as String,
      notes: json['notes'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      canCancel: json['can_cancel'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$BookingModelImplToJson(_$BookingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customer': instance.customer,
      'customer_detail': instance.customerDetail,
      'garage': instance.garage,
      'garage_detail': instance.garageDetail,
      'vehicle': instance.vehicle,
      'vehicle_detail': instance.vehicleDetail,
      'service_type': instance.serviceType,
      'booking_date': instance.bookingDate,
      'time_slot': instance.timeSlot,
      'notes': instance.notes,
      'status': instance.status,
      'can_cancel': instance.canCancel,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$TimeSlotModelImpl _$$TimeSlotModelImplFromJson(Map<String, dynamic> json) =>
    _$TimeSlotModelImpl(
      time: json['time'] as String,
      available: json['available'] as bool,
    );

Map<String, dynamic> _$$TimeSlotModelImplToJson(_$TimeSlotModelImpl instance) =>
    <String, dynamic>{'time': instance.time, 'available': instance.available};

_$AvailableSlotsResponseImpl _$$AvailableSlotsResponseImplFromJson(
  Map<String, dynamic> json,
) => _$AvailableSlotsResponseImpl(
  garageId: (json['garage_id'] as num).toInt(),
  date: json['date'] as String,
  slots: (json['slots'] as List<dynamic>)
      .map((e) => TimeSlotModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$AvailableSlotsResponseImplToJson(
  _$AvailableSlotsResponseImpl instance,
) => <String, dynamic>{
  'garage_id': instance.garageId,
  'date': instance.date,
  'slots': instance.slots,
};
