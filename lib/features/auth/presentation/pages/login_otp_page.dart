import 'package:hust_chill_app/core/utils/app_color.dart';
import 'package:hust_chill_app/core/utils/app_style.dart';
import 'package:hust_chill_app/core/utils/images_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hust_chill_app/widgets/pin_put_otp/pin_put_widget.dart';

import '../../../../core/utils/app_function.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginOTPPage extends StatefulWidget {
  const LoginOTPPage({super.key});

  @override
  State<LoginOTPPage> createState() => _LoginOTPPageState();
}

class _LoginOTPPageState extends State<LoginOTPPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          AppFunction.showSnackBar(
            context,
            title: 'Error',
            message: state.message,
          );
        } else if (state is AuthSuccess) {
          AppFunction.showSnackBar(
            context,
            title: 'Success',
            message: 'Đăng nhập thành công',
          );
          // Điều hướng đến trang chính hoặc trang khác nếu cần
        }
      },
      builder: (context, state) {
        final Size size = MediaQuery.of(context).size;
        TextEditingController _otpController = TextEditingController();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColor.textWhite),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          backgroundColor: AppColor.redPrimary,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.width * 0.1),
                    Image.asset(ImageLocal.iconOpt, width: 237, height: 180),
                    SizedBox(height: size.width * 0.05),
                    Text(
                      'Xác thực OTP',
                      style: AppStyle.def.bold
                          .size(23)
                          .colors(AppColor.textWhite),
                    ),
                    SizedBox(height: size.width * 0.05),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          margin: EdgeInsets.all(24),
                          padding: const EdgeInsets.fromLTRB(24, 40, 24, 60),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColor.redLight,
                                AppColor.redExtraLight,
                                AppColor.redLight,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColor.containerBorder,
                              width: 1.5,
                            ),
                            boxShadow: [
                              // Soft shadow
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 20,
                                offset: Offset(0, 1),
                              ),
                              // Inner glow effect
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.2),
                                blurRadius: 5,
                                offset: Offset(0, -2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColor.redPrimary.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Mã OTP đã được gửi đến email của bạn',
                                      style: AppStyle.def
                                          .size(13)
                                          .colors(AppColor.textLight),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: size.width * 0.05),
                                    PinPutOtpWidget(
                                      controller: _otpController,
                                      onCompleted: (otp) {
                                        context.read<AuthBloc>().add(
                                          VerifyOtpRequested(
                                            otp,
                                            _emailController
                                                .text, // passing email as second required argument
                                          ),
                                        );
                                      },
                                      onChanged: (otp) {},
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: size.width * 0.05),
                              Text(
                                'Hãy kiểm tra thư rác nếu không thấy trong hộp thư đến',
                                style: AppStyle.def
                                    .size(13)
                                    .colors(AppColor.textLight),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        // Button được cải thiện
                        Positioned(
                          bottom: -5,
                          child: GestureDetector(
                            onTap: () {
                              context.read<AuthBloc>().add(
                                SendOtpRequested(_emailController.text),
                              );
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColor.redExtraLight,
                                    AppColor.redLight,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.redPrimary,
                                    blurRadius: 0,
                                    offset: const Offset(0, 0),
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
