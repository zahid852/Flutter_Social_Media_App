import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/Resources/color_manager.dart';
import 'package:social_media_app/Resources/routes_manager.dart';
import 'package:social_media_app/Screens/auth/components/login_form_widget.dart';
import 'package:social_media_app/Theme/theme_provider.dart';

import '../../../Utils/utils.dart';

class loginScreen extends StatefulWidget {
  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    bool isKeyboard = viewInsetsBottom != 0;
    return Scaffold(
      body: Consumer<ThemeProvider>(builder: (ctx, provider, _) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Stack(
              children: [
                !isKeyboard
                    ? Container(
                        height: getHeight(context: context),
                        width: getWidth(context: context),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                              ColorManager.primeryDark,
                              ColorManager.primeryLight
                            ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight)),
                      )
                    : Container(
                        height: getHeight(context: context) - viewInsetsBottom,
                        width: getWidth(context: context),
                      ),
                !isKeyboard
                    ? Positioned(
                        top: 0,
                        child: SizedBox(
                          height: getHeight(context: context) * 0.25,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: getHeight(context: context) * 0.1,
                                left: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Login',
                                  style: GoogleFonts.nunito(
                                      color: ColorManager.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: getHeight(context: context) * 0.018,
                                ),
                                Text(
                                  'Welcome Back',
                                  style: GoogleFonts.nunito(
                                      color: ColorManager.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ))
                    : const SizedBox.shrink(),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: !isKeyboard
                        ? getHeight(context: context) * 0.75
                        : getHeight(context: context) - viewInsetsBottom,
                    width: getWidth(context: context),
                    decoration: BoxDecoration(
                        color: provider.IsThemeStatusBlack
                            ? Colors.black
                            : Colors.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(70),
                            topRight: Radius.circular(70))),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            loginFormWidget(loginScreenConext: context),
                            const SizedBox(
                              height: 30,
                            ),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: 'Need an account?',
                                    style: GoogleFonts.nunito(
                                        color: provider.IsThemeStatusBlack
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                                TextSpan(
                                    text: 'SIGN UP',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => {
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    routes.signUpRoute)
                                          },
                                    style: GoogleFonts.nunito(
                                        color: ColorManager.primeryColor,
                                        fontSize: 17,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w700))
                              ]),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
