import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_media_app/Resources/color_manager.dart';
import 'package:social_media_app/Screens/Image/image_full_screen.dart';
import 'package:social_media_app/Screens/add_post/view/share_post.dart';
import 'package:social_media_app/Screens/auth/views/email_verification_screen.dart';
import 'package:social_media_app/Screens/auth/views/forgot_password_screen.dart';
import 'package:social_media_app/Screens/auth/views/login_screen.dart';
import 'package:social_media_app/Screens/auth/views/signUp_screen.dart';
import 'package:social_media_app/Screens/home/main_screen.dart';
import 'package:social_media_app/Screens/home/view/notification_click_comments.dart';
import 'package:social_media_app/Screens/home/view/post_comments_screen.dart';
import 'package:social_media_app/Screens/home/view_models/home_view_model.dart';
import 'package:social_media_app/Screens/home/view_models/post_comment_view_state.dart';
import 'package:social_media_app/Screens/profile/profile_Setup/profile_model_view_state.dart';
import 'package:social_media_app/Screens/profile/profile_Setup/profile_setup_view.dart';
import 'package:social_media_app/Screens/search/view/profile_page.dart';
import 'package:social_media_app/Screens/splash/splash_screen.dart';
import 'package:social_media_app/Utils/const.dart';

import '../Screens/search/view_model/search_profile_model_viewstate.dart';

class routes {
  static const String signUpRoute = '/SignUp_Route';
  static const String loginRoute = '/Login_Route';
  static const String splashRoute = '/Splash_Route';
  static const String mainScreensRoute = '/Main_Screens_Route';
  static const String profileRoute = '/Profile_Route';
  static const String verificationPageRoute = '/Verification_Route';
  static const String resetPasswordPageRoute = '/Reset_Password_Route';
  static const String sharePostRoute = '/Share_Post_Route';
  static const String PostCommentsRoute = '/Post_Comments_Route';
  static const String ImageRoute = '/Image_Route';
  static const String notificationClickMessageRoute =
      '/notifcation_click_message_route';
  static const String profilePageRoute = '/Profile_Page_Route';
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
      case routes.mainScreensRoute:
        final bool isDataFetched = routeSettings.arguments == null
            ? false
            : routeSettings.arguments as bool;
        return PageTransition(
            child: mainScreen(IsCurrentUserDetailsFetched: isDataFetched),
            type: PageTransitionType.rightToLeft);
      case routes.profileRoute:
        final List<dynamic> data = routeSettings.arguments as List<dynamic>;
        final String ProfileSetup = data[0];
        profileModelViewState profileModel;
        if (ProfileSetup == profileSetup.Profile.toString()) {
          final profileModelViewState profileModel = data[1];
          return PageTransition(
              child: profileSetupScreen(
                profileSetup: ProfileSetup,
                previousProfileViewState: profileModel,
              ),
              type: PageTransitionType.rightToLeft);
        } else {
          return PageTransition(
              child: profileSetupScreen(profileSetup: ProfileSetup),
              type: PageTransitionType.rightToLeft);
        }

      case routes.sharePostRoute:
        final List data = routeSettings.arguments as List;
        final File? file = data[0];
        final FileTypeOption? fileType = data[1];
        return PageTransition(
            child: sharePost(file: file, fileType: fileType),
            type: PageTransitionType.rightToLeft);
      case routes.PostCommentsRoute:
        final data = routeSettings.arguments as List;
        final homeViewModel viewModel = data[0];
        final String postId = data[1];
        final String postUserId = data[2];
        final String postUsername = data[3];
        return PageTransition(
            child: postCommentsScreen(
              viewModel: viewModel,
              postId: postId,
              nameOfPostUser: postUsername,
              idOfPostUser: postUserId,
            ),
            type: PageTransitionType.rightToLeft);
      case routes.ImageRoute:
        final String imagePath = routeSettings.arguments as String;

        return PageTransition(
            child: FullImageScreen(imagePath: imagePath),
            type: PageTransitionType.rightToLeft);
      case routes.profilePageRoute:
        final searchProfileModelViewState searchModel =
            routeSettings.arguments as searchProfileModelViewState;
        return PageTransition(
            child: profilePage(searchModel: searchModel),
            type: PageTransitionType.rightToLeft);
      case routes.notificationClickMessageRoute:
        final String postId = routeSettings.arguments as String;

        return PageTransition(
            child: notificationClickMessageScreen(
              postId: postId,
            ),
            type: PageTransitionType.rightToLeft);
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
