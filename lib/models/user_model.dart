import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';

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
    DateTime? parseDt(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      return DateTime.tryParse(value.toString());
    }

    return UserModel(
      id: (json['id'] as num).toInt(),
      phone: json['phone'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? 'customer',
      firebaseUid: json['firebaseUid'] as String? ?? json['firebase_uid'] as String?,
      createdAt: parseDt(json['createdAt'] ?? json['created_at']),
      updatedAt: parseDt(json['updatedAt'] ?? json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'phone': phone,
        'name': name,
        'role': role,
        'firebaseUid': firebaseUid,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  bool get isOwner => role == 'owner';
  bool get isCustomer => role == 'customer';
}
