import 'package:go_router/go_router.dart';
import 'package:hust_chill_app/core/config/routes/app_page.dart';
import 'package:hust_chill_app/core/resources/app_color.dart';
import 'package:hust_chill_app/core/resources/app_style.dart';
import 'package:hust_chill_app/core/resources/images_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hust_chill_app/widgets/snackbar/app_snackbar.dart';
import 'package:hust_chill_app/widgets/textField/email_input_field.dart';

import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          otpSent: (email, expiresIn) {
            _emailController.clear();
            AppSnackbar.showSnackBar(
              context,
              title: "Thành công",
              message: "Mã OTP đã được gửi đến $email",
              type: SnackType.success,
              duration: const Duration(milliseconds: 1500),
              onDismissed: () {
                if (context.mounted) {
                  GoRouter.of(
                    context,
                  ).push(AppPage.loginOtp.toPath(), extra: email);
                }
              },
            );
          },
          sendOtpError: (message) {
            AppSnackbar.showSnackBar(
              context,
              title: "Lỗi",
              message: message,
              type: SnackType.error,
            );
          },
          orElse: () {},
        );
      },

      builder: (context, state) {
        final bool isLoading = state.maybeWhen(
          sendingOtp: () => true,
          orElse: () => false,
        );

        return Scaffold(
          backgroundColor: AppColor.redPrimary,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.width * 0.1),
                    Image.asset(ImageLocal.iconLogin, width: 237, height: 180),
                    SizedBox(height: size.width * 0.05),
                    Text(
                      'Mời bạn đăng nhập',
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
                                AppColor.redLight.withValues(alpha: 0.7),
                                AppColor.redExtraLight.withValues(alpha: 0.5),
                                AppColor.redLight.withValues(alpha: 0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColor.white.withValues(alpha: 0.2),
                              width: 1,
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.7,
                                      ),
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
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          child: Icon(
                                            Icons.email_outlined,
                                            color: AppColor.greyBold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 24,
                                          child: VerticalDivider(
                                            width: 1.5,
                                            color: AppColor.greyBold,
                                          ),
                                        ),
                                        Expanded(
                                          child: EmailInputField(
                                            controller: _emailController,
                                            enabled: !isLoading,
                                            onChanged: (value) {
                                              if (_emailError != null) {
                                                setState(() {
                                                  _emailError = null;
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (_emailError != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 5,
                                        left: 12,
                                        right: 12,
                                      ),
                                      child: Text(
                                        _emailError!,
                                        style: AppStyle.def
                                            .size(14)
                                            .colors(AppColor.yellowPrimary),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: size.width * 0.05),
                              Text(
                                'Mã xác thực (OTP) sẽ được gửi qua email',
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
                            onTap: isLoading
                                ? null
                                : () {
                                    FocusScope.of(context).unfocus();
                                    final email = _emailController.text.trim();

                                    if (email.isEmpty) {
                                      setState(
                                        () =>
                                            _emailError = 'Vui lòng nhập email',
                                      );
                                    } else if (!RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                    ).hasMatch(email)) {
                                      setState(
                                        () => _emailError =
                                            'Email không đúng định dạng',
                                      );
                                    } else if (!email.endsWith(
                                      '@sis.hust.edu.vn',
                                    )) {
                                      setState(
                                        () => _emailError =
                                            'Chỉ chấp nhận email HUST',
                                      );
                                    } else {
                                      _emailError = null;
                                      // Gửi OTP nếu hợp lệ
                                      context.read<AuthBloc>().add(
                                        AuthEvent.sendOtpRequested(
                                          email: email,
                                        ),
                                      );
                                      //_emailController.clear();
                                    }
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
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 5,
                                    offset: Offset(0, 0),
                                    spreadRadius: -5,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
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

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
