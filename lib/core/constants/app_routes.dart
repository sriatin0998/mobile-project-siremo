// lib/core/constants/app_routes.dart
import 'package:get/get.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/splash_screen.dart';
import '../../core/constants/app_constants.dart';
import '../../presentation/pages/profile/edit_profile_page.dart';
import '../../presentation/pages/profile/help_center_page.dart';
import '../../presentation/pages/profile/security_page.dart';
import '../../presentation/pages/profile/terms_page.dart';
import '../../presentation/pages/profile/privacy_page.dart';



class AppRoutes {
  static final routes = [
    GetPage(
      name: AppConstants.splashRoute,
      page: () => const SplashScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppConstants.loginRoute,
      page: () => const LoginPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppConstants.registerRoute,
      page: () => const RegisterPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppConstants.homeRoute,
      page: () => const HomePage(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppConstants.securityRoute,
      page: () => SecurityPage(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppConstants.helpCenterRoute,
      page: () => const HelpCenterPage(),
      transition: Transition.fade,
    ),
     GetPage(
      name: AppConstants.termsRoute,
      page: () => const TermsPage(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppConstants.privacyRoute,
      page: () => const PrivacyPage(),
      transition: Transition.fade,
    ),
    GetPage(
      name: '/edit-profile', 
      page: () =>  EditProfilePage(), 
      transition: Transition.fade),
  ];
}
