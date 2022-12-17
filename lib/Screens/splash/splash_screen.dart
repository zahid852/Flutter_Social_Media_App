import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media_app/Resources/routes_manager.dart';
import 'package:social_media_app/Resources/string_manager.dart';
import 'package:social_media_app/Screens/home/home_screen.dart';
import 'package:social_media_app/main.dart';

import 'package:social_media_app/resources/asset_manager.dart';
import 'package:social_media_app/resources/color_manager.dart';

class splashScreen extends StatefulWidget {
  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2)).then((_) {
      _subscribeToFirebaseAuthChanges();
    });
    super.initState();
  }

  void _subscribeToFirebaseAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        if (user.emailVerified) {
          MyApp.navigatorKey.currentState!
              .pushReplacementNamed(routes.homeRoute);
        } else {
          MyApp.navigatorKey.currentState!
              .pushReplacementNamed(routes.verificationPageRoute);
        }
      } else {
        MyApp.navigatorKey.currentState!
            .pushReplacementNamed(routes.loginRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image(
                      image: const AssetImage(
                        ImageAssets.logo,
                      ),
                      color: ColorManager.primeryColor,
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                    Text(stringManager.random,
                        style: TextStyle(
                            color: ColorManager.primeryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: SpinKitFadingCircle(
                size: 50.0,
                color: ColorManager.primeryColor,
              ),
            )
          ],
        ),
      )),
    );
  }
}
