import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: '_id') required String id,
    required String email,
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    String? gender,
    String? bio,
    @Default([]) List<PhotoModel> photos,
    @Default([]) List<String> interests,
    String? interestedIn,
    String? studentId,
    String? major,
    int? year,
    @Default(false) bool isEmailVerified,
    @Default(false) bool isProfileComplete,
    String? lastActive,
    @Default(false) bool isOnline,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

@freezed
class PhotoModel with _$PhotoModel {
  const factory PhotoModel({
    required String url,
    String? publicId,
    @Default(false) bool isMain,
  }) = _PhotoModel;

  factory PhotoModel.fromJson(Map<String, dynamic> json) =>
      _$PhotoModelFromJson(json);
}
