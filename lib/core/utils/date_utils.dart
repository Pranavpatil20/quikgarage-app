import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract final class AppDateUtils {
  static final _apiDate = DateFormat('yyyy-MM-dd');

  static String formatDisplayDate(DateTime date, {String? locale}) =>
      DateFormat('d MMM yyyy', locale).format(date);

  /// e.g. "12 Aug 2026, 9:00 AM"
  static String formatBookingDateTime(
    String bookingDate,
    String timeSlot, {
    String? locale,
  }) {
    final date = parseApiDate(bookingDate);
    final time = formatTime(timeSlot, locale: locale);
    return '${formatDisplayDate(date, locale: locale)}, $time';
  }

  static String toApiDate(DateTime date) => _apiDate.format(date);

  static String formatTime(String time24, {String? locale}) {
    final raw = time24.trim();
    if (raw.isEmpty) return raw;
    final parts = raw.split(':');
    if (parts.length < 2) return time24;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1].split('.').first) ?? 0;
    final dt = DateTime(2000, 1, 1, hour, minute);
    return DateFormat('h:mm a', locale).format(dt);
  }

  static DateTime parseApiDate(String date) => _apiDate.parse(date);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// True when [date] + [time] is still in the future.
  static bool isDateTimeInFuture(DateTime date, TimeOfDay time) {
    final now = DateTime.now();
    final slot = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return slot.isAfter(now);
  }

  static TimeOfDay nextAvailableTime({DateTime? forDate}) {
    final now = DateTime.now();
    final date = forDate ?? now;
    if (!isSameDay(date, now)) {
      return const TimeOfDay(hour: 9, minute: 0);
    }
    final hour = (now.hour + 1).clamp(0, 23);
    return TimeOfDay(hour: hour, minute: 0);
  }

  static TimeOfDay? parseTimeOfDay(String raw) {
    final parts = raw.trim().split(':');
    if (parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1].split('.').first);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  static int _minutes(TimeOfDay t) => t.hour * 60 + t.minute;

  /// Garage hours are [open, close) — closing time itself is not bookable.
  static bool isWithinGarageHours(
    TimeOfDay time, {
    required TimeOfDay open,
    required TimeOfDay close,
  }) {
    final m = _minutes(time);
    return m >= _minutes(open) && m < _minutes(close);
  }

  static String formatHoursRange(TimeOfDay open, TimeOfDay close, {String? locale}) {
    final openLabel = formatTime(
      '${open.hour.toString().padLeft(2, '0')}:${open.minute.toString().padLeft(2, '0')}',
      locale: locale,
    );
    final closeLabel = formatTime(
      '${close.hour.toString().padLeft(2, '0')}:${close.minute.toString().padLeft(2, '0')}',
      locale: locale,
    );
    return '$openLabel and $closeLabel';
  }
}
