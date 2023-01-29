import 'dart:async';
import 'dart:developer';

import 'package:better_player/better_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:social_media_app/Resources/color_manager.dart';
import 'package:social_media_app/Resources/routes_manager.dart';
import 'package:social_media_app/Screens/home/components/chewi_video_player.dart';
import 'package:social_media_app/Screens/home/components/home_loading_widget.dart';
import 'package:social_media_app/Screens/home/components/like_button.dart';
import 'package:social_media_app/Screens/home/components/post_comments.dart';
import 'package:social_media_app/Screens/home/components/post_lists.dart';
import 'package:social_media_app/Screens/home/view/notification_click_comments.dart';
import 'package:social_media_app/Screens/home/view_models/home_view_model.dart';
import 'package:social_media_app/Screens/home/view_models/post_view_model.dart';
import 'package:social_media_app/Screens/profile/view/profile_screen.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/Utils/logedin_user_info.dart';
import 'package:social_media_app/main.dart';
import 'package:social_media_app/resources/asset_manager.dart';
import 'package:video_player/video_player.dart';

import '../../../Utils/utils.dart';

class homeScreen extends StatefulWidget {
  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  late homeViewModel _homeViewModel;
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    _homeViewModel = homeViewModel();
    requestNotificationPermission();
    getToken();
    initInfo();
    super.initState();
  }

  void initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: androidInitialize);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (response) {
      // when the app is in foreground

      // if (response.notificationResponseType ==
      //     NotificationResponseType.selectedNotification) {
      //   try {
      //     Navigator.of(MyApp.navigatorKey.currentContext!).pushReplacementNamed(
      //         routes.notificationClickMessageRoute,
      //         arguments: response.payload);
      //   } catch (e) {
      //     log('error ${e}');
      //   }
      // }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('foreground message ${message.messageId}');
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.title.toString(),
          htmlFormatContentTitle: true);
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'social_media_app',
        'social_media_app',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
      );

      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title,
          message.notification!.body,
          platformChannelSpecifics,
          payload: message.data['body']);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.data['type'] == 'chat') {
        Navigator.of(MyApp.navigatorKey.currentContext!).pushReplacementNamed(
            routes.notificationClickMessageRoute,
            arguments: message.data['body']);
      }
    });
  }

  void getToken() async {
    await FirebaseMessaging.instance
        .getToken()
        .then((token) => saveToken(token: token!));
  }

  void saveToken({required String token}) async {
    await FirebaseFirestore.instance
        .collection('UserTokens')
        .doc(logedinUserInfo.UserId)
        .set({'token': token});
  }

  void requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log('User granted permission: ${settings.authorizationStatus}');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
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
              child: StreamBuilder<List<PostViewModel>>(
                  stream: _homeViewModel.postStreamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListView.builder(
                          itemCount: 5,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, snapshot) {
                            return homeLoadingWidget();
                          });
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 60),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: getHeight(context: context) * 0.3,
                                width: getWidth(context: context) * 0.5,
                                child: Lottie.asset(LottieAssets.error),
                              ),
                              Container(
                                width: getWidth(context: context) * 0.7,
                                alignment: Alignment.center,
                                child: Text(
                                  "Something went wrong",
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.nunito(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.data!.isEmpty) {
                      return Center(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 60),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: getHeight(context: context) * 0.32,
                                width: getWidth(context: context) * 0.6,
                                child: Lottie.asset(LottieAssets.empty),
                              ),
                              Container(
                                width: getWidth(context: context) * 0.7,
                                alignment: Alignment.center,
                                child: Text(
                                  "No Posts here",
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.nunito(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return postLists(
                          list: snapshot.data ?? [], viewModel: _homeViewModel);
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
