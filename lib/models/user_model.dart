import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required int id,
    required String phone,
    @Default('') String name,
    @Default('customer') String role,
    String? firebaseUid,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    normalized['firebaseUid'] ??= json['firebase_uid'];
    normalized['createdAt'] ??= json['created_at'];
    normalized['updatedAt'] ??= json['updated_at'];
    return _$UserModelFromJson(normalized);
  }

  bool get isOwner => role == 'owner';
  bool get isCustomer => role == 'customer';
}
