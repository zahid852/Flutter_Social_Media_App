import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/resources/color_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    colorScheme: ThemeData().colorScheme.copyWith(
          primary: ColorManager.primeryColor,
        ),
    // primaryColor: ColorManager.primeryColor
  );
}
