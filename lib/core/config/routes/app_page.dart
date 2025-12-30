enum AppPage {
  splash,
  login,
  loginOtp,
  onboarding,
  onboardingPhotos,
  onboardingInterests,
  onboardingInterestedIn,
  onboardingStep5, // Dating Purpose
  onboardingPending,
  home,
  profileDetail,
  chatList,
  chatRoom,
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
      case AppPage.onboardingStep5:
        return '/onboarding/dating-purpose';
      case AppPage.onboardingPending:
        return '/onboarding/pending';
      case AppPage.home:
        return '/home';
      case AppPage.profileDetail:
        return '/profile/:userId';
      case AppPage.chatList:
        return '/chat';
      case AppPage.chatRoom:
        return '/chat/:conversationId';
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
      case AppPage.onboardingStep5:
        return 'onboarding-dating-purpose';
      case AppPage.onboardingPending:
        return 'onboarding-pending';
      case AppPage.home:
        return 'home';
      case AppPage.profileDetail:
        return 'profile-detail';
      case AppPage.chatList:
        return 'chat-list';
      case AppPage.chatRoom:
        return 'chat-room';
    }
  }
}
