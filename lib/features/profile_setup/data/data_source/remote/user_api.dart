import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../models/complete_profile_request.dart';
import '../../models/complete_profile_response.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApi {
  factory UserApi(Dio dio, {String baseUrl}) = _UserApi;

  @POST('/users/complete-profile')
  Future<CompleteProfileResponse> completeProfile(
    @Body() CompleteProfileRequest request,
    @Header('Authorization') String authorization,
  );

  @GET('/users/profile')
  Future<CompleteProfileResponse> getMyProfile(
    @Header('Authorization') String authorization,
  );

  @PUT('/users/profile')
  Future<CompleteProfileResponse> updateProfile(
    @Body() Map<String, dynamic> updates,
    @Header('Authorization') String authorization,
  );
}

