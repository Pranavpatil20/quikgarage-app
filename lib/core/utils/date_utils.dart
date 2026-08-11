import 'package:intl/intl.dart';

abstract final class AppDateUtils {
  static final _apiDate = DateFormat('yyyy-MM-dd');

  static String formatDisplayDate(DateTime date, {String? locale}) =>
      DateFormat('MMM d, yyyy', locale).format(date);

  static String toApiDate(DateTime date) => _apiDate.format(date);

  static String formatTime(String time24, {String? locale}) {
    final parts = time24.split(':');
    if (parts.length < 2) return time24;
    final dt = DateTime(2000, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
    return DateFormat('hh:mm a', locale).format(dt);
  }

  static DateTime parseApiDate(String date) => _apiDate.parse(date);
}
