import 'package:freezed_annotation/freezed_annotation.dart';

part 'discover_user_model.freezed.dart';
part 'discover_user_model.g.dart';

@freezed
class DiscoverResponse with _$DiscoverResponse {
  const factory DiscoverResponse({
    required bool success,
    required String message,
    required DiscoverData data,
  }) = _DiscoverResponse;

  factory DiscoverResponse.fromJson(Map<String, dynamic> json) =>
      _$DiscoverResponseFromJson(json);
}

@freezed
class DiscoverData with _$DiscoverData {
  const factory DiscoverData({
    required List<DiscoverUserModel> users,
    PaginationMeta? pagination,
  }) = _DiscoverData;

  factory DiscoverData.fromJson(Map<String, dynamic> json) =>
      _$DiscoverDataFromJson(json);
}

@freezed
class DiscoverUserModel with _$DiscoverUserModel {
  const DiscoverUserModel._();

  const factory DiscoverUserModel({
    @JsonKey(name: '_id') required String id,
    required String name,
    String? dateOfBirth,
    String? gender,
    String? bio,
    @Default([]) List<PhotoData> photos,
    @Default([]) List<String> interests,
    String? major,
    @JsonKey(name: 'class') String? className,
    int? age,
    String? mainPhoto,
    String? datingPurpose, // 'relationship', 'friends', 'casual', 'unsure'
    int? distance, // Distance in km
    String? matchedAt, // ISO date string for when match occurred
    String? education,
    String? zodiac,
    String? communicationStyle,
    String? pets,
    String? workout,
    String? smoking,
    String? drinking,
  }) = _DiscoverUserModel;

  factory DiscoverUserModel.fromJson(Map<String, dynamic> json) =>
      _$DiscoverUserModelFromJson(json);

  String get displayPhoto =>
      mainPhoto ?? (photos.isNotEmpty ? photos.first.url : '');
}

@freezed
class PhotoData with _$PhotoData {
  const factory PhotoData({
    required String url,
    String? publicId,
    @Default(false) bool isMain,
  }) = _PhotoData;

  factory PhotoData.fromJson(Map<String, dynamic> json) =>
      _$PhotoDataFromJson(json);
}

@freezed
class PaginationMeta with _$PaginationMeta {
  const factory PaginationMeta({
    @JsonKey(name: 'currentPage') required int page,
    @JsonKey(name: 'pageSize') required int limit,
    @JsonKey(name: 'totalItems') required int total,
    @JsonKey(name: 'totalPages') required int pages,
    @JsonKey(name: 'hasNextPage') required bool hasNext,
    @JsonKey(name: 'hasPrevPage') required bool hasPrev,
  }) = _PaginationMeta;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);
}

@freezed
class LikeResponse with _$LikeResponse {
  const factory LikeResponse({
    required bool success,
    required String message,
    required LikeData data,
  }) = _LikeResponse;

  factory LikeResponse.fromJson(Map<String, dynamic> json) =>
      _$LikeResponseFromJson(json);
}

@freezed
class LikeData with _$LikeData {
  const factory LikeData({
    required bool isMatch,
    MatchedUserData? matchedUser,
  }) = _LikeData;

  factory LikeData.fromJson(Map<String, dynamic> json) =>
      _$LikeDataFromJson(json);
}

@freezed
class MatchedUserData with _$MatchedUserData {
  const factory MatchedUserData({
    @JsonKey(name: '_id') required String id,
    required String name,
    String? mainPhoto,
  }) = _MatchedUserData;

  factory MatchedUserData.fromJson(Map<String, dynamic> json) =>
      _$MatchedUserDataFromJson(json);
}
