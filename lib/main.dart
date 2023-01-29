import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/Resources/routes_manager.dart';

import 'package:social_media_app/Screens/home/view/notification_click_comments.dart';
import 'package:social_media_app/Screens/home/view_models/comments_data.dart';
import 'package:social_media_app/Screens/search/view_model/follow_view_model.dart';
import 'package:social_media_app/Screens/search/view_model/search_view_model.dart';
import 'package:social_media_app/Theme/theme_change.dart';
import 'package:social_media_app/Theme/theme_provider.dart';
import 'package:social_media_app/Utils/logedin_user_info.dart';

import 'package:social_media_app/firebase_options.dart';
import 'package:social_media_app/Screens/auth/views/signUp_screen.dart';
import 'package:social_media_app/Screens/splash/splash_screen.dart';

import 'Screens/home/view_models/home_view_model.dart';

Future<void> _firbaseMessageHandler(RemoteMessage message) async {
  log('Background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final RemoteMessage? message =
      await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firbaseMessageHandler);
  runApp(MyApp(message: message));
}

class MyApp extends StatefulWidget {
  RemoteMessage? message;
  MyApp({required this.message});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UserInfoViewModel _userInfoViewModel = UserInfoViewModel();

  late Future<void> getData;

  @override
  void initState() {
    if (widget.message != null) {
      getData = _userInfoViewModel.getData();
    }
    super.initState();
  }

  Widget navigate({required BuildContext ctx}) {
    if (widget.message != null && widget.message!.data['type'] == 'chat') {
      final String id = widget.message!.data['body'];
      widget.message = null;
      return FutureBuilder(
          future: getData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: Text('Please wait...',
                      style: GoogleFonts.nunito(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w400)),
                ),
              );
            }
            return notificationClickMessageScreen(postId: id);
          });
    } else {
      return splashScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => commentsData(),
          ),
          ChangeNotifierProvider(
            create: (context) => FollowersViewModel(),
          ),
          ChangeNotifierProvider(
            create: (context) => ThemeProvider(),
          ),
        ],
        child: Consumer<ThemeProvider>(builder: (ctx, themeProvider, _) {
          log('again');
          return MaterialApp(
            title: 'Flutter Social Media App',
            theme: Styles.themeData(themeProvider.IsThemeStatusBlack, context),
            debugShowCheckedModeBanner: false,
            navigatorKey: MyApp.navigatorKey,
            onGenerateRoute: routeGenerator.getRoute,
            home: navigate(ctx: context),
          );
        }));
  }
}
