// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: (json['id'] as num).toInt(),
      phone: json['phone'] as String,
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? 'customer',
      firebaseUid: json['firebase_uid'] as String?,
      trialEndsAt: json['trial_ends_at'] == null
          ? null
          : DateTime.parse(json['trial_ends_at'] as String),
      subscriptionPaidUntil: json['subscription_paid_until'] == null
          ? null
          : DateTime.parse(json['subscription_paid_until'] as String),
      subscriptionActive: json['subscription_active'] as bool? ?? true,
      isPaymentLocked: json['is_payment_locked'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(
  _$UserModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'phone': instance.phone,
  'name': instance.name,
  'role': instance.role,
  'firebase_uid': instance.firebaseUid,
  'trial_ends_at': instance.trialEndsAt?.toIso8601String(),
  'subscription_paid_until': instance.subscriptionPaidUntil?.toIso8601String(),
  'subscription_active': instance.subscriptionActive,
  'is_payment_locked': instance.isPaymentLocked,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
