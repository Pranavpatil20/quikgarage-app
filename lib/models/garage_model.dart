import 'package:freezed_annotation/freezed_annotation.dart';

part 'garage_model.freezed.dart';
part 'garage_model.g.dart';

@freezed
class GarageModel with _$GarageModel {
  const factory GarageModel({
    required int id,
  @JsonKey(name: 'garage_name') required String garageName,
    required String address,
    @JsonKey(name: 'opening_time') required String openingTime,
    @JsonKey(name: 'closing_time') required String closingTime,
    int? owner,
    @JsonKey(name: 'owner_name') String? ownerName,
    DateTime? createdAt,
  }) = _GarageModel;

  factory GarageModel.fromJson(Map<String, dynamic> json) =>
      _$GarageModelFromJson(json);
}
