import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../models/complete_profile_response.dart';
import '../../models/majors_response.dart';
import '../../models/interests_response.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApi {
  factory UserApi(Dio dio, {String baseUrl}) = _UserApi;

  /// Get list of majors (PUBLIC - no auth required)
  @GET('api/v1/users/majors')
  Future<MajorsResponse> getMajors();

  /// Get list of interests categorized (PUBLIC - no auth required)
  @GET('api/v1/users/interests')
  Future<InterestsResponse> getInterests();

  @POST('api/v1/users/complete-profile')
  Future<CompleteProfileResponse> completeProfile(
    @Body() Map<String, dynamic> request,
    @Header('Authorization') String authorization,
  );

  @GET('api/v1/users/profile')
  Future<CompleteProfileResponse> getMyProfile(
    @Header('Authorization') String authorization,
  );

  @PUT('api/v1/users/profile')
  Future<CompleteProfileResponse> updateProfile(
    @Body() Map<String, dynamic> updates,
    @Header('Authorization') String authorization,
  );
}
