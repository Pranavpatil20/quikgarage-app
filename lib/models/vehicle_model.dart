import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle_model.freezed.dart';
part 'vehicle_model.g.dart';

@freezed
class VehicleModel with _$VehicleModel {
  const VehicleModel._();

  const factory VehicleModel({
    required int id,
    int? customer,
    @JsonKey(name: 'vehicle_number') required String vehicleNumber,
    @JsonKey(name: 'vehicle_type') @Default('car') String vehicleType,
    @JsonKey(name: 'make_model') @Default('') String makeModel,
    @JsonKey(name: 'is_primary') @Default(false) bool isPrimary,
    DateTime? createdAt,
  }) = _VehicleModel;

  factory VehicleModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleModelFromJson(json);

  String get displayName =>
      makeModel.isNotEmpty ? makeModel : vehicleType.toUpperCase();
}
