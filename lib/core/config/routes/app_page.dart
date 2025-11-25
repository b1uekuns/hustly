enum AppPage { 
  splash, 
  login, 
  loginOtp, 
  onboarding, 
  onboardingPhotos,
  onboardingInterests,
  onboardingInterestedIn,
  onboardingPending,
  home 
}

extension AppPageExtension on AppPage {
  String toPath() {
    switch (this) {
      case AppPage.splash:
        return '/splash';
      case AppPage.login:
        return '/';
      case AppPage.loginOtp:
        return '/login-otp';
      case AppPage.onboarding:
        return '/onboarding';
      case AppPage.onboardingPhotos:
        return '/onboarding/photos';
      case AppPage.onboardingInterests:
        return '/onboarding/interests';
      case AppPage.onboardingInterestedIn:
        return '/onboarding/interested-in';
      case AppPage.onboardingPending:
        return '/onboarding/pending';
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
      case AppPage.onboarding:
        return 'onboarding';
      case AppPage.onboardingPhotos:
        return 'onboarding-photos';
      case AppPage.onboardingInterests:
        return 'onboarding-interests';
      case AppPage.onboardingInterestedIn:
        return 'onboarding-interested-in';
      case AppPage.onboardingPending:
        return 'onboarding-pending';
      case AppPage.home:
        return 'home';
    }
  }
}
