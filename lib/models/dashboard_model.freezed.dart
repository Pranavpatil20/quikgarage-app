// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WeeklyRevenueDay _$WeeklyRevenueDayFromJson(Map<String, dynamic> json) {
  return _WeeklyRevenueDay.fromJson(json);
}

/// @nodoc
mixin _$WeeklyRevenueDay {
  String get date => throw _privateConstructorUsedError;
  String get day => throw _privateConstructorUsedError;
  String get revenue => throw _privateConstructorUsedError;

  /// Serializes this WeeklyRevenueDay to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeeklyRevenueDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeeklyRevenueDayCopyWith<WeeklyRevenueDay> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyRevenueDayCopyWith<$Res> {
  factory $WeeklyRevenueDayCopyWith(
    WeeklyRevenueDay value,
    $Res Function(WeeklyRevenueDay) then,
  ) = _$WeeklyRevenueDayCopyWithImpl<$Res, WeeklyRevenueDay>;
  @useResult
  $Res call({String date, String day, String revenue});
}

/// @nodoc
class _$WeeklyRevenueDayCopyWithImpl<$Res, $Val extends WeeklyRevenueDay>
    implements $WeeklyRevenueDayCopyWith<$Res> {
  _$WeeklyRevenueDayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeeklyRevenueDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? day = null, Object? revenue = null}) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            day: null == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                      as String,
            revenue: null == revenue
                ? _value.revenue
                : revenue // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WeeklyRevenueDayImplCopyWith<$Res>
    implements $WeeklyRevenueDayCopyWith<$Res> {
  factory _$$WeeklyRevenueDayImplCopyWith(
    _$WeeklyRevenueDayImpl value,
    $Res Function(_$WeeklyRevenueDayImpl) then,
  ) = __$$WeeklyRevenueDayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String date, String day, String revenue});
}

/// @nodoc
class __$$WeeklyRevenueDayImplCopyWithImpl<$Res>
    extends _$WeeklyRevenueDayCopyWithImpl<$Res, _$WeeklyRevenueDayImpl>
    implements _$$WeeklyRevenueDayImplCopyWith<$Res> {
  __$$WeeklyRevenueDayImplCopyWithImpl(
    _$WeeklyRevenueDayImpl _value,
    $Res Function(_$WeeklyRevenueDayImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WeeklyRevenueDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? day = null, Object? revenue = null}) {
    return _then(
      _$WeeklyRevenueDayImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        day: null == day
            ? _value.day
            : day // ignore: cast_nullable_to_non_nullable
                  as String,
        revenue: null == revenue
            ? _value.revenue
            : revenue // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WeeklyRevenueDayImpl implements _WeeklyRevenueDay {
  const _$WeeklyRevenueDayImpl({
    required this.date,
    required this.day,
    required this.revenue,
  });

  factory _$WeeklyRevenueDayImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeklyRevenueDayImplFromJson(json);

  @override
  final String date;
  @override
  final String day;
  @override
  final String revenue;

  @override
  String toString() {
    return 'WeeklyRevenueDay(date: $date, day: $day, revenue: $revenue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyRevenueDayImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.revenue, revenue) || other.revenue == revenue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, day, revenue);

  /// Create a copy of WeeklyRevenueDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyRevenueDayImplCopyWith<_$WeeklyRevenueDayImpl> get copyWith =>
      __$$WeeklyRevenueDayImplCopyWithImpl<_$WeeklyRevenueDayImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeklyRevenueDayImplToJson(this);
  }
}

abstract class _WeeklyRevenueDay implements WeeklyRevenueDay {
  const factory _WeeklyRevenueDay({
    required final String date,
    required final String day,
    required final String revenue,
  }) = _$WeeklyRevenueDayImpl;

  factory _WeeklyRevenueDay.fromJson(Map<String, dynamic> json) =
      _$WeeklyRevenueDayImpl.fromJson;

  @override
  String get date;
  @override
  String get day;
  @override
  String get revenue;

  /// Create a copy of WeeklyRevenueDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeeklyRevenueDayImplCopyWith<_$WeeklyRevenueDayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DashboardMetrics _$DashboardMetricsFromJson(Map<String, dynamic> json) {
  return _DashboardMetrics.fromJson(json);
}

/// @nodoc
mixin _$DashboardMetrics {
  @JsonKey(name: 'today_bookings')
  int get todayBookings => throw _privateConstructorUsedError;
  @JsonKey(name: 'pending_bookings')
  int get pendingBookings => throw _privateConstructorUsedError;
  @JsonKey(name: 'upcoming_bookings')
  int get upcomingBookings => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_customers')
  int get totalCustomers => throw _privateConstructorUsedError;
  @JsonKey(name: 'today_revenue')
  String get todayRevenue => throw _privateConstructorUsedError;
  @JsonKey(name: 'weekly_revenue')
  String get weeklyRevenue => throw _privateConstructorUsedError;
  @JsonKey(name: 'weekly_breakdown')
  List<WeeklyRevenueDay> get weeklyBreakdown =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'recent_bookings')
  List<BookingModel> get recentBookings => throw _privateConstructorUsedError;

  /// Serializes this DashboardMetrics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardMetricsCopyWith<DashboardMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardMetricsCopyWith<$Res> {
  factory $DashboardMetricsCopyWith(
    DashboardMetrics value,
    $Res Function(DashboardMetrics) then,
  ) = _$DashboardMetricsCopyWithImpl<$Res, DashboardMetrics>;
  @useResult
  $Res call({
    @JsonKey(name: 'today_bookings') int todayBookings,
    @JsonKey(name: 'pending_bookings') int pendingBookings,
    @JsonKey(name: 'upcoming_bookings') int upcomingBookings,
    @JsonKey(name: 'total_customers') int totalCustomers,
    @JsonKey(name: 'today_revenue') String todayRevenue,
    @JsonKey(name: 'weekly_revenue') String weeklyRevenue,
    @JsonKey(name: 'weekly_breakdown') List<WeeklyRevenueDay> weeklyBreakdown,
    @JsonKey(name: 'recent_bookings') List<BookingModel> recentBookings,
  });
}

/// @nodoc
class _$DashboardMetricsCopyWithImpl<$Res, $Val extends DashboardMetrics>
    implements $DashboardMetricsCopyWith<$Res> {
  _$DashboardMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? todayBookings = null,
    Object? pendingBookings = null,
    Object? upcomingBookings = null,
    Object? totalCustomers = null,
    Object? todayRevenue = null,
    Object? weeklyRevenue = null,
    Object? weeklyBreakdown = null,
    Object? recentBookings = null,
  }) {
    return _then(
      _value.copyWith(
            todayBookings: null == todayBookings
                ? _value.todayBookings
                : todayBookings // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingBookings: null == pendingBookings
                ? _value.pendingBookings
                : pendingBookings // ignore: cast_nullable_to_non_nullable
                      as int,
            upcomingBookings: null == upcomingBookings
                ? _value.upcomingBookings
                : upcomingBookings // ignore: cast_nullable_to_non_nullable
                      as int,
            totalCustomers: null == totalCustomers
                ? _value.totalCustomers
                : totalCustomers // ignore: cast_nullable_to_non_nullable
                      as int,
            todayRevenue: null == todayRevenue
                ? _value.todayRevenue
                : todayRevenue // ignore: cast_nullable_to_non_nullable
                      as String,
            weeklyRevenue: null == weeklyRevenue
                ? _value.weeklyRevenue
                : weeklyRevenue // ignore: cast_nullable_to_non_nullable
                      as String,
            weeklyBreakdown: null == weeklyBreakdown
                ? _value.weeklyBreakdown
                : weeklyBreakdown // ignore: cast_nullable_to_non_nullable
                      as List<WeeklyRevenueDay>,
            recentBookings: null == recentBookings
                ? _value.recentBookings
                : recentBookings // ignore: cast_nullable_to_non_nullable
                      as List<BookingModel>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DashboardMetricsImplCopyWith<$Res>
    implements $DashboardMetricsCopyWith<$Res> {
  factory _$$DashboardMetricsImplCopyWith(
    _$DashboardMetricsImpl value,
    $Res Function(_$DashboardMetricsImpl) then,
  ) = __$$DashboardMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'today_bookings') int todayBookings,
    @JsonKey(name: 'pending_bookings') int pendingBookings,
    @JsonKey(name: 'upcoming_bookings') int upcomingBookings,
    @JsonKey(name: 'total_customers') int totalCustomers,
    @JsonKey(name: 'today_revenue') String todayRevenue,
    @JsonKey(name: 'weekly_revenue') String weeklyRevenue,
    @JsonKey(name: 'weekly_breakdown') List<WeeklyRevenueDay> weeklyBreakdown,
    @JsonKey(name: 'recent_bookings') List<BookingModel> recentBookings,
  });
}

/// @nodoc
class __$$DashboardMetricsImplCopyWithImpl<$Res>
    extends _$DashboardMetricsCopyWithImpl<$Res, _$DashboardMetricsImpl>
    implements _$$DashboardMetricsImplCopyWith<$Res> {
  __$$DashboardMetricsImplCopyWithImpl(
    _$DashboardMetricsImpl _value,
    $Res Function(_$DashboardMetricsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? todayBookings = null,
    Object? pendingBookings = null,
    Object? upcomingBookings = null,
    Object? totalCustomers = null,
    Object? todayRevenue = null,
    Object? weeklyRevenue = null,
    Object? weeklyBreakdown = null,
    Object? recentBookings = null,
  }) {
    return _then(
      _$DashboardMetricsImpl(
        todayBookings: null == todayBookings
            ? _value.todayBookings
            : todayBookings // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingBookings: null == pendingBookings
            ? _value.pendingBookings
            : pendingBookings // ignore: cast_nullable_to_non_nullable
                  as int,
        upcomingBookings: null == upcomingBookings
            ? _value.upcomingBookings
            : upcomingBookings // ignore: cast_nullable_to_non_nullable
                  as int,
        totalCustomers: null == totalCustomers
            ? _value.totalCustomers
            : totalCustomers // ignore: cast_nullable_to_non_nullable
                  as int,
        todayRevenue: null == todayRevenue
            ? _value.todayRevenue
            : todayRevenue // ignore: cast_nullable_to_non_nullable
                  as String,
        weeklyRevenue: null == weeklyRevenue
            ? _value.weeklyRevenue
            : weeklyRevenue // ignore: cast_nullable_to_non_nullable
                  as String,
        weeklyBreakdown: null == weeklyBreakdown
            ? _value._weeklyBreakdown
            : weeklyBreakdown // ignore: cast_nullable_to_non_nullable
                  as List<WeeklyRevenueDay>,
        recentBookings: null == recentBookings
            ? _value._recentBookings
            : recentBookings // ignore: cast_nullable_to_non_nullable
                  as List<BookingModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardMetricsImpl implements _DashboardMetrics {
  const _$DashboardMetricsImpl({
    @JsonKey(name: 'today_bookings') this.todayBookings = 0,
    @JsonKey(name: 'pending_bookings') this.pendingBookings = 0,
    @JsonKey(name: 'upcoming_bookings') this.upcomingBookings = 0,
    @JsonKey(name: 'total_customers') this.totalCustomers = 0,
    @JsonKey(name: 'today_revenue') this.todayRevenue = '0',
    @JsonKey(name: 'weekly_revenue') this.weeklyRevenue = '0',
    @JsonKey(name: 'weekly_breakdown')
    final List<WeeklyRevenueDay> weeklyBreakdown = const [],
    @JsonKey(name: 'recent_bookings')
    final List<BookingModel> recentBookings = const [],
  }) : _weeklyBreakdown = weeklyBreakdown,
       _recentBookings = recentBookings;

  factory _$DashboardMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardMetricsImplFromJson(json);

  @override
  @JsonKey(name: 'today_bookings')
  final int todayBookings;
  @override
  @JsonKey(name: 'pending_bookings')
  final int pendingBookings;
  @override
  @JsonKey(name: 'upcoming_bookings')
  final int upcomingBookings;
  @override
  @JsonKey(name: 'total_customers')
  final int totalCustomers;
  @override
  @JsonKey(name: 'today_revenue')
  final String todayRevenue;
  @override
  @JsonKey(name: 'weekly_revenue')
  final String weeklyRevenue;
  final List<WeeklyRevenueDay> _weeklyBreakdown;
  @override
  @JsonKey(name: 'weekly_breakdown')
  List<WeeklyRevenueDay> get weeklyBreakdown {
    if (_weeklyBreakdown is EqualUnmodifiableListView) return _weeklyBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weeklyBreakdown);
  }

  final List<BookingModel> _recentBookings;
  @override
  @JsonKey(name: 'recent_bookings')
  List<BookingModel> get recentBookings {
    if (_recentBookings is EqualUnmodifiableListView) return _recentBookings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentBookings);
  }

  @override
  String toString() {
    return 'DashboardMetrics(todayBookings: $todayBookings, pendingBookings: $pendingBookings, upcomingBookings: $upcomingBookings, totalCustomers: $totalCustomers, todayRevenue: $todayRevenue, weeklyRevenue: $weeklyRevenue, weeklyBreakdown: $weeklyBreakdown, recentBookings: $recentBookings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardMetricsImpl &&
            (identical(other.todayBookings, todayBookings) ||
                other.todayBookings == todayBookings) &&
            (identical(other.pendingBookings, pendingBookings) ||
                other.pendingBookings == pendingBookings) &&
            (identical(other.upcomingBookings, upcomingBookings) ||
                other.upcomingBookings == upcomingBookings) &&
            (identical(other.totalCustomers, totalCustomers) ||
                other.totalCustomers == totalCustomers) &&
            (identical(other.todayRevenue, todayRevenue) ||
                other.todayRevenue == todayRevenue) &&
            (identical(other.weeklyRevenue, weeklyRevenue) ||
                other.weeklyRevenue == weeklyRevenue) &&
            const DeepCollectionEquality().equals(
              other._weeklyBreakdown,
              _weeklyBreakdown,
            ) &&
            const DeepCollectionEquality().equals(
              other._recentBookings,
              _recentBookings,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    todayBookings,
    pendingBookings,
    upcomingBookings,
    totalCustomers,
    todayRevenue,
    weeklyRevenue,
    const DeepCollectionEquality().hash(_weeklyBreakdown),
    const DeepCollectionEquality().hash(_recentBookings),
  );

  /// Create a copy of DashboardMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardMetricsImplCopyWith<_$DashboardMetricsImpl> get copyWith =>
      __$$DashboardMetricsImplCopyWithImpl<_$DashboardMetricsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardMetricsImplToJson(this);
  }
}

abstract class _DashboardMetrics implements DashboardMetrics {
  const factory _DashboardMetrics({
    @JsonKey(name: 'today_bookings') final int todayBookings,
    @JsonKey(name: 'pending_bookings') final int pendingBookings,
    @JsonKey(name: 'upcoming_bookings') final int upcomingBookings,
    @JsonKey(name: 'total_customers') final int totalCustomers,
    @JsonKey(name: 'today_revenue') final String todayRevenue,
    @JsonKey(name: 'weekly_revenue') final String weeklyRevenue,
    @JsonKey(name: 'weekly_breakdown')
    final List<WeeklyRevenueDay> weeklyBreakdown,
    @JsonKey(name: 'recent_bookings') final List<BookingModel> recentBookings,
  }) = _$DashboardMetricsImpl;

  factory _DashboardMetrics.fromJson(Map<String, dynamic> json) =
      _$DashboardMetricsImpl.fromJson;

  @override
  @JsonKey(name: 'today_bookings')
  int get todayBookings;
  @override
  @JsonKey(name: 'pending_bookings')
  int get pendingBookings;
  @override
  @JsonKey(name: 'upcoming_bookings')
  int get upcomingBookings;
  @override
  @JsonKey(name: 'total_customers')
  int get totalCustomers;
  @override
  @JsonKey(name: 'today_revenue')
  String get todayRevenue;
  @override
  @JsonKey(name: 'weekly_revenue')
  String get weeklyRevenue;
  @override
  @JsonKey(name: 'weekly_breakdown')
  List<WeeklyRevenueDay> get weeklyBreakdown;
  @override
  @JsonKey(name: 'recent_bookings')
  List<BookingModel> get recentBookings;

  /// Create a copy of DashboardMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardMetricsImplCopyWith<_$DashboardMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
