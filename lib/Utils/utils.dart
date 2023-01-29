import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_media_app/Theme/theme_provider.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/resources/color_manager.dart';

class Utils {
  BuildContext context;
  Utils({required this.context});

  bool get getTheme => Provider.of<ThemeProvider>(context).IsThemeStatusBlack;
  Color get getThemeTextColor => getTheme ? Colors.white : Colors.black;

  Color get baseShimmerColor =>
      getTheme ? Colors.grey.shade500 : Colors.grey.shade200;

  Color get highlightShimmerColor =>
      getTheme ? Colors.grey.shade700 : Colors.grey.shade400;

  Color get WidgetShimmerColor =>
      getTheme ? Colors.grey.shade600 : Colors.grey.shade100;
}

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

Map<String, dynamic> toNavigationDestinationMap(
    {required String name,
    required IconData unselectedIcon,
    required IconData selectedIcon}) {
  return {
    'name': name,
    'unselectedIcon': unselectedIcon,
    'selectedIcon': selectedIcon
  };
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    await Geolocator.openLocationSettings();
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

Future<List<Placemark>> GetAddressFromLatLong(
    {required Position postion}) async {
  List<Placemark> placemark =
      await placemarkFromCoordinates(postion.latitude, postion.longitude);
  return placemark;
}
