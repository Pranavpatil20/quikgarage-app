// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) {
  return _BookingModel.fromJson(json);
}

/// @nodoc
mixin _$BookingModel {
  int get id => throw _privateConstructorUsedError;
  int? get customer => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_detail')
  UserModel? get customerDetail => throw _privateConstructorUsedError;
  int? get garage => throw _privateConstructorUsedError;
  @JsonKey(name: 'garage_detail')
  GarageModel? get garageDetail => throw _privateConstructorUsedError;
  int? get vehicle => throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicle_detail')
  VehicleModel? get vehicleDetail => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_type')
  String get serviceType => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_date')
  String get bookingDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'time_slot')
  String get timeSlot => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_cancel')
  bool get canCancel => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this BookingModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingModelCopyWith<BookingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingModelCopyWith<$Res> {
  factory $BookingModelCopyWith(
    BookingModel value,
    $Res Function(BookingModel) then,
  ) = _$BookingModelCopyWithImpl<$Res, BookingModel>;
  @useResult
  $Res call({
    int id,
    int? customer,
    @JsonKey(name: 'customer_detail') UserModel? customerDetail,
    int? garage,
    @JsonKey(name: 'garage_detail') GarageModel? garageDetail,
    int? vehicle,
    @JsonKey(name: 'vehicle_detail') VehicleModel? vehicleDetail,
    @JsonKey(name: 'service_type') String serviceType,
    @JsonKey(name: 'booking_date') String bookingDate,
    @JsonKey(name: 'time_slot') String timeSlot,
    String notes,
    String status,
    @JsonKey(name: 'can_cancel') bool canCancel,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });

  $UserModelCopyWith<$Res>? get customerDetail;
  $GarageModelCopyWith<$Res>? get garageDetail;
  $VehicleModelCopyWith<$Res>? get vehicleDetail;
}

/// @nodoc
class _$BookingModelCopyWithImpl<$Res, $Val extends BookingModel>
    implements $BookingModelCopyWith<$Res> {
  _$BookingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customer = freezed,
    Object? customerDetail = freezed,
    Object? garage = freezed,
    Object? garageDetail = freezed,
    Object? vehicle = freezed,
    Object? vehicleDetail = freezed,
    Object? serviceType = null,
    Object? bookingDate = null,
    Object? timeSlot = null,
    Object? notes = null,
    Object? status = null,
    Object? canCancel = null,
    Object? completedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
            customerDetail: freezed == customerDetail
                ? _value.customerDetail
                : customerDetail // ignore: cast_nullable_to_non_nullable
                      as UserModel?,
            garage: freezed == garage
                ? _value.garage
                : garage // ignore: cast_nullable_to_non_nullable
                      as int?,
            garageDetail: freezed == garageDetail
                ? _value.garageDetail
                : garageDetail // ignore: cast_nullable_to_non_nullable
                      as GarageModel?,
            vehicle: freezed == vehicle
                ? _value.vehicle
                : vehicle // ignore: cast_nullable_to_non_nullable
                      as int?,
            vehicleDetail: freezed == vehicleDetail
                ? _value.vehicleDetail
                : vehicleDetail // ignore: cast_nullable_to_non_nullable
                      as VehicleModel?,
            serviceType: null == serviceType
                ? _value.serviceType
                : serviceType // ignore: cast_nullable_to_non_nullable
                      as String,
            bookingDate: null == bookingDate
                ? _value.bookingDate
                : bookingDate // ignore: cast_nullable_to_non_nullable
                      as String,
            timeSlot: null == timeSlot
                ? _value.timeSlot
                : timeSlot // ignore: cast_nullable_to_non_nullable
                      as String,
            notes: null == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            canCancel: null == canCancel
                ? _value.canCancel
                : canCancel // ignore: cast_nullable_to_non_nullable
                      as bool,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
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

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get customerDetail {
    if (_value.customerDetail == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.customerDetail!, (value) {
      return _then(_value.copyWith(customerDetail: value) as $Val);
    });
  }

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GarageModelCopyWith<$Res>? get garageDetail {
    if (_value.garageDetail == null) {
      return null;
    }

    return $GarageModelCopyWith<$Res>(_value.garageDetail!, (value) {
      return _then(_value.copyWith(garageDetail: value) as $Val);
    });
  }

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VehicleModelCopyWith<$Res>? get vehicleDetail {
    if (_value.vehicleDetail == null) {
      return null;
    }

    return $VehicleModelCopyWith<$Res>(_value.vehicleDetail!, (value) {
      return _then(_value.copyWith(vehicleDetail: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingModelImplCopyWith<$Res>
    implements $BookingModelCopyWith<$Res> {
  factory _$$BookingModelImplCopyWith(
    _$BookingModelImpl value,
    $Res Function(_$BookingModelImpl) then,
  ) = __$$BookingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int? customer,
    @JsonKey(name: 'customer_detail') UserModel? customerDetail,
    int? garage,
    @JsonKey(name: 'garage_detail') GarageModel? garageDetail,
    int? vehicle,
    @JsonKey(name: 'vehicle_detail') VehicleModel? vehicleDetail,
    @JsonKey(name: 'service_type') String serviceType,
    @JsonKey(name: 'booking_date') String bookingDate,
    @JsonKey(name: 'time_slot') String timeSlot,
    String notes,
    String status,
    @JsonKey(name: 'can_cancel') bool canCancel,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });

  @override
  $UserModelCopyWith<$Res>? get customerDetail;
  @override
  $GarageModelCopyWith<$Res>? get garageDetail;
  @override
  $VehicleModelCopyWith<$Res>? get vehicleDetail;
}

/// @nodoc
class __$$BookingModelImplCopyWithImpl<$Res>
    extends _$BookingModelCopyWithImpl<$Res, _$BookingModelImpl>
    implements _$$BookingModelImplCopyWith<$Res> {
  __$$BookingModelImplCopyWithImpl(
    _$BookingModelImpl _value,
    $Res Function(_$BookingModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customer = freezed,
    Object? customerDetail = freezed,
    Object? garage = freezed,
    Object? garageDetail = freezed,
    Object? vehicle = freezed,
    Object? vehicleDetail = freezed,
    Object? serviceType = null,
    Object? bookingDate = null,
    Object? timeSlot = null,
    Object? notes = null,
    Object? status = null,
    Object? canCancel = null,
    Object? completedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$BookingModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        customer: freezed == customer
            ? _value.customer
            : customer // ignore: cast_nullable_to_non_nullable
                  as int?,
        customerDetail: freezed == customerDetail
            ? _value.customerDetail
            : customerDetail // ignore: cast_nullable_to_non_nullable
                  as UserModel?,
        garage: freezed == garage
            ? _value.garage
            : garage // ignore: cast_nullable_to_non_nullable
                  as int?,
        garageDetail: freezed == garageDetail
            ? _value.garageDetail
            : garageDetail // ignore: cast_nullable_to_non_nullable
                  as GarageModel?,
        vehicle: freezed == vehicle
            ? _value.vehicle
            : vehicle // ignore: cast_nullable_to_non_nullable
                  as int?,
        vehicleDetail: freezed == vehicleDetail
            ? _value.vehicleDetail
            : vehicleDetail // ignore: cast_nullable_to_non_nullable
                  as VehicleModel?,
        serviceType: null == serviceType
            ? _value.serviceType
            : serviceType // ignore: cast_nullable_to_non_nullable
                  as String,
        bookingDate: null == bookingDate
            ? _value.bookingDate
            : bookingDate // ignore: cast_nullable_to_non_nullable
                  as String,
        timeSlot: null == timeSlot
            ? _value.timeSlot
            : timeSlot // ignore: cast_nullable_to_non_nullable
                  as String,
        notes: null == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        canCancel: null == canCancel
            ? _value.canCancel
            : canCancel // ignore: cast_nullable_to_non_nullable
                  as bool,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
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
class _$BookingModelImpl implements _BookingModel {
  const _$BookingModelImpl({
    required this.id,
    this.customer,
    @JsonKey(name: 'customer_detail') this.customerDetail,
    this.garage,
    @JsonKey(name: 'garage_detail') this.garageDetail,
    this.vehicle,
    @JsonKey(name: 'vehicle_detail') this.vehicleDetail,
    @JsonKey(name: 'service_type') required this.serviceType,
    @JsonKey(name: 'booking_date') required this.bookingDate,
    @JsonKey(name: 'time_slot') required this.timeSlot,
    this.notes = '',
    this.status = 'pending',
    @JsonKey(name: 'can_cancel') this.canCancel = false,
    @JsonKey(name: 'completed_at') this.completedAt,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  });

  factory _$BookingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingModelImplFromJson(json);

  @override
  final int id;
  @override
  final int? customer;
  @override
  @JsonKey(name: 'customer_detail')
  final UserModel? customerDetail;
  @override
  final int? garage;
  @override
  @JsonKey(name: 'garage_detail')
  final GarageModel? garageDetail;
  @override
  final int? vehicle;
  @override
  @JsonKey(name: 'vehicle_detail')
  final VehicleModel? vehicleDetail;
  @override
  @JsonKey(name: 'service_type')
  final String serviceType;
  @override
  @JsonKey(name: 'booking_date')
  final String bookingDate;
  @override
  @JsonKey(name: 'time_slot')
  final String timeSlot;
  @override
  @JsonKey()
  final String notes;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'can_cancel')
  final bool canCancel;
  @override
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'BookingModel(id: $id, customer: $customer, customerDetail: $customerDetail, garage: $garage, garageDetail: $garageDetail, vehicle: $vehicle, vehicleDetail: $vehicleDetail, serviceType: $serviceType, bookingDate: $bookingDate, timeSlot: $timeSlot, notes: $notes, status: $status, canCancel: $canCancel, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            (identical(other.customerDetail, customerDetail) ||
                other.customerDetail == customerDetail) &&
            (identical(other.garage, garage) || other.garage == garage) &&
            (identical(other.garageDetail, garageDetail) ||
                other.garageDetail == garageDetail) &&
            (identical(other.vehicle, vehicle) || other.vehicle == vehicle) &&
            (identical(other.vehicleDetail, vehicleDetail) ||
                other.vehicleDetail == vehicleDetail) &&
            (identical(other.serviceType, serviceType) ||
                other.serviceType == serviceType) &&
            (identical(other.bookingDate, bookingDate) ||
                other.bookingDate == bookingDate) &&
            (identical(other.timeSlot, timeSlot) ||
                other.timeSlot == timeSlot) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.canCancel, canCancel) ||
                other.canCancel == canCancel) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
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
    customer,
    customerDetail,
    garage,
    garageDetail,
    vehicle,
    vehicleDetail,
    serviceType,
    bookingDate,
    timeSlot,
    notes,
    status,
    canCancel,
    completedAt,
    createdAt,
    updatedAt,
  );

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingModelImplCopyWith<_$BookingModelImpl> get copyWith =>
      __$$BookingModelImplCopyWithImpl<_$BookingModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingModelImplToJson(this);
  }
}

abstract class _BookingModel implements BookingModel {
  const factory _BookingModel({
    required final int id,
    final int? customer,
    @JsonKey(name: 'customer_detail') final UserModel? customerDetail,
    final int? garage,
    @JsonKey(name: 'garage_detail') final GarageModel? garageDetail,
    final int? vehicle,
    @JsonKey(name: 'vehicle_detail') final VehicleModel? vehicleDetail,
    @JsonKey(name: 'service_type') required final String serviceType,
    @JsonKey(name: 'booking_date') required final String bookingDate,
    @JsonKey(name: 'time_slot') required final String timeSlot,
    final String notes,
    final String status,
    @JsonKey(name: 'can_cancel') final bool canCancel,
    @JsonKey(name: 'completed_at') final DateTime? completedAt,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$BookingModelImpl;

  factory _BookingModel.fromJson(Map<String, dynamic> json) =
      _$BookingModelImpl.fromJson;

  @override
  int get id;
  @override
  int? get customer;
  @override
  @JsonKey(name: 'customer_detail')
  UserModel? get customerDetail;
  @override
  int? get garage;
  @override
  @JsonKey(name: 'garage_detail')
  GarageModel? get garageDetail;
  @override
  int? get vehicle;
  @override
  @JsonKey(name: 'vehicle_detail')
  VehicleModel? get vehicleDetail;
  @override
  @JsonKey(name: 'service_type')
  String get serviceType;
  @override
  @JsonKey(name: 'booking_date')
  String get bookingDate;
  @override
  @JsonKey(name: 'time_slot')
  String get timeSlot;
  @override
  String get notes;
  @override
  String get status;
  @override
  @JsonKey(name: 'can_cancel')
  bool get canCancel;
  @override
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingModelImplCopyWith<_$BookingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimeSlotModel _$TimeSlotModelFromJson(Map<String, dynamic> json) {
  return _TimeSlotModel.fromJson(json);
}

/// @nodoc
mixin _$TimeSlotModel {
  String get time => throw _privateConstructorUsedError;
  bool get available => throw _privateConstructorUsedError;

  /// Serializes this TimeSlotModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimeSlotModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeSlotModelCopyWith<TimeSlotModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeSlotModelCopyWith<$Res> {
  factory $TimeSlotModelCopyWith(
    TimeSlotModel value,
    $Res Function(TimeSlotModel) then,
  ) = _$TimeSlotModelCopyWithImpl<$Res, TimeSlotModel>;
  @useResult
  $Res call({String time, bool available});
}

/// @nodoc
class _$TimeSlotModelCopyWithImpl<$Res, $Val extends TimeSlotModel>
    implements $TimeSlotModelCopyWith<$Res> {
  _$TimeSlotModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeSlotModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? time = null, Object? available = null}) {
    return _then(
      _value.copyWith(
            time: null == time
                ? _value.time
                : time // ignore: cast_nullable_to_non_nullable
                      as String,
            available: null == available
                ? _value.available
                : available // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TimeSlotModelImplCopyWith<$Res>
    implements $TimeSlotModelCopyWith<$Res> {
  factory _$$TimeSlotModelImplCopyWith(
    _$TimeSlotModelImpl value,
    $Res Function(_$TimeSlotModelImpl) then,
  ) = __$$TimeSlotModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String time, bool available});
}

/// @nodoc
class __$$TimeSlotModelImplCopyWithImpl<$Res>
    extends _$TimeSlotModelCopyWithImpl<$Res, _$TimeSlotModelImpl>
    implements _$$TimeSlotModelImplCopyWith<$Res> {
  __$$TimeSlotModelImplCopyWithImpl(
    _$TimeSlotModelImpl _value,
    $Res Function(_$TimeSlotModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimeSlotModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? time = null, Object? available = null}) {
    return _then(
      _$TimeSlotModelImpl(
        time: null == time
            ? _value.time
            : time // ignore: cast_nullable_to_non_nullable
                  as String,
        available: null == available
            ? _value.available
            : available // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimeSlotModelImpl implements _TimeSlotModel {
  const _$TimeSlotModelImpl({required this.time, required this.available});

  factory _$TimeSlotModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeSlotModelImplFromJson(json);

  @override
  final String time;
  @override
  final bool available;

  @override
  String toString() {
    return 'TimeSlotModel(time: $time, available: $available)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeSlotModelImpl &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.available, available) ||
                other.available == available));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, time, available);

  /// Create a copy of TimeSlotModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeSlotModelImplCopyWith<_$TimeSlotModelImpl> get copyWith =>
      __$$TimeSlotModelImplCopyWithImpl<_$TimeSlotModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeSlotModelImplToJson(this);
  }
}

abstract class _TimeSlotModel implements TimeSlotModel {
  const factory _TimeSlotModel({
    required final String time,
    required final bool available,
  }) = _$TimeSlotModelImpl;

  factory _TimeSlotModel.fromJson(Map<String, dynamic> json) =
      _$TimeSlotModelImpl.fromJson;

  @override
  String get time;
  @override
  bool get available;

  /// Create a copy of TimeSlotModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeSlotModelImplCopyWith<_$TimeSlotModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AvailableSlotsResponse _$AvailableSlotsResponseFromJson(
  Map<String, dynamic> json,
) {
  return _AvailableSlotsResponse.fromJson(json);
}

/// @nodoc
mixin _$AvailableSlotsResponse {
  @JsonKey(name: 'garage_id')
  int get garageId => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  List<TimeSlotModel> get slots => throw _privateConstructorUsedError;

  /// Serializes this AvailableSlotsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AvailableSlotsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AvailableSlotsResponseCopyWith<AvailableSlotsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvailableSlotsResponseCopyWith<$Res> {
  factory $AvailableSlotsResponseCopyWith(
    AvailableSlotsResponse value,
    $Res Function(AvailableSlotsResponse) then,
  ) = _$AvailableSlotsResponseCopyWithImpl<$Res, AvailableSlotsResponse>;
  @useResult
  $Res call({
    @JsonKey(name: 'garage_id') int garageId,
    String date,
    List<TimeSlotModel> slots,
  });
}

/// @nodoc
class _$AvailableSlotsResponseCopyWithImpl<
  $Res,
  $Val extends AvailableSlotsResponse
>
    implements $AvailableSlotsResponseCopyWith<$Res> {
  _$AvailableSlotsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AvailableSlotsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? garageId = null,
    Object? date = null,
    Object? slots = null,
  }) {
    return _then(
      _value.copyWith(
            garageId: null == garageId
                ? _value.garageId
                : garageId // ignore: cast_nullable_to_non_nullable
                      as int,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            slots: null == slots
                ? _value.slots
                : slots // ignore: cast_nullable_to_non_nullable
                      as List<TimeSlotModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AvailableSlotsResponseImplCopyWith<$Res>
    implements $AvailableSlotsResponseCopyWith<$Res> {
  factory _$$AvailableSlotsResponseImplCopyWith(
    _$AvailableSlotsResponseImpl value,
    $Res Function(_$AvailableSlotsResponseImpl) then,
  ) = __$$AvailableSlotsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'garage_id') int garageId,
    String date,
    List<TimeSlotModel> slots,
  });
}

/// @nodoc
class __$$AvailableSlotsResponseImplCopyWithImpl<$Res>
    extends
        _$AvailableSlotsResponseCopyWithImpl<$Res, _$AvailableSlotsResponseImpl>
    implements _$$AvailableSlotsResponseImplCopyWith<$Res> {
  __$$AvailableSlotsResponseImplCopyWithImpl(
    _$AvailableSlotsResponseImpl _value,
    $Res Function(_$AvailableSlotsResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AvailableSlotsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? garageId = null,
    Object? date = null,
    Object? slots = null,
  }) {
    return _then(
      _$AvailableSlotsResponseImpl(
        garageId: null == garageId
            ? _value.garageId
            : garageId // ignore: cast_nullable_to_non_nullable
                  as int,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        slots: null == slots
            ? _value._slots
            : slots // ignore: cast_nullable_to_non_nullable
                  as List<TimeSlotModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AvailableSlotsResponseImpl implements _AvailableSlotsResponse {
  const _$AvailableSlotsResponseImpl({
    @JsonKey(name: 'garage_id') required this.garageId,
    required this.date,
    required final List<TimeSlotModel> slots,
  }) : _slots = slots;

  factory _$AvailableSlotsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvailableSlotsResponseImplFromJson(json);

  @override
  @JsonKey(name: 'garage_id')
  final int garageId;
  @override
  final String date;
  final List<TimeSlotModel> _slots;
  @override
  List<TimeSlotModel> get slots {
    if (_slots is EqualUnmodifiableListView) return _slots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_slots);
  }

  @override
  String toString() {
    return 'AvailableSlotsResponse(garageId: $garageId, date: $date, slots: $slots)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailableSlotsResponseImpl &&
            (identical(other.garageId, garageId) ||
                other.garageId == garageId) &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other._slots, _slots));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    garageId,
    date,
    const DeepCollectionEquality().hash(_slots),
  );

  /// Create a copy of AvailableSlotsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AvailableSlotsResponseImplCopyWith<_$AvailableSlotsResponseImpl>
  get copyWith =>
      __$$AvailableSlotsResponseImplCopyWithImpl<_$AvailableSlotsResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AvailableSlotsResponseImplToJson(this);
  }
}

abstract class _AvailableSlotsResponse implements AvailableSlotsResponse {
  const factory _AvailableSlotsResponse({
    @JsonKey(name: 'garage_id') required final int garageId,
    required final String date,
    required final List<TimeSlotModel> slots,
  }) = _$AvailableSlotsResponseImpl;

  factory _AvailableSlotsResponse.fromJson(Map<String, dynamic> json) =
      _$AvailableSlotsResponseImpl.fromJson;

  @override
  @JsonKey(name: 'garage_id')
  int get garageId;
  @override
  String get date;
  @override
  List<TimeSlotModel> get slots;

  /// Create a copy of AvailableSlotsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AvailableSlotsResponseImplCopyWith<_$AvailableSlotsResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
