import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/Resources/color_manager.dart';
import 'package:social_media_app/Resources/routes_manager.dart';
import 'package:social_media_app/Screens/auth/view_models/auth_view_model.dart';
import 'package:social_media_app/Theme/theme_provider.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/Utils/utils.dart';

class forgetPasswordScreen extends StatefulWidget {
  @override
  State<forgetPasswordScreen> createState() => _forgetPasswordScreenState();
}

class _forgetPasswordScreenState extends State<forgetPasswordScreen> {
  authViewModel _authViewModel = authViewModel();
  TextEditingController _emailEditingController = TextEditingController();
  bool _isSendPasswordResetEmail = false;
  bool _isLoading = false;
  bool _isEmailValidated = false;
  final _toast = FToast();

  @override
  void initState() {
    _toast.init(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _emailEditingController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    if (!isEmailValid(_emailEditingController.text)) {
      _toast.showToast(
          child: builtToast(
              verdict: toastMessageVerdict.Error.toString(),
              mes: 'Email is not valid.'));
      _isEmailValidated = false;
    } else {
      _isEmailValidated = true;
    }
  }

  void _verifyEmail() async {
    _validateEmail();
    if (!_isEmailValidated) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _isSendPasswordResetEmail =
        await _authViewModel.resetPassword(email: _emailEditingController.text);
    if (_isSendPasswordResetEmail) {
      _emailEditingController.clear();
      FocusScope.of(context).unfocus();
      _toast.showToast(
          child: builtToast(
              verdict: toastMessageVerdict.WithoutError.toString(),
              mes: _authViewModel.message,
              fontsize: 16));
    } else {
      _toast.showToast(
          child: builtToast(
              verdict: toastMessageVerdict.Error.toString(),
              mes: _authViewModel.message));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    bool isKeyboard = viewInsetsBottom != 0;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Consumer<ThemeProvider>(builder: (ctx, provider, _) {
          return Stack(
            children: [
              !isKeyboard
                  ? Container(
                      height: getHeight(context: context),
                      width: getWidth(context: context),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                        ColorManager.primeryDark,
                        ColorManager.primeryLight
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                    )
                  : Container(
                      height: getHeight(context: context) - viewInsetsBottom,
                      width: getWidth(context: context),
                    ),
              !isKeyboard
                  ? Positioned(
                      top: 0,
                      child: SizedBox(
                        height: getHeight(context: context) * 0.2,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: getHeight(context: context) * 0.1, left: 30),
                          child: Text(
                            'Reset your password',
                            style: GoogleFonts.nunito(
                                color: ColorManager.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ))
                  : SizedBox.shrink(),
              Positioned(
                bottom: 0,
                child: Container(
                  height: isKeyboard
                      ? getHeight(context: context) - viewInsetsBottom
                      : getHeight(context: context) * 0.8,
                  width: getWidth(context: context),
                  decoration: BoxDecoration(
                      color: provider.IsThemeStatusBlack
                          ? Colors.black
                          : ColorManager.white,
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
                            if (_isSendPasswordResetEmail)
                              const SizedBox(
                                height: 35,
                              ),
                            SizedBox(
                              width: getWidth(context: context) * 0.75,
                              child: Text(
                                  _isSendPasswordResetEmail
                                      ? 'Please check your email and follow the instructions to reset your password '
                                      : 'Enter the email address associated with the account to reset the password',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.nunito(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400)),
                            ),
                            if (!_isSendPasswordResetEmail)
                              const SizedBox(
                                height: 35,
                              ),
                            _isSendPasswordResetEmail
                                ? SizedBox.shrink()
                                : Container(
                                    width: getWidth(context: context) * 0.8,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: provider.IsThemeStatusBlack
                                            ? Colors.grey[900]
                                            : Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              color: provider.IsThemeStatusBlack
                                                  ? Colors.grey
                                                  : ColorManager.shadowColor,
                                              offset: const Offset(1, 1))
                                        ],
                                        border: Border(
                                            bottom: BorderSide(
                                                color:
                                                    ColorManager.shadowColor))),
                                    child: TextField(
                                      controller: _emailEditingController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Email',
                                        hintStyle: GoogleFonts.nunito(
                                            color: provider.IsThemeStatusBlack
                                                ? Colors.grey[200]
                                                : ColorManager.grey),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                            _isSendPasswordResetEmail
                                ? SizedBox.shrink()
                                : const SizedBox(
                                    height: 35,
                                  ),
                            if (!_isSendPasswordResetEmail)
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
                                          'Reset',
                                          style: GoogleFonts.nunito(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )),
                          ],
                        ),
                      ),
                      isKeyboard
                          ? SizedBox.shrink()
                          : GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushReplacementNamed(routes.loginRoute);
                              },
                              child: Container(
                                width: getWidth(context: context),
                                color: ColorManager.primeryColor,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Center(
                                  child: Text('Move to login page',
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
          );
        }),
      ),
    );
  }
}
