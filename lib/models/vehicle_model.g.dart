// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VehicleModelImpl _$$VehicleModelImplFromJson(Map<String, dynamic> json) =>
    _$VehicleModelImpl(
      id: (json['id'] as num).toInt(),
      customer: (json['customer'] as num?)?.toInt(),
      vehicleNumber: json['vehicle_number'] as String,
      vehicleType: json['vehicle_type'] as String? ?? 'car',
      makeModel: json['make_model'] as String? ?? '',
      isPrimary: json['is_primary'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$VehicleModelImplToJson(_$VehicleModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customer': instance.customer,
      'vehicle_number': instance.vehicleNumber,
      'vehicle_type': instance.vehicleType,
      'make_model': instance.makeModel,
      'is_primary': instance.isPrimary,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
