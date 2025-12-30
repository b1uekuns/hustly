import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../auth/data/models/user_model/user_model.dart';

part 'complete_profile_response.freezed.dart';
part 'complete_profile_response.g.dart';

@freezed
class CompleteProfileResponse with _$CompleteProfileResponse {
  const factory CompleteProfileResponse({
    required bool success,
    required String message,
    required UserModel data,
  }) = _CompleteProfileResponse;

  factory CompleteProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$CompleteProfileResponseFromJson(json);
}
