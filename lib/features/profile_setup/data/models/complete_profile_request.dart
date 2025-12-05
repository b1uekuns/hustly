import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'complete_profile_request.freezed.dart';
part 'complete_profile_request.g.dart';

@freezed
class CompleteProfileRequest with _$CompleteProfileRequest {
  const factory CompleteProfileRequest({
    required String name,
    required String dateOfBirth,
    required String gender,
    String? bio,
    required List<String> interests,
    required String interestedIn,
    String? studentId,
    required String major,
    @JsonKey(name: 'class') required String classField,
    required List<PhotoRequest> photos,
  }) = _CompleteProfileRequest;

  factory CompleteProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$CompleteProfileRequestFromJson(json);
}

@freezed
class PhotoRequest with _$PhotoRequest {
  const factory PhotoRequest({
    required String url,
    String? publicId,
    @Default(false) bool isMain,
  }) = _PhotoRequest;

  factory PhotoRequest.fromJson(Map<String, dynamic> json) =>
      _$PhotoRequestFromJson(json);
}

