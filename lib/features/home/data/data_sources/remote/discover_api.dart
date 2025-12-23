import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../models/discover_user_model.dart';

part 'discover_api.g.dart';

@RestApi()
abstract class DiscoverApi {
  factory DiscoverApi(Dio dio, {String? baseUrl, ParseErrorLogger? errorLogger}) = _DiscoverApi;

  /// Get discover suggestions
  @GET('api/v1/discover')
  Future<DiscoverResponse> getDiscover(
    @Header('Authorization') String authorization,
    @Query('page') int page,
    @Query('limit') int limit,
  );

  /// Like a user
  @POST('api/v1/discover/{id}/like')
  Future<LikeResponse> likeUser(
    @Path('id') String userId,
    @Header('Authorization') String authorization,
  );

  /// Pass (skip) a user
  @POST('api/v1/discover/{id}/pass')
  Future<void> passUser(
    @Path('id') String userId,
    @Header('Authorization') String authorization,
  );

  /// Super like a user
  @POST('api/v1/discover/{id}/superlike')
  Future<LikeResponse> superlikeUser(
    @Path('id') String userId,
    @Header('Authorization') String authorization,
  );

  /// Get matches
  @GET('api/v1/discover/matches')
  Future<DiscoverResponse> getMatches(
    @Header('Authorization') String authorization,
    @Query('page') int page,
    @Query('limit') int limit,
  );
}

