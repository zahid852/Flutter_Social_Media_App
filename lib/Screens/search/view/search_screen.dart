import 'dart:developer';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/Resources/asset_manager.dart';
import 'package:social_media_app/Resources/routes_manager.dart';
import 'package:social_media_app/Screens/search/view_model/follow_view_model.dart';
import 'package:social_media_app/Screens/search/view_model/search_profile_model_viewstate.dart';
import 'package:social_media_app/Screens/search/view_model/search_view_model.dart';
import 'package:social_media_app/Theme/theme_provider.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/Utils/logedin_user_info.dart';
import 'package:social_media_app/Utils/utils.dart';

class searchScreen extends StatefulWidget {
  final void Function(int) changeMainScreen;
  searchScreen({required this.changeMainScreen});
  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  TextEditingController searchEditingController = TextEditingController();
  late SearchViewModel _searchViewModel;

  @override
  void initState() {
    _searchViewModel = SearchViewModel();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    searchEditingController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (ctx, provider, _) {
      return SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: TextField(
                    controller: searchEditingController,
                    onChanged: (value) {
                      _searchViewModel.getSearchedUsers(
                          search: searchEditingController.text.trim());
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 13),
                        fillColor: provider.IsThemeStatusBlack
                            ? Colors.grey[600]
                            : Colors.grey[200],
                        filled: true,
                        hintText: 'Search',
                        hintStyle: GoogleFonts.nunito(
                            color: provider.IsThemeStatusBlack
                                ? Colors.grey[50]
                                : Colors.grey,
                            fontSize: 16),
                        prefixIcon: Icon(
                          color: provider.IsThemeStatusBlack
                              ? Colors.grey[50]
                              : Colors.grey,
                          Icons.search,
                          size: 27.5,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                                color: Colors.transparent, width: 1))),
                  ),
                ),
                Expanded(
                    child: StreamBuilder(
                        stream: _searchViewModel.searchStreamController.stream,
                        builder: (context, snapshot) {
                          if (searchEditingController.text.isEmpty) {
                            return KeyboardVisibilityBuilder(
                                builder: (context, isKeyboardVisible) {
                              return isKeyboardVisible
                                  ? SizedBox.fromSize()
                                  : Center(
                                      child: Container(
                                        padding: EdgeInsets.only(bottom: 60),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: getHeight(
                                                        context: context) *
                                                    0.4,
                                                width:
                                                    getWidth(context: context) *
                                                        0.7,
                                                child: Lottie.asset(
                                                    LottieAssets.search),
                                              ),
                                              Container(
                                                width:
                                                    getWidth(context: context) *
                                                        0.7,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Search Users",
                                                  maxLines: 4,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.nunito(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                            });
                          } else {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.data!.isEmpty) {
                              return KeyboardVisibilityBuilder(
                                  builder: (context, isKeyboardVisible) {
                                return isKeyboardVisible
                                    ? Center(
                                        child: Text(
                                          "No user found",
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.nunito(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    : Center(
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 60),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: getHeight(
                                                          context: context) *
                                                      0.3,
                                                  width: getWidth(
                                                          context: context) *
                                                      0.7,
                                                  child: Lottie.asset(
                                                      LottieAssets.empty),
                                                ),
                                                Container(
                                                  width: getWidth(
                                                          context: context) *
                                                      0.7,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "No user found",
                                                    maxLines: 4,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.nunito(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                              });
                            } else if (snapshot.hasError) {
                              return KeyboardVisibilityBuilder(
                                  builder: (context, isKeyboardVisible) {
                                return isKeyboardVisible
                                    ? SizedBox.shrink()
                                    : Center(
                                        child: Container(
                                          padding: EdgeInsets.only(bottom: 60),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: getHeight(
                                                          context: context) *
                                                      0.3,
                                                  width: getWidth(
                                                          context: context) *
                                                      0.7,
                                                  child: Lottie.asset(
                                                      LottieAssets.error),
                                                ),
                                                Container(
                                                  width: getWidth(
                                                          context: context) *
                                                      0.7,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    _searchViewModel.message,
                                                    maxLines: 4,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.nunito(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                              });
                            }
                            return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (contx, index) {
                                  final searchProfileModelViewState
                                      searchModel = snapshot.data![index];
                                  return Container(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 12),
                                    child: ListTile(
                                      onTap: () {
                                        if (searchModel.userId ==
                                            logedinUserInfo.UserId) {
                                          widget.changeMainScreen(4);
                                        } else {
                                          Navigator.of(context).pushNamed(
                                              routes.profilePageRoute,
                                              arguments: searchModel);
                                        }
                                      },
                                      leading: CircleAvatar(
                                        radius: 26,
                                        child: CircleAvatar(
                                          radius: 25,
                                          child: ClipOval(
                                            child: FancyShimmerImage(
                                                boxFit: BoxFit.cover,
                                                imageUrl: searchModel.imageUrl),
                                          ),
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 12),
                                      title: Text(
                                        searchModel.username,
                                        style: GoogleFonts.nunito(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      subtitle: Text(
                                        searchModel.name,
                                        style: GoogleFonts.nunito(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  );
                                });
                          }
                        }))
              ],
            ),
          ),
        ),
      );
    });
  }
}
