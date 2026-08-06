// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VehicleModel _$VehicleModelFromJson(Map<String, dynamic> json) {
  return _VehicleModel.fromJson(json);
}

/// @nodoc
mixin _$VehicleModel {
  int get id => throw _privateConstructorUsedError;
  int? get customer => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_number')
  String get vehicleNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_type')
  String get vehicleType => throw _privateConstructorUsedError;
  @JsonKey(name: 'make_model')
  String get makeModel => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_primary')
  bool get isPrimary => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this VehicleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VehicleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VehicleModelCopyWith<VehicleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleModelCopyWith<$Res> {
  factory $VehicleModelCopyWith(
    VehicleModel value,
    $Res Function(VehicleModel) then,
  ) = _$VehicleModelCopyWithImpl<$Res, VehicleModel>;
  @useResult
  $Res call({
    int id,
    int? customer,
    @JsonKey(name: 'vehicle_number') String vehicleNumber,
    @JsonKey(name: 'vehicle_type') String vehicleType,
    @JsonKey(name: 'make_model') String makeModel,
    @JsonKey(name: 'is_primary') bool isPrimary,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$VehicleModelCopyWithImpl<$Res, $Val extends VehicleModel>
    implements $VehicleModelCopyWith<$Res> {
  _$VehicleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VehicleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customer = freezed,
    Object? vehicleNumber = null,
    Object? vehicleType = null,
    Object? makeModel = null,
    Object? isPrimary = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            customer: freezed == customer
                ? _value.customer
                : customer // ignore: cast_nullable_to_non_nullable
                      as int?,
            vehicleNumber: null == vehicleNumber
                ? _value.vehicleNumber
                : vehicleNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            vehicleType: null == vehicleType
                ? _value.vehicleType
                : vehicleType // ignore: cast_nullable_to_non_nullable
                      as String,
            makeModel: null == makeModel
                ? _value.makeModel
                : makeModel // ignore: cast_nullable_to_non_nullable
                      as String,
            isPrimary: null == isPrimary
                ? _value.isPrimary
                : isPrimary // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VehicleModelImplCopyWith<$Res>
    implements $VehicleModelCopyWith<$Res> {
  factory _$$VehicleModelImplCopyWith(
    _$VehicleModelImpl value,
    $Res Function(_$VehicleModelImpl) then,
  ) = __$$VehicleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int? customer,
    @JsonKey(name: 'vehicle_number') String vehicleNumber,
    @JsonKey(name: 'vehicle_type') String vehicleType,
    @JsonKey(name: 'make_model') String makeModel,
    @JsonKey(name: 'is_primary') bool isPrimary,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$VehicleModelImplCopyWithImpl<$Res>
    extends _$VehicleModelCopyWithImpl<$Res, _$VehicleModelImpl>
    implements _$$VehicleModelImplCopyWith<$Res> {
  __$$VehicleModelImplCopyWithImpl(
    _$VehicleModelImpl _value,
    $Res Function(_$VehicleModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VehicleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customer = freezed,
    Object? vehicleNumber = null,
    Object? vehicleType = null,
    Object? makeModel = null,
    Object? isPrimary = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$VehicleModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        customer: freezed == customer
            ? _value.customer
            : customer // ignore: cast_nullable_to_non_nullable
                  as int?,
        vehicleNumber: null == vehicleNumber
            ? _value.vehicleNumber
            : vehicleNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        vehicleType: null == vehicleType
            ? _value.vehicleType
            : vehicleType // ignore: cast_nullable_to_non_nullable
                  as String,
        makeModel: null == makeModel
            ? _value.makeModel
            : makeModel // ignore: cast_nullable_to_non_nullable
                  as String,
        isPrimary: null == isPrimary
            ? _value.isPrimary
            : isPrimary // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VehicleModelImpl extends _VehicleModel {
  const _$VehicleModelImpl({
    required this.id,
    this.customer,
    @JsonKey(name: 'vehicle_number') required this.vehicleNumber,
    @JsonKey(name: 'vehicle_type') this.vehicleType = 'car',
    @JsonKey(name: 'make_model') this.makeModel = '',
    @JsonKey(name: 'is_primary') this.isPrimary = false,
    this.createdAt,
  }) : super._();

  factory _$VehicleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VehicleModelImplFromJson(json);

  @override
  final int id;
  @override
  final int? customer;
  @override
  @JsonKey(name: 'vehicle_number')
  final String vehicleNumber;
  @override
  @JsonKey(name: 'vehicle_type')
  final String vehicleType;
  @override
  @JsonKey(name: 'make_model')
  final String makeModel;
  @override
  @JsonKey(name: 'is_primary')
  final bool isPrimary;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'VehicleModel(id: $id, customer: $customer, vehicleNumber: $vehicleNumber, vehicleType: $vehicleType, makeModel: $makeModel, isPrimary: $isPrimary, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            (identical(other.vehicleNumber, vehicleNumber) ||
                other.vehicleNumber == vehicleNumber) &&
            (identical(other.vehicleType, vehicleType) ||
                other.vehicleType == vehicleType) &&
            (identical(other.makeModel, makeModel) ||
                other.makeModel == makeModel) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    customer,
    vehicleNumber,
    vehicleType,
    makeModel,
    isPrimary,
    createdAt,
  );

  /// Create a copy of VehicleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleModelImplCopyWith<_$VehicleModelImpl> get copyWith =>
      __$$VehicleModelImplCopyWithImpl<_$VehicleModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VehicleModelImplToJson(this);
  }
}

abstract class _VehicleModel extends VehicleModel {
  const factory _VehicleModel({
    required final int id,
    final int? customer,
    @JsonKey(name: 'vehicle_number') required final String vehicleNumber,
    @JsonKey(name: 'vehicle_type') final String vehicleType,
    @JsonKey(name: 'make_model') final String makeModel,
    @JsonKey(name: 'is_primary') final bool isPrimary,
    final DateTime? createdAt,
  }) = _$VehicleModelImpl;
  const _VehicleModel._() : super._();

  factory _VehicleModel.fromJson(Map<String, dynamic> json) =
      _$VehicleModelImpl.fromJson;

  @override
  int get id;
  @override
  int? get customer;
  @override
  @JsonKey(name: 'vehicle_number')
  String get vehicleNumber;
  @override
  @JsonKey(name: 'vehicle_type')
  String get vehicleType;
  @override
  @JsonKey(name: 'make_model')
  String get makeModel;
  @override
  @JsonKey(name: 'is_primary')
  bool get isPrimary;
  @override
  DateTime? get createdAt;

  /// Create a copy of VehicleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VehicleModelImplCopyWith<_$VehicleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
