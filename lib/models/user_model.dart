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
    @JsonKey(name: 'firebase_uid') String? firebaseUid,
    @JsonKey(name: 'trial_ends_at') DateTime? trialEndsAt,
    @JsonKey(name: 'subscription_paid_until') DateTime? subscriptionPaidUntil,
    @JsonKey(name: 'subscription_active') @Default(true) bool subscriptionActive,
    @JsonKey(name: 'is_payment_locked') @Default(false) bool isPaymentLocked,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  bool get isOwner => role == 'owner';
  bool get isCustomer => role == 'customer';
  bool get isOwnerLocked => isOwner && isPaymentLocked;
}

String ownerHomeRoute(UserModel user) {
  if (user.isOwnerLocked) return '/owner/payment-lock';
  return '/owner';
}
