// core/network/models/base_response.dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'base_response.freezed.dart';
part 'base_response.g.dart';

@Freezed(genericArgumentFactories: true)
class BaseResponse<T> with _$BaseResponse<T> {
  const factory BaseResponse({
    required bool success,
    required String message,
    T? data,
    @JsonKey(name: 'error') ErrorResponse? error,
  }) = _BaseResponse<T>;

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$BaseResponseFromJson(json, fromJsonT);
}

@freezed
class ErrorResponse with _$ErrorResponse {
  const factory ErrorResponse({required String message, String? stack}) =
      _ErrorResponse;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);
}
