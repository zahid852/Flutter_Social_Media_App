import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media_app/Resources/color_manager.dart';
import 'package:social_media_app/Screens/profile/profileFormWidget.dart';
import 'package:social_media_app/Utils/utils.dart';

class profileScreen extends StatefulWidget {
  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  @override
  Widget build(BuildContext context) {
    final viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    bool isKeyboard = viewInsetsBottom != 0;
    return Scaffold(
      body: GestureDetector(
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
                            'Profile Setup',
                            style: GoogleFonts.nunito(
                                color: ColorManager.white,
                                fontSize: 27,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ))
                  : const SizedBox.shrink(),
              Positioned(
                bottom: 0,
                child: Container(
                  height: !isKeyboard
                      ? getHeight(context: context) * 0.8
                      : getHeight(context: context) - viewInsetsBottom,
                  width: getWidth(context: context),
                  decoration: BoxDecoration(
                      color: ColorManager.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(70),
                          topRight: Radius.circular(70))),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Sign Up form Widget
                          ProfileFormWidget(ProfileFormScreenConext: context),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
