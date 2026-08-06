import 'package:freezed_annotation/freezed_annotation.dart';

import 'booking_model.dart';

part 'dashboard_model.freezed.dart';
part 'dashboard_model.g.dart';

@freezed
class WeeklyRevenueDay with _$WeeklyRevenueDay {
  const factory WeeklyRevenueDay({
    required String date,
    required String day,
    required String revenue,
  }) = _WeeklyRevenueDay;

  factory WeeklyRevenueDay.fromJson(Map<String, dynamic> json) =>
      _$WeeklyRevenueDayFromJson(json);
}

@freezed
class DashboardMetrics with _$DashboardMetrics {
  const factory DashboardMetrics({
    @JsonKey(name: 'today_bookings') @Default(0) int todayBookings,
    @JsonKey(name: 'pending_bookings') @Default(0) int pendingBookings,
    @JsonKey(name: 'upcoming_bookings') @Default(0) int upcomingBookings,
    @JsonKey(name: 'total_customers') @Default(0) int totalCustomers,
    @JsonKey(name: 'today_revenue') @Default('0') String todayRevenue,
    @JsonKey(name: 'weekly_revenue') @Default('0') String weeklyRevenue,
    @JsonKey(name: 'weekly_breakdown')
    @Default([])
    List<WeeklyRevenueDay> weeklyBreakdown,
    @JsonKey(name: 'recent_bookings')
    @Default([])
    List<BookingModel> recentBookings,
  }) = _DashboardMetrics;

  factory DashboardMetrics.fromJson(Map<String, dynamic> json) =>
      _$DashboardMetricsFromJson(json);
}
