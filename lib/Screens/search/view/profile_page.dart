import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_media_app/Resources/asset_manager.dart';
import 'package:social_media_app/Resources/color_manager.dart';
import 'package:social_media_app/Resources/routes_manager.dart';
import 'package:social_media_app/Screens/profile/components/video_player.dart';
import 'package:social_media_app/Screens/search/components/shimmer_widget.dart';
import 'package:social_media_app/Screens/search/view_model/follow_view_model.dart';
import 'package:social_media_app/Screens/search/view_model/followers_following_view_model.dart';
import 'package:social_media_app/Screens/search/view_model/search_profile_model_viewstate.dart';
import 'package:social_media_app/Theme/theme_provider.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/Utils/logedin_user_info.dart';
import 'package:social_media_app/Utils/utils.dart';
import 'package:video_player/video_player.dart';

import '../../home/view_models/post_view_model.dart';
import '../../profile/view_model/posts_data.dart';
import 'package:http/http.dart' as http;

class profilePage extends StatefulWidget {
  final searchProfileModelViewState searchModel;
  profilePage({required this.searchModel});
  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  ProfilePostsData _profilePostsData = ProfilePostsData();
  late Future<List<PostViewModel>> future;
  bool isVideo = false;
  late FollowersViewModel _followersViewModel;
  late FollowersFollowingViewModel _followersFollowingViewModel;
  late Future followersFuture;
  late Future postsLengthFuture;
  bool followLoading = false;
  @override
  void initState() {
    future =
        _profilePostsData.getProfilePosts(userId: widget.searchModel.userId);
    followersFuture = Provider.of<FollowersViewModel>(context, listen: false)
        .getFollowers(userId: widget.searchModel.userId);
    postsLengthFuture = Provider.of<FollowersViewModel>(context, listen: false)
        .getPostsLength(userId: widget.searchModel.userId);
    _followersFollowingViewModel =
        FollowersFollowingViewModel(id: widget.searchModel.userId);

    // TODO: implement initState
    super.initState();
  }

  void sendPushMessage({
    required String token,
    required String username,
    required String body,
  }) async {
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAADNQB9nY:APA91bENkzJY5Qet4Q6M1lLWmyxvDYbK2q2-adPOIndDEGq3968gcUGrwEF2WwkaZ44aNAPO7qRUXjBhLLOLynH9lqDGKEsSK4U79-qtcMnwLPkJF14DGGTFBSWGlZgOW96MX1AGqgbP',
        },
        body: jsonEncode(<String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'body': body,
            'title': username,
            'type': 'follow'
          },
          'notification': <String, dynamic>{
            'body': body,
            'title': username,
            'android_channel_id': 'social_media_app'
          },
          'to': token
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: EdgeInsets.only(top: 10, bottom: 6),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                  ),
                  Positioned(
                    left: 16,
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: ColorManager.primeryColor,
                        )),
                  ),
                  Text(
                    'Profile',
                    style: GoogleFonts.akayaTelivigala(
                        color: ColorManager.primeryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
            Expanded(
                child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Row(
                    children: [
                      if (widget.searchModel.imageUrl.isNotEmpty)
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: ColorManager.primeryColor,
                          child: CircleAvatar(
                            radius: 48,
                            child: ClipOval(
                              child: FancyShimmerImage(
                                  boxDecoration: const BoxDecoration(
                                      shape: BoxShape.circle),
                                  boxFit: BoxFit.cover,
                                  imageUrl: widget.searchModel.imageUrl),
                            ),
                          ),
                        ),
                      if (widget.searchModel.imageUrl.isEmpty)
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: ColorManager.primeryColor,
                          child: CircleAvatar(
                            radius: 48,
                            child: ClipOval(
                                child: Image.asset(ImageAssets.emptyImage)),
                          ),
                        ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FutureBuilder(
                                  future: postsLengthFuture,
                                  builder: (ctx, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return shimmerWidget();
                                    } else {
                                      return Consumer<FollowersViewModel>(
                                          builder: (ctx, dataObject, _) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              dataObject.posts.toString(),
                                              style: GoogleFonts.nunito(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              'posts',
                                              style: GoogleFonts.nunito(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        );
                                      });
                                    }
                                  }),
                              StreamBuilder(
                                  stream: _followersFollowingViewModel
                                      .followerStreamController.stream,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return shimmerWidget();
                                    }
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          snapshot.data!.toString(),
                                          style: GoogleFonts.nunito(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          'followers',
                                          style: GoogleFonts.nunito(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    );
                                  }),
                              StreamBuilder(
                                  stream: _followersFollowingViewModel
                                      .followingStreamController.stream,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return shimmerWidget();
                                    }
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          snapshot.data!.toString(),
                                          style: GoogleFonts.nunito(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          'following',
                                          style: GoogleFonts.nunito(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    );
                                  }),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          FutureBuilder(
                              future: followersFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Shimmer.fromColors(
                                      child: Container(
                                        width: double.infinity,
                                        height: 33,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Utils(context: context)
                                                .WidgetShimmerColor),
                                      ),
                                      baseColor: Utils(context: context)
                                          .baseShimmerColor,
                                      highlightColor: Utils(context: context)
                                          .highlightShimmerColor);
                                }

                                return Consumer<FollowersViewModel>(
                                    builder: (context, followersData, _) {
                                  return followLoading
                                      ? const Center(
                                          child: CircleAvatar(
                                              radius: 18.3,
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: Center(
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  radius: 14,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 3,
                                                  ),
                                                ),
                                              )),
                                        )
                                      : InkWell(
                                          highlightColor: Colors.transparent,
                                          splashColor: followersData.isFollow
                                              ? Colors.grey[300]
                                              : Colors.blue,
                                          onTap: (() async {
                                            setState(() {
                                              followLoading = true;
                                            });
                                            if (!followersData.isFollow) {
                                              await Provider.of<
                                                          FollowersViewModel>(
                                                      context,
                                                      listen: false)
                                                  .FollowUser(
                                                      userId: widget
                                                          .searchModel.userId);
                                              final date = await NTP.now();
                                              await Provider.of<
                                                          FollowersViewModel>(
                                                      context,
                                                      listen: false)
                                                  .FollowNotification(
                                                title:
                                                    widget.searchModel.username,
                                                body:
                                                    '${logedinUserInfo.Username} started following you',
                                                date: date,
                                                toId: [
                                                  widget.searchModel.userId
                                                ],
                                                byId: logedinUserInfo.UserId,
                                              );
                                              final UsersToken =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('UserTokens')
                                                      .doc(widget
                                                          .searchModel.userId)
                                                      .get();

                                              String token = Empty;

                                              token = UsersToken['token'];

                                              sendPushMessage(
                                                  token: token,
                                                  username: widget
                                                      .searchModel.username,
                                                  body:
                                                      '${logedinUserInfo.Username} started following you');
                                            } else {
                                              await Provider.of<
                                                          FollowersViewModel>(
                                                      context,
                                                      listen: false)
                                                  .UnfollowUser(
                                                      userId: widget
                                                          .searchModel.userId);
                                            }

                                            setState(() {
                                              followLoading = false;
                                            });
                                          }),
                                          child: Consumer<ThemeProvider>(
                                              builder: (ctx, provider, _) {
                                            return Container(
                                              width: double.infinity,
                                              alignment: Alignment.center,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                  color: followersData.isFollow
                                                      ? Colors.transparent
                                                      : ColorManager
                                                          .primeryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                      color: followersData
                                                              .isFollow
                                                          ? provider
                                                                  .IsThemeStatusBlack
                                                              ? Colors.white
                                                              : Colors.black
                                                          : Colors
                                                              .transparent)),
                                              child: Text(
                                                followersData.isFollow
                                                    ? 'Unfollow'
                                                    : 'Follow',
                                                style: GoogleFonts.nunito(
                                                    color: followersData
                                                            .isFollow
                                                        ? provider
                                                                .IsThemeStatusBlack
                                                            ? Colors.white
                                                            : Colors.black
                                                        : Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            );
                                          }),
                                        );
                                });
                              })
                        ],
                      ))
                    ],
                  ),
                ),
                Consumer<ThemeProvider>(builder: (ctx, provider, _) {
                  return Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.searchModel.username,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.searchModel.name.isEmpty
                              ? "${widget.searchModel.username}'s Name"
                              : widget.searchModel.name,
                          style: GoogleFonts.nunito(
                              color: widget.searchModel.name.isEmpty
                                  ? Colors.grey
                                  : provider.IsThemeStatusBlack
                                      ? Colors.white
                                      : Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          widget.searchModel.about.isEmpty
                              ? "${widget.searchModel.username}'s About"
                              : widget.searchModel.about,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: widget.searchModel.about.isEmpty
                                  ? Colors.grey
                                  : provider.IsThemeStatusBlack
                                      ? Colors.grey[50]
                                      : Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(
                  height: 14,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Posts',
                    style: GoogleFonts.nunito(
                        fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                const Divider(
                  height: 1,
                  color: Colors.grey,
                ),
                Consumer<ThemeProvider>(builder: (ctx, provider, _) {
                  return Container(
                    width: getWidth(context: context),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: [
                        Flexible(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isVideo = false;
                                });
                              },
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.photo,
                                        size: 23,
                                        color: !isVideo
                                            ? ColorManager.primeryColor
                                            : provider.IsThemeStatusBlack
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Pictures',
                                        style: GoogleFonts.nunito(
                                            color: !isVideo
                                                ? ColorManager.primeryColor
                                                : provider.IsThemeStatusBlack
                                                    ? Colors.white
                                                    : Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  )),
                            )),
                        Flexible(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isVideo = true;
                                });
                              },
                              child: Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        IconlyBold.video,
                                        size: 23,
                                        color: isVideo
                                            ? ColorManager.primeryColor
                                            : provider.IsThemeStatusBlack
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Videos',
                                        style: GoogleFonts.nunito(
                                            color: isVideo
                                                ? ColorManager.primeryColor
                                                : provider.IsThemeStatusBlack
                                                    ? Colors.white
                                                    : Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  )),
                            ))
                      ],
                    ),
                  );
                }),
                const SizedBox(
                  height: 3,
                ),
                Expanded(
                    child: FutureBuilder(
                        future: future,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 2,
                                        mainAxisSpacing: 2),
                                itemCount: 20,
                                itemBuilder: (context, index) {
                                  return Shimmer.fromColors(
                                    baseColor: Utils(context: context)
                                        .baseShimmerColor,
                                    highlightColor: Colors.grey[300]!,
                                    child: Container(
                                      color: Utils(context: context)
                                          .baseShimmerColor,
                                    ),
                                  );
                                });
                          } else if (snapshot.data!.isEmpty) {
                            return Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: SizedBox(
                                      height: getHeight(context: context) * 0.3,
                                      width: getWidth(context: context) * 0.6,
                                      child: Lottie.asset(LottieAssets.empty),
                                    ),
                                  ),
                                  Flexible(
                                    child: Container(
                                      padding: EdgeInsets.only(top: 10),
                                      width: getWidth(context: context) * 0.7,
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        "No Photos & Videos here",
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.nunito(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Container(
                                padding: EdgeInsets.only(bottom: 60),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: getHeight(context: context) * 0.3,
                                      width: getWidth(context: context) * 0.5,
                                      child: Lottie.asset(LottieAssets.error),
                                    ),
                                    Container(
                                      width: getWidth(context: context) * 0.7,
                                      alignment: Alignment.center,
                                      child: Text(
                                        snapshot.error.toString(),
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.nunito(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else {
                            List<String> Photos = [];
                            List<String> Videos = [];
                            snapshot.data!.forEach((e) {
                              if (e.fileType ==
                                  FileTypeOption.Image.toString()) {
                                Photos.add(e.file);
                              } else {
                                Videos.add(e.file);
                              }
                            });

                            if (!isVideo && Photos.isNotEmpty) {
                              return GridView.builder(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 10, 5),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 2,
                                          mainAxisSpacing: 2),
                                  itemCount: Photos.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            routes.ImageRoute,
                                            arguments: Photos[index]);
                                      },
                                      child: FancyShimmerImage(
                                          boxFit: BoxFit.cover,
                                          errorWidget: Container(
                                            color: Utils(context: context)
                                                .baseShimmerColor,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child: Image.asset(
                                                        ImageAssets.emptyPost),
                                                  ),
                                                ),
                                                const Flexible(
                                                  child: SizedBox(
                                                    height: 10,
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  child: Text(
                                                    "Couldn't load image",
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.nunito(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          imageUrl: Photos[index]),
                                    );
                                  });
                            } else if (isVideo && Videos.isEmpty) {
                              return Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: Icon(
                                        IconlyLight.video,
                                        size: 100,
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        padding: EdgeInsets.only(top: 10),
                                        width: getWidth(context: context) * 0.7,
                                        alignment: Alignment.topCenter,
                                        child: Text(
                                          "No Videos here",
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.nunito(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            } else if (!isVideo && Photos.isEmpty) {
                              return Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Flexible(
                                      flex: 2,
                                      child: SizedBox(
                                        child: Icon(
                                          Icons.photo,
                                          size: 100,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        padding: EdgeInsets.only(top: 10),
                                        width: getWidth(context: context) * 0.7,
                                        alignment: Alignment.topCenter,
                                        child: Text(
                                          "No Photos here",
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.nunito(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            } else if (isVideo && Videos.isNotEmpty) {
                              return GridView.builder(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 10, 5),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 2,
                                          mainAxisSpacing: 2),
                                  itemCount: Videos.length,
                                  itemBuilder: (context, index) {
                                    return videoPlayer(
                                        videoController:
                                            VideoPlayerController.network(
                                          Videos[index],
                                        ),
                                        url: Videos[index]);
                                  });
                            }
                            return SizedBox.shrink();
                          }
                        }))
              ],
            ))
          ],
        ),
      )),
    );
  }
}
