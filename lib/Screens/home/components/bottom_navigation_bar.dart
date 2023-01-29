import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/Resources/color_manager.dart';
import 'package:social_media_app/Theme/theme_provider.dart';

import '../../../Utils/utils.dart';

class bottomNavigationBar extends StatefulWidget {
  int currentIndex;
  final void Function(int index) changeScreen;
  bottomNavigationBar({required this.currentIndex, required this.changeScreen});
  @override
  State<bottomNavigationBar> createState() => _bottomNavigationBarState();
}

class _bottomNavigationBarState extends State<bottomNavigationBar> {
  late final List<Map<String, dynamic>> _navigationButtons = [
    toNavigationDestinationMap(
        name: 'Home',
        unselectedIcon: Icons.home_outlined,
        selectedIcon: Icons.home_filled),
    toNavigationDestinationMap(
        name: 'Search',
        unselectedIcon: Icons.search_outlined,
        selectedIcon: Icons.search),
    toNavigationDestinationMap(
        name: 'Post',
        unselectedIcon: Icons.add_circle_outline,
        selectedIcon: Icons.add_circle),
    toNavigationDestinationMap(
        name: 'Notification',
        unselectedIcon: Icons.notifications_outlined,
        selectedIcon: Icons.notifications),
    toNavigationDestinationMap(
        name: 'Profile',
        unselectedIcon: Icons.person_outline,
        selectedIcon: Icons.person)
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (ctx, themeProvider, _) {
      return NavigationBarTheme(
        data: NavigationBarThemeData(
            indicatorColor: ColorManager.primeryColor,
            iconTheme: MaterialStatePropertyAll(IconThemeData(
                color: themeProvider.IsThemeStatusBlack
                    ? Colors.white
                    : Colors.black)),
            labelTextStyle: MaterialStateProperty.all(GoogleFonts.nunito(
              color: themeProvider.IsThemeStatusBlack
                  ? Colors.white
                  : Colors.black,
              fontSize: 13,
            ))),
        child: NavigationBar(
            height: 75,
            backgroundColor: themeProvider.IsThemeStatusBlack
                ? Colors.black
                : Colors.grey[50],
            selectedIndex: widget.currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                widget.currentIndex = index;
              });
              widget.changeScreen(widget.currentIndex);
            },
            animationDuration: const Duration(seconds: 2),
            destinations: _navigationButtons
                .map((item) => NavigationDestination(
                      icon: Icon(
                        item['unselectedIcon'],
                        size: 25,
                      ),
                      label: item['name'],
                      selectedIcon: Icon(
                        item['selectedIcon'],
                        color: ColorManager.white,
                      ),
                    ))
                .toList()),
      );
    });
  }
}
