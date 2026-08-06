// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeeklyRevenueDayImpl _$$WeeklyRevenueDayImplFromJson(
  Map<String, dynamic> json,
) => _$WeeklyRevenueDayImpl(
  date: json['date'] as String,
  day: json['day'] as String,
  revenue: json['revenue'] as String,
);

Map<String, dynamic> _$$WeeklyRevenueDayImplToJson(
  _$WeeklyRevenueDayImpl instance,
) => <String, dynamic>{
  'date': instance.date,
  'day': instance.day,
  'revenue': instance.revenue,
};

_$DashboardMetricsImpl _$$DashboardMetricsImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardMetricsImpl(
  todayBookings: (json['today_bookings'] as num?)?.toInt() ?? 0,
  pendingBookings: (json['pending_bookings'] as num?)?.toInt() ?? 0,
  upcomingBookings: (json['upcoming_bookings'] as num?)?.toInt() ?? 0,
  totalCustomers: (json['total_customers'] as num?)?.toInt() ?? 0,
  todayRevenue: json['today_revenue'] as String? ?? '0',
  weeklyRevenue: json['weekly_revenue'] as String? ?? '0',
  weeklyBreakdown:
      (json['weekly_breakdown'] as List<dynamic>?)
          ?.map((e) => WeeklyRevenueDay.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  recentBookings:
      (json['recent_bookings'] as List<dynamic>?)
          ?.map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$DashboardMetricsImplToJson(
  _$DashboardMetricsImpl instance,
) => <String, dynamic>{
  'today_bookings': instance.todayBookings,
  'pending_bookings': instance.pendingBookings,
  'upcoming_bookings': instance.upcomingBookings,
  'total_customers': instance.totalCustomers,
  'today_revenue': instance.todayRevenue,
  'weekly_revenue': instance.weeklyRevenue,
  'weekly_breakdown': instance.weeklyBreakdown,
  'recent_bookings': instance.recentBookings,
};
