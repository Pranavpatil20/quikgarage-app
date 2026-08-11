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

@freezed
class GarageModel with _$GarageModel {
  const GarageModel._();

  const factory GarageModel({
    required int id,
    @JsonKey(name: 'garage_name') required String garageName,
    required String address,
    @JsonKey(name: 'opening_time') required String openingTime,
    @JsonKey(name: 'closing_time') required String closingTime,
    @JsonKey(name: 'default_service_cost', fromJson: _costFromJson)
    @Default('899.00')
    String defaultServiceCost,
    int? owner,
    @JsonKey(name: 'owner_name') String? ownerName,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _GarageModel;

  factory GarageModel.fromJson(Map<String, dynamic> json) =>
      _$GarageModelFromJson(json);

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
