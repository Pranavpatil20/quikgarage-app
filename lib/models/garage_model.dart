import 'package:freezed_annotation/freezed_annotation.dart';

part 'garage_model.freezed.dart';
part 'garage_model.g.dart';

String _costFromJson(Object? value) {
  if (value == null) return '899.00';
  final raw = value.toString().trim();
  if (raw.isEmpty) return '899.00';
  final parsed = double.tryParse(raw);
  if (parsed == null) return '899.00';
  return parsed.toStringAsFixed(2);
}

Map<String, dynamic> _weeklyHoursFromJson(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((k, v) => MapEntry(k.toString(), v));
  }
  return const <String, dynamic>{};
}

const List<String> kWeekdayKeys = [
  'mon',
  'tue',
  'wed',
  'thu',
  'fri',
  'sat',
  'sun',
];

const Map<String, String> kWeekdayLabels = {
  'mon': 'Monday',
  'tue': 'Tuesday',
  'wed': 'Wednesday',
  'thu': 'Thursday',
  'fri': 'Friday',
  'sat': 'Saturday',
  'sun': 'Sunday',
};

@freezed
class GarageModel with _$GarageModel {
  const GarageModel._();

  const factory GarageModel({
    required int id,
    @JsonKey(name: 'garage_name') required String garageName,
    required String address,
    @JsonKey(name: 'opening_time') required String openingTime,
    @JsonKey(name: 'closing_time') required String closingTime,
    @JsonKey(name: 'weekly_hours', fromJson: _weeklyHoursFromJson)
    @Default(<String, dynamic>{})
    Map<String, dynamic> weeklyHours,
    @JsonKey(name: 'default_service_cost', fromJson: _costFromJson)
    @Default('899.00')
    String defaultServiceCost,
    @JsonKey(name: 'service_rates') @Default(<String, dynamic>{})
    Map<String, dynamic> serviceRates,
    @JsonKey(name: 'part_rates') @Default(<String, dynamic>{})
    Map<String, dynamic> partRates,
    int? owner,
    @JsonKey(name: 'owner_name') String? ownerName,
    @JsonKey(name: 'owner_phone') String? ownerPhone,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _GarageModel;

  factory GarageModel.fromJson(Map<String, dynamic> json) =>
      _$GarageModelFromJson(json);

  static String weekdayKey(DateTime date) => kWeekdayKeys[date.weekday - 1];

  String get displayServiceCost {
    final parsed = double.tryParse(defaultServiceCost);
    if (parsed == null) return defaultServiceCost;
    if (parsed == parsed.roundToDouble()) {
      return parsed.toInt().toString();
    }
    return parsed.toStringAsFixed(2);
  }

  String get formattedHours {
    String fmt(String t) {
      final parts = t.split(':');
      if (parts.length < 2) return t;
      final h = int.tryParse(parts[0]) ?? 0;
      final m = int.tryParse(parts[1]) ?? 0;
      final tod = TimeOfDayLike(h, m);
      return tod.format12h();
    }

    return '${fmt(openingTime)} - ${fmt(closingTime)}';
  }

  bool isOpenOnDate(DateTime date) {
    final day = weeklyHours[weekdayKey(date)];
    if (day is! Map) return true;
    final open = day['open'];
    if (open is bool) return open;
    if (open is String) {
      final v = open.toLowerCase().trim();
      return v == '1' || v == 'true' || v == 'yes' || v == 'on';
    }
    return true;
  }

  /// Returns opening/closing for [date], or null if closed that day.
  ({String opening, String closing})? hoursForDate(DateTime date) {
    if (!isOpenOnDate(date)) return null;
    final day = weeklyHours[weekdayKey(date)];
    var opening = openingTime;
    var closing = closingTime;
    if (day is Map) {
      final o = day['opening_time']?.toString();
      final c = day['closing_time']?.toString();
      if (o != null && o.isNotEmpty) opening = o;
      if (c != null && c.isNotEmpty) closing = c;
    }
    return (opening: opening, closing: closing);
  }
}

class TimeOfDayLike {
  TimeOfDayLike(this.hour, this.minute);
  final int hour;
  final int minute;

  String format12h() {
    final period = hour >= 12 ? 'PM' : 'AM';
    final h12 = hour % 12 == 0 ? 12 : hour % 12;
    return '${h12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }
}
