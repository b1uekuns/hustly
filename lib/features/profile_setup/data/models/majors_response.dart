import 'package:freezed_annotation/freezed_annotation.dart';

part 'majors_response.freezed.dart';
part 'majors_response.g.dart';

@freezed
class MajorsResponse with _$MajorsResponse {
  const factory MajorsResponse({
    required bool success,
    String? message,
    required MajorsData data,
  }) = _MajorsResponse;

  factory MajorsResponse.fromJson(Map<String, dynamic> json) =>
      _$MajorsResponseFromJson(json);
}

@freezed
class MajorsData with _$MajorsData {
  const factory MajorsData({
    required List<String> majors,
  }) = _MajorsData;

  factory MajorsData.fromJson(Map<String, dynamic> json) =>
      _$MajorsDataFromJson(json);
}

