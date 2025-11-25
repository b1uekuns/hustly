import 'package:go_router/go_router.dart';
import 'app_page.dart';
import '../../../features/auth/presentation/pages/login_otp_page.dart';
import '../../../features/auth/presentation/pages/login_page.dart';
import '../../../features/home/presentation/pages/home_page.dart';
import '../../../features/profile_setup/presentation/pages/step1_basic_info_page.dart';
import '../../../features/profile_setup/presentation/pages/step2_photos_page.dart';
import '../../../features/profile_setup/presentation/pages/step3_interests_page.dart';
import '../../../features/profile_setup/presentation/pages/step4_interested_in_page.dart';
import '../../../features/profile_setup/presentation/pages/pending_approval_page.dart';

class AppRouter {
  AppRouter._(); // Private constructor

  /// Main router instance
  static final GoRouter router = GoRouter(
    initialLocation: AppPage.login.toPath(),

    routes: [
      // Login
      GoRoute(
        name: AppPage.login.toName,
        path: AppPage.login.toPath(),
        builder: (context, state) => const LoginPage(),
      ),

      // Login OTP
      GoRoute(
        name: AppPage.loginOtp.toName,
        path: AppPage.loginOtp.toPath(),
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return LoginOTPPage(email: email);
        },
      ),

      // Onboarding Step 1: Basic Info
      GoRoute(
        name: AppPage.onboarding.toName,
        path: AppPage.onboarding.toPath(),
        builder: (context, state) => const Step1BasicInfoPage(),
      ),

      // Onboarding Step 2: Photos
      GoRoute(
        name: AppPage.onboardingPhotos.toName,
        path: AppPage.onboardingPhotos.toPath(),
        builder: (context, state) => const Step2PhotosPage(),
      ),

      // Onboarding Step 3: Interests
      GoRoute(
        name: AppPage.onboardingInterests.toName,
        path: AppPage.onboardingInterests.toPath(),
        builder: (context, state) => const Step3InterestsPage(),
      ),

      // Onboarding Step 4: Interested In
      GoRoute(
        name: AppPage.onboardingInterestedIn.toName,
        path: AppPage.onboardingInterestedIn.toPath(),
        builder: (context, state) => const Step4InterestedInPage(),
      ),

      // Onboarding Pending Approval
      GoRoute(
        name: AppPage.onboardingPending.toName,
        path: AppPage.onboardingPending.toPath(),
        builder: (context, state) => const PendingApprovalPage(),
      ),

      // Home
      GoRoute(
        name: AppPage.home.toName,
        path: AppPage.home.toPath(),
        builder: (context, state) => const HomePage(),
      ),

      // Splash
      // GoRoute(
      //   name: AppPage.splash.toName,
      //   path: AppPage.splash.toPath(),
      //   builder: (context, state) => const SplashPage(),
      // ),
    ],
  
    // // ✅ THÊM 2: Auth guard
    // redirect: (context, state) {
    //   // TODO: Get authentication from DI
    //   // final tokenProvider = getIt<TokenProvider>();
    //   // final isAuthenticated = await tokenProvider.hasAccessToken();
      
    //   final isAuthenticated = false; // Replace with actual check
      
    //   final isGoingToLogin = state.location == AppPage.login.toPath();
    //   final isGoingToLoginOtp = state.location == AppPage.loginOtp.toPath();
    //   final isGoingToSplash = state.location == AppPage.splash.toPath();
      
    //   // Not authenticated and not going to auth pages
    //   if (!isAuthenticated && 
    //       !isGoingToLogin && 
    //       !isGoingToLoginOtp && 
    //       !isGoingToSplash) {
    //     return AppPage.login.toPath();
    //   }
      
    //   // Authenticated and going to login page
    //   if (isAuthenticated && isGoingToLogin) {
    //     return AppPage.home.toPath();
    //   }
      
    //   return null;
    // },
  );
}
