import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hust_chill_app/core/utils/app_color.dart';
import 'package:hust_chill_app/core/utils/app_style.dart';
import 'package:hust_chill_app/core/utils/images_local.dart';
import 'package:hust_chill_app/widgets/pin_put_otp/pin_put_widget.dart';
import 'package:hust_chill_app/widgets/snackbar/app_snackbar.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/routes/app_page.dart';

import '../bloc/auth_bloc.dart';

class LoginOTPPage extends StatefulWidget {
  final String email;
  const LoginOTPPage({super.key, required this.email});

  @override
  State<LoginOTPPage> createState() => _LoginOTPPageState();
}

class _LoginOTPPageState extends State<LoginOTPPage> {
  final TextEditingController _otpController = TextEditingController();

  Timer? _timer;
  int _secondsRemaining = 60;

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsRemaining = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          otpSent: (email, expiresIn) {
            AppSnackbar.showSnackBar(
              context,
              title: 'Đã gửi lại mã',
              message: 'Mã OTP đã được gửi lại',
              type: SnackType.success,
            );
            _startCountdown(); // reset countdown
          },
          verifyOtpError: (message) {
            AppSnackbar.showSnackBar(
              context,
              title: 'Lỗi',
              message: message,
              type: SnackType.error,
            );
          },
          authenticated: (user, token, isNewUser) {
            AppSnackbar.showSnackBar(
              context,
              message: 'Đăng nhập thành công!',
              type: SnackType.success,
              duration: const Duration(milliseconds: 800),
            );
            Future.delayed(const Duration(seconds: 1), () {
              if (context.mounted) {
                if (isNewUser) {
                  // TODO: Navigate to complete profile
                  GoRouter.of(context).go(AppPage.home.toPath());
                } else {
                  GoRouter.of(context).go(AppPage.home.toPath());
                }
              }
            });
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final bool isLoading = state.maybeWhen(
          verifyingOtp: () => true,
          sendingOtp: () => true,
          orElse: () => false,
        );
        final Size size = MediaQuery.of(context).size;

        return Scaffold(
          backgroundColor: AppColor.redPrimary,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColor.textWhite),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Image.asset(ImageLocal.iconOpt, width: 237, height: 180),
                    Text(
                      'Xác thực OTP',
                      style: AppStyle.def.bold
                          .size(23)
                          .colors(AppColor.textWhite),
                    ),
                    // Main box
                    Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(24),
                          padding: const EdgeInsets.fromLTRB(24, 15, 24, 60),
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
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 1),
                              ),
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.2),
                                blurRadius: 5,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Mã OTP đã được gửi đến\n${widget.email}',
                                style: AppStyle.def
                                    .size(13)
                                    .colors(AppColor.textLight),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: size.width * 0.05),

                              // OTP Input
                              PinPutOtpWidget(
                                controller: _otpController,
                                onCompleted: (otp) {
                                  _verifyOtp(context);
                                },
                                onChanged: (_) {},
                              ),

                              SizedBox(height: size.width * 0.05),

                              // Countdown resend
                              GestureDetector(
                                onTap: _secondsRemaining == 0 && !isLoading
                                    ? () {
                                        context.read<AuthBloc>().add(
                                          AuthEvent.sendOtpRequested(
                                            email: widget.email,
                                          ),
                                        );
                                      }
                                    : null,
                                child: Text(
                                  _secondsRemaining == 0
                                      ? 'Gửi lại mã OTP'
                                      : 'Gửi lại sau $_secondsRemaining giây',
                                  style: AppStyle.def
                                      .size(13)
                                      .colors(
                                        _secondsRemaining == 0
                                            ? AppColor.white
                                            : AppColor.textLight.withOpacity(
                                                0.6,
                                              ),
                                      ),
                                ),
                              ),
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

                        // Confirm button
                        Positioned(
                          bottom: -5,
                          child: GestureDetector(
                            onTap: isLoading ? null : () => _verifyOtp(context),
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
                              child: Center(
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 250),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 3,
                                          ),
                                        )
                                      : SvgPicture.asset(
                                          ImageLocal.iconButtonArrow,
                                          width: 24,
                                          height: 24,
                                          fit: BoxFit.contain,
                                        ),
                                ),
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

  void _verifyOtp(BuildContext context) {
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      AppSnackbar.showSnackBar(
        context,
        title: 'Thiếu mã OTP',
        message: 'Vui lòng nhập mã xác thực',
        type: SnackType.error,
      );
      return;
    }
    context.read<AuthBloc>().add(
      AuthEvent.verifyOtpRequested(email: widget.email, otp: otp),
    );
  }
}
