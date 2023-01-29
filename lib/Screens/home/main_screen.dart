import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/Resources/asset_manager.dart';
import 'package:social_media_app/Resources/color_manager.dart';
import 'package:social_media_app/Screens/add_post/view/add_post.dart';
import 'package:social_media_app/Screens/home/components/bottom_navigation_bar.dart';
import 'package:social_media_app/Screens/home/components/home_loading_widget.dart';
import 'package:social_media_app/Screens/home/view/home_screen.dart';
import 'package:social_media_app/Screens/notification/view/notification_screen.dart';
import 'package:social_media_app/Screens/profile/view/profile_screen.dart';
import 'package:social_media_app/Screens/search/view/search_screen.dart';
import 'package:social_media_app/Theme/theme_provider.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/Utils/logedin_user_info.dart';
import 'package:social_media_app/Utils/utils.dart';

class mainScreen extends StatefulWidget {
  bool IsCurrentUserDetailsFetched;
  mainScreen({required this.IsCurrentUserDetailsFetched});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  int _screen_index = 0;
  UserInfoViewModel _userInfoViewModel = UserInfoViewModel();

  late Future<void> getData;
  BuildContext? mainScreenContext;
  late final List<Widget> _screens = [
    homeScreen(),
    searchScreen(changeMainScreen: _changeScreen),
    addPost(),
    notificationScreen(),
    profileScreen(),
  ];
  void _changeScreen(int index) {
    setState(() {
      _screen_index = index;
    });
  }

  @override
  void initState() {
    if (!widget.IsCurrentUserDetailsFetched) {
      getData = _userInfoViewModel.getData();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNavigationBar(
          currentIndex: _screen_index, changeScreen: _changeScreen),
      body: widget.IsCurrentUserDetailsFetched
          ? _screens[_screen_index]
          : FutureBuilder(
              future: getData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SafeArea(
                      child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: Column(children: [
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(top: 10, bottom: 6),
                              child: Text(
                                'Random',
                                style: GoogleFonts.akayaTelivigala(
                                    color: ColorManager.primeryColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Expanded(
                                child: ListView.builder(
                                    itemCount: 5,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, snapshot) {
                                      return homeLoadingWidget();
                                    })),
                          ])));
                } else if (snapshot.hasError) {
                  return Center(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: getHeight(context: context) * 0.2,
                            width: getWidth(context: context) * 0.5,
                            child: Lottie.asset(LottieAssets.error),
                          ),
                          Container(
                            width: getWidth(context: context) * 0.7,
                            alignment: Alignment.center,
                            child: Text(
                              snapshot.error.toString(),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                              height: 55,
                              width: getWidth(context: context) * 0.45,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    )),
                                onPressed: () {
                                  getData = _userInfoViewModel.getData();
                                  setState(() {});
                                },
                                child: Text(
                                  'Refresh',
                                  style: GoogleFonts.nunito(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
                        ],
                      ),
                    ),
                  );
                } else {
                  return _screens[_screen_index];
                }
              }),
    );
  }
}
