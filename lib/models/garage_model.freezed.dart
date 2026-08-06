// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'garage_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GarageModel _$GarageModelFromJson(Map<String, dynamic> json) {
  return _GarageModel.fromJson(json);
}

/// @nodoc
mixin _$GarageModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'garage_name')
  String get garageName => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'opening_time')
  String get openingTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'closing_time')
  String get closingTime => throw _privateConstructorUsedError;
  int? get owner => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_name')
  String? get ownerName => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this GarageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GarageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GarageModelCopyWith<GarageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GarageModelCopyWith<$Res> {
  factory $GarageModelCopyWith(
    GarageModel value,
    $Res Function(GarageModel) then,
  ) = _$GarageModelCopyWithImpl<$Res, GarageModel>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'garage_name') String garageName,
    String address,
    @JsonKey(name: 'opening_time') String openingTime,
    @JsonKey(name: 'closing_time') String closingTime,
    int? owner,
    @JsonKey(name: 'owner_name') String? ownerName,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$GarageModelCopyWithImpl<$Res, $Val extends GarageModel>
    implements $GarageModelCopyWith<$Res> {
  _$GarageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GarageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? garageName = null,
    Object? address = null,
    Object? openingTime = null,
    Object? closingTime = null,
    Object? owner = freezed,
    Object? ownerName = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            garageName: null == garageName
                ? _value.garageName
                : garageName // ignore: cast_nullable_to_non_nullable
                      as String,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            openingTime: null == openingTime
                ? _value.openingTime
                : openingTime // ignore: cast_nullable_to_non_nullable
                      as String,
            closingTime: null == closingTime
                ? _value.closingTime
                : closingTime // ignore: cast_nullable_to_non_nullable
                      as String,
            owner: freezed == owner
                ? _value.owner
                : owner // ignore: cast_nullable_to_non_nullable
                      as int?,
            ownerName: freezed == ownerName
                ? _value.ownerName
                : ownerName // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$GarageModelImplCopyWith<$Res>
    implements $GarageModelCopyWith<$Res> {
  factory _$$GarageModelImplCopyWith(
    _$GarageModelImpl value,
    $Res Function(_$GarageModelImpl) then,
  ) = __$$GarageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'garage_name') String garageName,
    String address,
    @JsonKey(name: 'opening_time') String openingTime,
    @JsonKey(name: 'closing_time') String closingTime,
    int? owner,
    @JsonKey(name: 'owner_name') String? ownerName,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$GarageModelImplCopyWithImpl<$Res>
    extends _$GarageModelCopyWithImpl<$Res, _$GarageModelImpl>
    implements _$$GarageModelImplCopyWith<$Res> {
  __$$GarageModelImplCopyWithImpl(
    _$GarageModelImpl _value,
    $Res Function(_$GarageModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GarageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? garageName = null,
    Object? address = null,
    Object? openingTime = null,
    Object? closingTime = null,
    Object? owner = freezed,
    Object? ownerName = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$GarageModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        garageName: null == garageName
            ? _value.garageName
            : garageName // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        openingTime: null == openingTime
            ? _value.openingTime
            : openingTime // ignore: cast_nullable_to_non_nullable
                  as String,
        closingTime: null == closingTime
            ? _value.closingTime
            : closingTime // ignore: cast_nullable_to_non_nullable
                  as String,
        owner: freezed == owner
            ? _value.owner
            : owner // ignore: cast_nullable_to_non_nullable
                  as int?,
        ownerName: freezed == ownerName
            ? _value.ownerName
            : ownerName // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$GarageModelImpl implements _GarageModel {
  const _$GarageModelImpl({
    required this.id,
    @JsonKey(name: 'garage_name') required this.garageName,
    required this.address,
    @JsonKey(name: 'opening_time') required this.openingTime,
    @JsonKey(name: 'closing_time') required this.closingTime,
    this.owner,
    @JsonKey(name: 'owner_name') this.ownerName,
    this.createdAt,
  });

  factory _$GarageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GarageModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'garage_name')
  final String garageName;
  @override
  final String address;
  @override
  @JsonKey(name: 'opening_time')
  final String openingTime;
  @override
  @JsonKey(name: 'closing_time')
  final String closingTime;
  @override
  final int? owner;
  @override
  @JsonKey(name: 'owner_name')
  final String? ownerName;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'GarageModel(id: $id, garageName: $garageName, address: $address, openingTime: $openingTime, closingTime: $closingTime, owner: $owner, ownerName: $ownerName, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GarageModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.garageName, garageName) ||
                other.garageName == garageName) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.openingTime, openingTime) ||
                other.openingTime == openingTime) &&
            (identical(other.closingTime, closingTime) ||
                other.closingTime == closingTime) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    garageName,
    address,
    openingTime,
    closingTime,
    owner,
    ownerName,
    createdAt,
  );

  /// Create a copy of GarageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GarageModelImplCopyWith<_$GarageModelImpl> get copyWith =>
      __$$GarageModelImplCopyWithImpl<_$GarageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GarageModelImplToJson(this);
  }
}

abstract class _GarageModel implements GarageModel {
  const factory _GarageModel({
    required final int id,
    @JsonKey(name: 'garage_name') required final String garageName,
    required final String address,
    @JsonKey(name: 'opening_time') required final String openingTime,
    @JsonKey(name: 'closing_time') required final String closingTime,
    final int? owner,
    @JsonKey(name: 'owner_name') final String? ownerName,
    final DateTime? createdAt,
  }) = _$GarageModelImpl;

  factory _GarageModel.fromJson(Map<String, dynamic> json) =
      _$GarageModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'garage_name')
  String get garageName;
  @override
  String get address;
  @override
  @JsonKey(name: 'opening_time')
  String get openingTime;
  @override
  @JsonKey(name: 'closing_time')
  String get closingTime;
  @override
  int? get owner;
  @override
  @JsonKey(name: 'owner_name')
  String? get ownerName;
  @override
  DateTime? get createdAt;

  /// Create a copy of GarageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GarageModelImplCopyWith<_$GarageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
