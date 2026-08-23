// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

InvoiceModel _$InvoiceModelFromJson(Map<String, dynamic> json) {
  return _InvoiceModel.fromJson(json);
}

/// @nodoc
mixin _$InvoiceModel {
  int get id => throw _privateConstructorUsedError;
  int? get booking => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_detail')
  BookingModel? get bookingDetail => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_cost')
  String get serviceCost => throw _privateConstructorUsedError;
  @JsonKey(name: 'parts_cost')
  String get partsCost => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  String get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'line_items')
  List<Map<String, dynamic>> get lineItems =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status')
  String get paymentStatus => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this InvoiceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InvoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InvoiceModelCopyWith<InvoiceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceModelCopyWith<$Res> {
  factory $InvoiceModelCopyWith(
    InvoiceModel value,
    $Res Function(InvoiceModel) then,
  ) = _$InvoiceModelCopyWithImpl<$Res, InvoiceModel>;
  @useResult
  $Res call({
    int id,
    int? booking,
    @JsonKey(name: 'booking_detail') BookingModel? bookingDetail,
    @JsonKey(name: 'service_cost') String serviceCost,
    @JsonKey(name: 'parts_cost') String partsCost,
    @JsonKey(name: 'total_amount') String totalAmount,
    @JsonKey(name: 'line_items') List<Map<String, dynamic>> lineItems,
    @JsonKey(name: 'payment_status') String paymentStatus,
    DateTime? createdAt,
  });

  $BookingModelCopyWith<$Res>? get bookingDetail;
}

/// @nodoc
class _$InvoiceModelCopyWithImpl<$Res, $Val extends InvoiceModel>
    implements $InvoiceModelCopyWith<$Res> {
  _$InvoiceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InvoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? booking = freezed,
    Object? bookingDetail = freezed,
    Object? serviceCost = null,
    Object? partsCost = null,
    Object? totalAmount = null,
    Object? lineItems = null,
    Object? paymentStatus = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            booking: freezed == booking
                ? _value.booking
                : booking // ignore: cast_nullable_to_non_nullable
                      as int?,
            bookingDetail: freezed == bookingDetail
                ? _value.bookingDetail
                : bookingDetail // ignore: cast_nullable_to_non_nullable
                      as BookingModel?,
            serviceCost: null == serviceCost
                ? _value.serviceCost
                : serviceCost // ignore: cast_nullable_to_non_nullable
                      as String,
            partsCost: null == partsCost
                ? _value.partsCost
                : partsCost // ignore: cast_nullable_to_non_nullable
                      as String,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as String,
            lineItems: null == lineItems
                ? _value.lineItems
                : lineItems // ignore: cast_nullable_to_non_nullable
                      as List<Map<String, dynamic>>,
            paymentStatus: null == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of InvoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookingModelCopyWith<$Res>? get bookingDetail {
    if (_value.bookingDetail == null) {
      return null;
    }

    return $BookingModelCopyWith<$Res>(_value.bookingDetail!, (value) {
      return _then(_value.copyWith(bookingDetail: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InvoiceModelImplCopyWith<$Res>
    implements $InvoiceModelCopyWith<$Res> {
  factory _$$InvoiceModelImplCopyWith(
    _$InvoiceModelImpl value,
    $Res Function(_$InvoiceModelImpl) then,
  ) = __$$InvoiceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int? booking,
    @JsonKey(name: 'booking_detail') BookingModel? bookingDetail,
    @JsonKey(name: 'service_cost') String serviceCost,
    @JsonKey(name: 'parts_cost') String partsCost,
    @JsonKey(name: 'total_amount') String totalAmount,
    @JsonKey(name: 'line_items') List<Map<String, dynamic>> lineItems,
    @JsonKey(name: 'payment_status') String paymentStatus,
    DateTime? createdAt,
  });

  @override
  $BookingModelCopyWith<$Res>? get bookingDetail;
}

/// @nodoc
class __$$InvoiceModelImplCopyWithImpl<$Res>
    extends _$InvoiceModelCopyWithImpl<$Res, _$InvoiceModelImpl>
    implements _$$InvoiceModelImplCopyWith<$Res> {
  __$$InvoiceModelImplCopyWithImpl(
    _$InvoiceModelImpl _value,
    $Res Function(_$InvoiceModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InvoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? booking = freezed,
    Object? bookingDetail = freezed,
    Object? serviceCost = null,
    Object? partsCost = null,
    Object? totalAmount = null,
    Object? lineItems = null,
    Object? paymentStatus = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$InvoiceModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        booking: freezed == booking
            ? _value.booking
            : booking // ignore: cast_nullable_to_non_nullable
                  as int?,
        bookingDetail: freezed == bookingDetail
            ? _value.bookingDetail
            : bookingDetail // ignore: cast_nullable_to_non_nullable
                  as BookingModel?,
        serviceCost: null == serviceCost
            ? _value.serviceCost
            : serviceCost // ignore: cast_nullable_to_non_nullable
                  as String,
        partsCost: null == partsCost
            ? _value.partsCost
            : partsCost // ignore: cast_nullable_to_non_nullable
                  as String,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as String,
        lineItems: null == lineItems
            ? _value._lineItems
            : lineItems // ignore: cast_nullable_to_non_nullable
                  as List<Map<String, dynamic>>,
        paymentStatus: null == paymentStatus
            ? _value.paymentStatus
            : paymentStatus // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$InvoiceModelImpl implements _InvoiceModel {
  const _$InvoiceModelImpl({
    required this.id,
    this.booking,
    @JsonKey(name: 'booking_detail') this.bookingDetail,
    @JsonKey(name: 'service_cost') this.serviceCost = '0.00',
    @JsonKey(name: 'parts_cost') this.partsCost = '0.00',
    @JsonKey(name: 'total_amount') this.totalAmount = '0.00',
    @JsonKey(name: 'line_items')
    final List<Map<String, dynamic>> lineItems = const <Map<String, dynamic>>[],
    @JsonKey(name: 'payment_status') this.paymentStatus = 'pending',
    this.createdAt,
  }) : _lineItems = lineItems;

  factory _$InvoiceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvoiceModelImplFromJson(json);

  @override
  final int id;
  @override
  final int? booking;
  @override
  @JsonKey(name: 'booking_detail')
  final BookingModel? bookingDetail;
  @override
  @JsonKey(name: 'service_cost')
  final String serviceCost;
  @override
  @JsonKey(name: 'parts_cost')
  final String partsCost;
  @override
  @JsonKey(name: 'total_amount')
  final String totalAmount;
  final List<Map<String, dynamic>> _lineItems;
  @override
  @JsonKey(name: 'line_items')
  List<Map<String, dynamic>> get lineItems {
    if (_lineItems is EqualUnmodifiableListView) return _lineItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lineItems);
  }

  @override
  @JsonKey(name: 'payment_status')
  final String paymentStatus;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'InvoiceModel(id: $id, booking: $booking, bookingDetail: $bookingDetail, serviceCost: $serviceCost, partsCost: $partsCost, totalAmount: $totalAmount, lineItems: $lineItems, paymentStatus: $paymentStatus, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.booking, booking) || other.booking == booking) &&
            (identical(other.bookingDetail, bookingDetail) ||
                other.bookingDetail == bookingDetail) &&
            (identical(other.serviceCost, serviceCost) ||
                other.serviceCost == serviceCost) &&
            (identical(other.partsCost, partsCost) ||
                other.partsCost == partsCost) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            const DeepCollectionEquality().equals(
              other._lineItems,
              _lineItems,
            ) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    booking,
    bookingDetail,
    serviceCost,
    partsCost,
    totalAmount,
    const DeepCollectionEquality().hash(_lineItems),
    paymentStatus,
    createdAt,
  );

  /// Create a copy of InvoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceModelImplCopyWith<_$InvoiceModelImpl> get copyWith =>
      __$$InvoiceModelImplCopyWithImpl<_$InvoiceModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InvoiceModelImplToJson(this);
  }
}

abstract class _InvoiceModel implements InvoiceModel {
  const factory _InvoiceModel({
    required final int id,
    final int? booking,
    @JsonKey(name: 'booking_detail') final BookingModel? bookingDetail,
    @JsonKey(name: 'service_cost') final String serviceCost,
    @JsonKey(name: 'parts_cost') final String partsCost,
    @JsonKey(name: 'total_amount') final String totalAmount,
    @JsonKey(name: 'line_items') final List<Map<String, dynamic>> lineItems,
    @JsonKey(name: 'payment_status') final String paymentStatus,
    final DateTime? createdAt,
  }) = _$InvoiceModelImpl;

  factory _InvoiceModel.fromJson(Map<String, dynamic> json) =
      _$InvoiceModelImpl.fromJson;

  @override
  int get id;
  @override
  int? get booking;
  @override
  @JsonKey(name: 'booking_detail')
  BookingModel? get bookingDetail;
  @override
  @JsonKey(name: 'service_cost')
  String get serviceCost;
  @override
  @JsonKey(name: 'parts_cost')
  String get partsCost;
  @override
  @JsonKey(name: 'total_amount')
  String get totalAmount;
  @override
  @JsonKey(name: 'line_items')
  List<Map<String, dynamic>> get lineItems;
  @override
  @JsonKey(name: 'payment_status')
  String get paymentStatus;
  @override
  DateTime? get createdAt;

  /// Create a copy of InvoiceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvoiceModelImplCopyWith<_$InvoiceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
