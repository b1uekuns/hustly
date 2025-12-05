import 'package:freezed_annotation/freezed_annotation.dart';

part 'interests_response.freezed.dart';
part 'interests_response.g.dart';

@freezed
class InterestsResponse with _$InterestsResponse {
  const factory InterestsResponse({
    required bool success,
    String? message,
    required InterestsData data,
  }) = _InterestsResponse;

  factory InterestsResponse.fromJson(Map<String, dynamic> json) =>
      _$InterestsResponseFromJson(json);
}

@freezed
class InterestsData with _$InterestsData {
  const factory InterestsData({
    required List<InterestCategory> interests,
    @Default(0) int total,
  }) = _InterestsData;

  factory InterestsData.fromJson(Map<String, dynamic> json) =>
      _$InterestsDataFromJson(json);
}

@freezed
class InterestCategory with _$InterestCategory {
  const factory InterestCategory({
    required String category,
    required String icon,
    required List<InterestItem> items,
  }) = _InterestCategory;

  factory InterestCategory.fromJson(Map<String, dynamic> json) =>
      _$InterestCategoryFromJson(json);
}

@freezed
class InterestItem with _$InterestItem {
  const factory InterestItem({
    required String id,
    required String label,
    required String icon,
  }) = _InterestItem;

  factory InterestItem.fromJson(Map<String, dynamic> json) =>
      _$InterestItemFromJson(json);
}

