import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_media_app/Resources/asset_manager.dart';
import 'package:social_media_app/Resources/color_manager.dart';
import 'package:social_media_app/Resources/routes_manager.dart';
import 'package:social_media_app/Screens/home/components/chewi_video_player.dart';
import 'package:social_media_app/Screens/home/view_models/post_view_model.dart';
import 'package:social_media_app/Screens/profile/profile_Setup/profile_model_view_state.dart';
import 'package:social_media_app/Screens/profile/view_model/posts_data.dart';
import 'package:social_media_app/Screens/search/view_model/follow_view_model.dart';
import 'package:social_media_app/Screens/search/view_model/followers_following_view_model.dart';
import 'package:social_media_app/Theme/theme_provider.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/Utils/logedin_user_info.dart';
import 'package:social_media_app/Utils/utils.dart';
import 'package:video_player/video_player.dart';

import '../../search/components/shimmer_widget.dart';
import '../components/video_player.dart';

class profileScreen extends StatefulWidget {
  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  ProfilePostsData _profilePostsData = ProfilePostsData();
  late Future<List<PostViewModel>> future;
  bool isVideo = false;
  late FollowersViewModel _followersViewModel;
  late FollowersFollowingViewModel _followersFollowingViewModel;

  late Future postsLengthFuture;

  @override
  void initState() {
    future = _profilePostsData.getProfilePosts(userId: logedinUserInfo.UserId);

    postsLengthFuture = Provider.of<FollowersViewModel>(context, listen: false)
        .getPostsLength(userId: logedinUserInfo.UserId);
    _followersFollowingViewModel =
        FollowersFollowingViewModel(id: logedinUserInfo.UserId);
    // TODO: implement initState
    super.initState();
  }

  List<PopupMenuItem> itemsList = [
    PopupMenuItem(
      value: 0,
      child: Row(
        children: [
          Text(
            'Theme',
            style:
                GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            width: 50,
          ),
          Consumer<ThemeProvider>(builder: (ctx, provider, _) {
            return Icon(
              provider.IsThemeStatusBlack ? Icons.light_mode : Icons.dark_mode,
              size: 18,
            );
          })
        ],
      ),
    ),
    PopupMenuItem(
        value: 1,
        child: Row(
          children: [
            Text(
              'Logout',
              style:
                  GoogleFonts.nunito(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              width: 50,
            ),
            const Icon(
              IconlyLight.logout,
              size: 18,
            )
          ],
        ))
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 10, bottom: 6),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                  ),
                  Positioned(
                      left: 14,
                      child:
                          Consumer<ThemeProvider>(builder: (ctx, provider, _) {
                        return Container(
                            child: PopupMenuButton(
                          color: provider.IsThemeStatusBlack
                              ? Colors.black
                              : Colors.white,
                          onSelected: (value) async {
                            if (value == 1) {
                              await FirebaseAuth.instance.signOut();
                            } else if (value == 0) {
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .setTheme = !Provider.of<ThemeProvider>(
                                      context,
                                      listen: false)
                                  .getThemeStatus;
                            }
                          },
                          itemBuilder: (ctx) {
                            return itemsList;
                          },
                        ));
                      })),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    child: Row(
                      children: [
                        if (logedinUserInfo.imageUrl.isNotEmpty)
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
                                    imageUrl: '${logedinUserInfo.imageUrl}'),
                              ),
                            ),
                          ),
                        if (logedinUserInfo.imageUrl.isEmpty)
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                Text(
                                                  'posts',
                                                  style: GoogleFonts.nunito(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                              '${snapshot.data!}',
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
                              GestureDetector(
                                onTap: (() async {
                                  final result = await Navigator.of(context)
                                      .pushNamed(routes.profileRoute,
                                          arguments: [
                                        profileSetup.Profile.toString(),
                                        profileModelViewState(
                                            name: logedinUserInfo.Name,
                                            about: logedinUserInfo.About,
                                            date: logedinUserInfo.BirthDate,
                                            imageUrl: logedinUserInfo.imageUrl),
                                      ]);
                                  if (result == true) {
                                    setState(() {});
                                  }
                                }),
                                child: Consumer<ThemeProvider>(
                                    builder: (ctx, provider, _) {
                                  return Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                            color: provider.IsThemeStatusBlack
                                                ? Colors.white
                                                : Colors.black)),
                                    child: Text(
                                      'Edit Profile',
                                      style: GoogleFonts.nunito(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Consumer<ThemeProvider>(builder: (ctx, provider, _) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            logedinUserInfo.Username,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            logedinUserInfo.Name.isEmpty
                                ? "${logedinUserInfo.Username}'s Name"
                                : logedinUserInfo.Name,
                            style: GoogleFonts.nunito(
                                color: logedinUserInfo.Name.isEmpty
                                    ? Colors.grey
                                    : provider.IsThemeStatusBlack
                                        ? Colors.white
                                        : Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            logedinUserInfo.About.isEmpty
                                ? "${logedinUserInfo.Username}'s About"
                                : logedinUserInfo.About,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: logedinUserInfo.About.isEmpty
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
                  Container(
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
                              child: Consumer<ThemeProvider>(
                                  builder: (ctx, provider, _) {
                                return Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                    ));
                              }),
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
                                  child: Consumer<ThemeProvider>(
                                      builder: (ctx, provider, _) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                    );
                                  })),
                            ))
                      ],
                    ),
                  ),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 5, 5),
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
                                        height:
                                            getHeight(context: context) * 0.3,
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
                                        height:
                                            getHeight(context: context) * 0.3,
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
                                                          ImageAssets
                                                              .emptyPost),
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
                                                      textAlign:
                                                          TextAlign.center,
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
                                          width:
                                              getWidth(context: context) * 0.7,
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
                                      Flexible(
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
                                          width:
                                              getWidth(context: context) * 0.7,
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
              ),
            )
          ])),
    );
  }
}
