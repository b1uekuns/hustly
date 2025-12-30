import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../../core/network/models/base_response.dart';
import '../../models/login_response/login_response_model.dart';
import '../../models/refresh_token/refresh_token_model.dart';
import '../../models/send_otp/send_otp_response.dart';
import '../../models/user_model/user_model.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  // Send OTP to email
  @POST('api/v1/auth/send-otp')
  Future<HttpResponse<BaseResponse<SendOtpResponse>>> sendOtp(
    @Body() Map<String, dynamic> body, // {"email": "mssv@sis.hust.edu.vn"}
  );

  // Verify OTP and login
  @POST('api/v1/auth/verify-otp')
  Future<HttpResponse<BaseResponse<LoginResponseModel>>> verifyOtp(
    @Body() Map<String, dynamic> body, // {"email": "...", "otp": "123456"}
  );

  // Resend OTP
  @POST('api/v1/auth/resend-otp')
  Future<HttpResponse<BaseResponse<SendOtpResponse>>> resendOtp(
    @Body() Map<String, dynamic> body,
  );

  // Get current user
  @GET('api/v1/auth/me')
  Future<HttpResponse<BaseResponse<UserModel>>> getCurrentUser(
    @Header('Authorization') String token,
  );

  // Refresh token
  @POST('api/v1/auth/refresh-token')
  Future<HttpResponse<BaseResponse<RefreshTokenModel>>> refreshToken(
    @Body() Map<String, dynamic> body, // {"refreshToken": "..."}
  );

  // Logout
  @POST('api/v1/auth/logout')
  Future<HttpResponse<BaseResponse<void>>> logout(
    @Header('Authorization') String token,
  );
}
