// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  int get id => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'firebase_uid')
  String? get firebaseUid => throw _privateConstructorUsedError;
  @JsonKey(name: 'trial_ends_at')
  DateTime? get trialEndsAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscription_paid_until')
  DateTime? get subscriptionPaidUntil => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscription_active')
  bool get subscriptionActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_payment_locked')
  bool get isPaymentLocked => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
    int id,
    String phone,
    String name,
    String role,
    @JsonKey(name: 'firebase_uid') String? firebaseUid,
    @JsonKey(name: 'trial_ends_at') DateTime? trialEndsAt,
    @JsonKey(name: 'subscription_paid_until') DateTime? subscriptionPaidUntil,
    @JsonKey(name: 'subscription_active') bool subscriptionActive,
    @JsonKey(name: 'is_payment_locked') bool isPaymentLocked,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phone = null,
    Object? name = null,
    Object? role = null,
    Object? firebaseUid = freezed,
    Object? trialEndsAt = freezed,
    Object? subscriptionPaidUntil = freezed,
    Object? subscriptionActive = null,
    Object? isPaymentLocked = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            firebaseUid: freezed == firebaseUid
                ? _value.firebaseUid
                : firebaseUid // ignore: cast_nullable_to_non_nullable
                      as String?,
            trialEndsAt: freezed == trialEndsAt
                ? _value.trialEndsAt
                : trialEndsAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            subscriptionPaidUntil: freezed == subscriptionPaidUntil
                ? _value.subscriptionPaidUntil
                : subscriptionPaidUntil // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            subscriptionActive: null == subscriptionActive
                ? _value.subscriptionActive
                : subscriptionActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            isPaymentLocked: null == isPaymentLocked
                ? _value.isPaymentLocked
                : isPaymentLocked // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String phone,
    String name,
    String role,
    @JsonKey(name: 'firebase_uid') String? firebaseUid,
    @JsonKey(name: 'trial_ends_at') DateTime? trialEndsAt,
    @JsonKey(name: 'subscription_paid_until') DateTime? subscriptionPaidUntil,
    @JsonKey(name: 'subscription_active') bool subscriptionActive,
    @JsonKey(name: 'is_payment_locked') bool isPaymentLocked,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phone = null,
    Object? name = null,
    Object? role = null,
    Object? firebaseUid = freezed,
    Object? trialEndsAt = freezed,
    Object? subscriptionPaidUntil = freezed,
    Object? subscriptionActive = null,
    Object? isPaymentLocked = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$UserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        firebaseUid: freezed == firebaseUid
            ? _value.firebaseUid
            : firebaseUid // ignore: cast_nullable_to_non_nullable
                  as String?,
        trialEndsAt: freezed == trialEndsAt
            ? _value.trialEndsAt
            : trialEndsAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        subscriptionPaidUntil: freezed == subscriptionPaidUntil
            ? _value.subscriptionPaidUntil
            : subscriptionPaidUntil // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        subscriptionActive: null == subscriptionActive
            ? _value.subscriptionActive
            : subscriptionActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPaymentLocked: null == isPaymentLocked
            ? _value.isPaymentLocked
            : isPaymentLocked // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl extends _UserModel {
  const _$UserModelImpl({
    required this.id,
    required this.phone,
    this.name = '',
    this.role = 'customer',
    @JsonKey(name: 'firebase_uid') this.firebaseUid,
    @JsonKey(name: 'trial_ends_at') this.trialEndsAt,
    @JsonKey(name: 'subscription_paid_until') this.subscriptionPaidUntil,
    @JsonKey(name: 'subscription_active') this.subscriptionActive = true,
    @JsonKey(name: 'is_payment_locked') this.isPaymentLocked = false,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : super._();

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final int id;
  @override
  final String phone;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String role;
  @override
  @JsonKey(name: 'firebase_uid')
  final String? firebaseUid;
  @override
  @JsonKey(name: 'trial_ends_at')
  final DateTime? trialEndsAt;
  @override
  @JsonKey(name: 'subscription_paid_until')
  final DateTime? subscriptionPaidUntil;
  @override
  @JsonKey(name: 'subscription_active')
  final bool subscriptionActive;
  @override
  @JsonKey(name: 'is_payment_locked')
  final bool isPaymentLocked;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UserModel(id: $id, phone: $phone, name: $name, role: $role, firebaseUid: $firebaseUid, trialEndsAt: $trialEndsAt, subscriptionPaidUntil: $subscriptionPaidUntil, subscriptionActive: $subscriptionActive, isPaymentLocked: $isPaymentLocked, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.firebaseUid, firebaseUid) ||
                other.firebaseUid == firebaseUid) &&
            (identical(other.trialEndsAt, trialEndsAt) ||
                other.trialEndsAt == trialEndsAt) &&
            (identical(other.subscriptionPaidUntil, subscriptionPaidUntil) ||
                other.subscriptionPaidUntil == subscriptionPaidUntil) &&
            (identical(other.subscriptionActive, subscriptionActive) ||
                other.subscriptionActive == subscriptionActive) &&
            (identical(other.isPaymentLocked, isPaymentLocked) ||
                other.isPaymentLocked == isPaymentLocked) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    phone,
    name,
    role,
    firebaseUid,
    trialEndsAt,
    subscriptionPaidUntil,
    subscriptionActive,
    isPaymentLocked,
    createdAt,
    updatedAt,
  );

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel extends UserModel {
  const factory _UserModel({
    required final int id,
    required final String phone,
    final String name,
    final String role,
    @JsonKey(name: 'firebase_uid') final String? firebaseUid,
    @JsonKey(name: 'trial_ends_at') final DateTime? trialEndsAt,
    @JsonKey(name: 'subscription_paid_until')
    final DateTime? subscriptionPaidUntil,
    @JsonKey(name: 'subscription_active') final bool subscriptionActive,
    @JsonKey(name: 'is_payment_locked') final bool isPaymentLocked,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$UserModelImpl;
  const _UserModel._() : super._();

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  int get id;
  @override
  String get phone;
  @override
  String get name;
  @override
  String get role;
  @override
  @JsonKey(name: 'firebase_uid')
  String? get firebaseUid;
  @override
  @JsonKey(name: 'trial_ends_at')
  DateTime? get trialEndsAt;
  @override
  @JsonKey(name: 'subscription_paid_until')
  DateTime? get subscriptionPaidUntil;
  @override
  @JsonKey(name: 'subscription_active')
  bool get subscriptionActive;
  @override
  @JsonKey(name: 'is_payment_locked')
  bool get isPaymentLocked;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
