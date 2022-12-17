import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/resources/color_manager.dart';

double getHeight({required BuildContext context}) {
  return MediaQuery.of(context).size.height;
}

double getWidth({required BuildContext context}) {
  return MediaQuery.of(context).size.width;
}

bool isEmailValid(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

Widget builtToast(
    {required String verdict, required String mes, double fontsize = 15}) {
  bool isError = toastMessageVerdict.Error.toString() == verdict;
  return Container(
      decoration: BoxDecoration(
          color: isError ? ColorManager.error : ColorManager.success,
          borderRadius: BorderRadius.circular(6)),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: isError ? 5 : 6),
      child: Text(
        mes,
        style:
            GoogleFonts.nunito(fontSize: fontsize, color: ColorManager.white),
      ));
}
