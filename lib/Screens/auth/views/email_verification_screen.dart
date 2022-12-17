import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media_app/Resources/color_manager.dart';
import 'package:social_media_app/Resources/routes_manager.dart';
import 'package:social_media_app/Screens/auth/view_models/auth_view_model.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/Utils/utils.dart';

class emailVerificationPage extends StatefulWidget {
  @override
  State<emailVerificationPage> createState() => _emailVerificationPageState();
}

class _emailVerificationPageState extends State<emailVerificationPage> {
  authViewModel _authViewModel = authViewModel();
  bool _isSendVerificationEmailDone = false;
  bool _isLoading = false;
  final _toast = FToast();
  Timer? timer;
  @override
  void initState() {
    _toast.init(context);
    // TODO: implement initState
    super.initState();
  }

  void _verifyEmail() async {
    setState(() {
      _isLoading = true;
    });
    _isSendVerificationEmailDone = await _authViewModel.sendVerificationEmail();
    if (_isSendVerificationEmailDone) {
      _toast.showToast(
          child: builtToast(
              verdict: toastMessageVerdict.WithoutError.toString(),
              mes: _authViewModel.message,
              fontsize: 16));
      timer = Timer.periodic(const Duration(seconds: 3), (_) {
        checkEmailVerified();
      });
    } else {
      _toast.showToast(
          child: builtToast(
        verdict: toastMessageVerdict.Error.toString(),
        mes: _authViewModel.message,
      ));
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      timer!.cancel();
      Navigator.of(context).pushReplacementNamed(routes.profileRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: getHeight(context: context),
            width: getWidth(context: context),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              ColorManager.primeryDark,
              ColorManager.primeryLight
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          ),
          Positioned(
              top: 0,
              child: SizedBox(
                height: getHeight(context: context) * 0.2,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: getHeight(context: context) * 0.1, left: 30),
                  child: Text(
                    'Verify your email',
                    style: GoogleFonts.nunito(
                        color: ColorManager.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              )),
          Positioned(
            bottom: 0,
            child: Container(
              height: getHeight(context: context) * 0.8,
              width: getWidth(context: context),
              decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(70),
                      topRight: Radius.circular(70))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: getWidth(context: context) * 0.75,
                          child: Text(
                              _isSendVerificationEmailDone
                                  ? 'Please check your email and follow the instructions to complete your verification step'
                                  : 'Please confirm that you entered correct email address by clicking on verify button',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                  color: ColorManager.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        if (!_isSendVerificationEmailDone)
                          _isLoading
                              ? const SizedBox(
                                  height: 55,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : SizedBox(
                                  height: 55,
                                  width: getWidth(context: context) * 0.55,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        )),
                                    onPressed: () {
                                      _verifyEmail();
                                    },
                                    child: Text(
                                      'Verify',
                                      style: GoogleFonts.nunito(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(routes.loginRoute);
                    },
                    child: Container(
                      width: getWidth(context: context),
                      color: ColorManager.primeryColor,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text('Invalid Email? Use another Email',
                            style: GoogleFonts.nunito(
                              color: ColorManager.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
