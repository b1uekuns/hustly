import 'package:go_router/go_router.dart';
import 'package:hust_chill_app/core/config/routes/app_page.dart';
import 'package:hust_chill_app/features/auth/presentation/pages/login_otp_page.dart';
import 'package:hust_chill_app/features/auth/presentation/pages/login_page.dart';
import 'package:hust_chill_app/features/home/presentation/pages/home_page.dart';

class AppRouter {
  static GoRouter? _router;
  static GoRouter? returnRouter() {
    if (_router != null) {
      return _router;
    }
    _router = GoRouter(
      routes: [
        GoRoute(
          name: AppPage.login.toName,
          path: AppPage.login.toPath(),
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          name: AppPage.loginOtp.toName,
          path: AppPage.loginOtp.toPath(),
          builder: (context, state) => const LoginOTPPage(),
        ),
        GoRoute(
          name: AppPage.home.toName,
          path: AppPage.home.toPath(),
          builder: (context, state) => const HomePage(),
        ),
      ],
    );
    return _router;
  }
}
