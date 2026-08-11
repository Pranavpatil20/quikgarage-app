// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garage_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GarageModelImpl _$$GarageModelImplFromJson(Map<String, dynamic> json) =>
    _$GarageModelImpl(
      id: (json['id'] as num).toInt(),
      garageName: json['garage_name'] as String,
      address: json['address'] as String,
      openingTime: json['opening_time'] as String,
      closingTime: json['closing_time'] as String,
      defaultServiceCost: json['default_service_cost'] == null
          ? '899.00'
          : _costFromJson(json['default_service_cost']),
      owner: (json['owner'] as num?)?.toInt(),
      ownerName: json['owner_name'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$GarageModelImplToJson(_$GarageModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'garage_name': instance.garageName,
      'address': instance.address,
      'opening_time': instance.openingTime,
      'closing_time': instance.closingTime,
      'default_service_cost': instance.defaultServiceCost,
      'owner': instance.owner,
      'owner_name': instance.ownerName,
      'created_at': instance.createdAt?.toIso8601String(),
    };
