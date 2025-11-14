enum AppPage { splash, login, loginOtp, home }

extension AppPageExtension on AppPage {
  String toPath() {
    switch (this) {
      case AppPage.splash:
        return '/splash';
      case AppPage.login:
        return '/';
      case AppPage.loginOtp:
        return '/login-otp';
      case AppPage.home:
        return '/home';
    }
  }

  String get toName {
    switch (this) {
      case AppPage.splash:
        return 'splash';
      case AppPage.login:
        return 'login';
      case AppPage.loginOtp:
        return 'login-otp';
      case AppPage.home:
        return 'home';
    }
  }
}
