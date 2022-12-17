import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_media_app/Resources/color_manager.dart';
import 'package:social_media_app/Screens/auth/views/email_verification_screen.dart';
import 'package:social_media_app/Screens/auth/views/forgot_password_screen.dart';
import 'package:social_media_app/Screens/auth/views/login_screen.dart';
import 'package:social_media_app/Screens/auth/views/signUp_screen.dart';
import 'package:social_media_app/Screens/home/home_screen.dart';
import 'package:social_media_app/Screens/profile/profile_view.dart';
import 'package:social_media_app/Screens/splash/splash_screen.dart';

class routes {
  static const String signUpRoute = '/SignUp_Route';
  static const String loginRoute = '/Login_Route';
  static const String splashRoute = '/Splash_Route';
  static const String homeRoute = '/Home_Route';
  static const String profileRoute = '/Profile_Route';
  static const String verificationPageRoute = '/Verification_Route';
  static const String resetPasswordPageRoute = '/Reset_Password_Route';
}

class routeGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case routes.splashRoute:
        return PageTransition(
            child: splashScreen(), type: PageTransitionType.fade);

      case routes.loginRoute:
        return PageTransition(
            child: loginScreen(), type: PageTransitionType.rightToLeft);
      case routes.signUpRoute:
        return PageTransition(
            child: SignUpScreen(), type: PageTransitionType.rightToLeft);
      case routes.verificationPageRoute:
        return PageTransition(
            child: emailVerificationPage(),
            type: PageTransitionType.rightToLeft);
      case routes.resetPasswordPageRoute:
        return PageTransition(
            child: forgetPasswordScreen(),
            type: PageTransitionType.rightToLeft);
      case routes.homeRoute:
        return PageTransition(
            child: homeScreen(), type: PageTransitionType.rightToLeft);
      case routes.profileRoute:
        return PageTransition(
            child: profileScreen(), type: PageTransitionType.rightToLeft);
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (context) => Scaffold(
              body: Container(
                color: ColorManager.white,
                child: const Center(
                  child: Text('No Record Found'),
                ),
              ),
            ));
  }
}
