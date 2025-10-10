import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../models/login_response/login_response_model.dart';
import '../../models/refresh_token/refresh_token_model.dart';
import '../../models/user_model/user_model.dart';
import '../../../../../core/resources/base_response.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST('api/auth/send-code')
  Future<HttpResponse<BaseResponse<void>>> sendOtp(@Body() Map<String, dynamic> body);

  @POST('api/auth/verify-code')
  Future<HttpResponse<BaseResponse<LoginResponseModel>>> verifyOtp(
    @Body() Map<String, dynamic> body,
  );

  @GET('api/auth/me')
  Future<HttpResponse<BaseResponse<UserModel>>> getCurrentUser();

  @POST('api/auth/refresh')
  Future<HttpResponse<BaseResponse<RefreshTokenModel>>> refreshToken(
    @Body() Map<String, dynamic> body,
  );

  @POST('api/auth/logout')
  Future<HttpResponse<BaseResponse<void>>> logout();
}