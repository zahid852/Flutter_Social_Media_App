import 'dart:developer';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:social_media_app/Resources/asset_manager.dart';
import 'package:social_media_app/Resources/color_manager.dart';
import 'package:social_media_app/Resources/routes_manager.dart';
import 'package:social_media_app/Screens/home/components/chewi_video_player.dart';
import 'package:social_media_app/Screens/home/components/like_button.dart';
import 'package:social_media_app/Screens/home/components/post_comments.dart';
import 'package:social_media_app/Screens/home/view_models/home_view_model.dart';
import 'package:social_media_app/Screens/home/view_models/post_view_model.dart';
import 'package:social_media_app/Theme/theme_provider.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/Utils/utils.dart';
import 'package:video_player/video_player.dart';

import '../../../Utils/logedin_user_info.dart';

class postLists extends StatefulWidget {
  final List<PostViewModel> list;
  final homeViewModel viewModel;
  postLists({required this.list, required this.viewModel});

  @override
  State<postLists> createState() => _postListsState();
}

class _postListsState extends State<postLists> {
  final _toast = FToast();
  late DateTime now;

  @override
  void initState() {
    _toast.init(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (ctx, provider, _) {
      return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: widget.list.length,
          itemBuilder: (ctx, index) {
            bool isFavorite = false;
            final PostViewModel data = widget.list[index];

            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  // color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 10, bottom: 10),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: ColorManager.primeryColor,
                              child: CircleAvatar(
                                radius: 24,
                                child: ClipOval(
                                  child: FancyShimmerImage(
                                      boxDecoration: const BoxDecoration(
                                          shape: BoxShape.circle),
                                      boxFit: BoxFit.cover,
                                      imageUrl: data.userImageUrl),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 14,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.username,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    data.place,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.nunito(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            if (data.userId == logedinUserInfo.UserId)
                              PopupMenuButton(
                                  color: provider.IsThemeStatusBlack
                                      ? Colors.black
                                      : Colors.white,
                                  position: PopupMenuPosition.under,
                                  onSelected: (value) async {
                                    if (value == 0) {
                                      await showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return AlertDialog(
                                              backgroundColor:
                                                  provider.IsThemeStatusBlack
                                                      ? Colors.grey[900]
                                                      : Colors.white,
                                              title: Text(
                                                'Notice',
                                                style: GoogleFonts.nunito(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              content: Text(
                                                'Are you sure, you want to delete this post?',
                                                style: GoogleFonts.nunito(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      showDialog(
                                                          context: context,
                                                          builder: (ctx) {
                                                            return AlertDialog(
                                                              backgroundColor:
                                                                  provider.IsThemeStatusBlack
                                                                      ? Colors
                                                                          .black
                                                                      : Colors
                                                                          .white,
                                                              titlePadding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 30),
                                                              title: Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                'Deleting Post...',
                                                                style: GoogleFonts.nunito(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              content:
                                                                  Container(
                                                                height: 100,
                                                                width: 100,
                                                                child:
                                                                    const Center(
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                ),
                                                              ),
                                                            );
                                                          });

                                                      bool result = await widget
                                                          .viewModel
                                                          .DeletePost(
                                                              postId:
                                                                  data.postId);
                                                      Navigator.of(context)
                                                          .pop();

                                                      if (result) {
                                                        _toast.showToast(
                                                            child: builtToast(
                                                                verdict: toastMessageVerdict
                                                                        .WithoutError
                                                                    .toString(),
                                                                mes: widget
                                                                    .viewModel
                                                                    .message));
                                                      } else {
                                                        _toast.showToast(
                                                            child: builtToast(
                                                                verdict: toastMessageVerdict
                                                                        .Error
                                                                    .toString(),
                                                                mes: widget
                                                                    .viewModel
                                                                    .message));
                                                      }
                                                    },
                                                    child: Text(
                                                      'Yes',
                                                      style: GoogleFonts.nunito(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      'No',
                                                      style: GoogleFonts.nunito(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ))
                                              ],
                                            );
                                          });
                                    } else if (value == 1) {
                                      return;
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  itemBuilder: (ctx) {
                                    return [
                                      PopupMenuItem(
                                          value: 0,
                                          child: Row(
                                            children: const [
                                              Icon(
                                                Icons.delete,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text('Delete'),
                                            ],
                                          )),
                                      PopupMenuItem(
                                          value: 1,
                                          child: Row(
                                            children: const [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 3.5),
                                                child: Icon(
                                                  IconlyBold.closeSquare,
                                                  size: 19,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 12.1,
                                              ),
                                              Text('Cancel'),
                                            ],
                                          ))
                                    ];
                                  })
                          ],
                        ),
                      ),
                      if (data.fileType == FileTypeOption.Image.toString())
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(routes.ImageRoute,
                                arguments: data.file);
                          },
                          child: Container(
                            child: AspectRatio(
                                aspectRatio: 4 / 3,
                                child: FancyShimmerImage(
                                    boxFit: BoxFit.cover,
                                    errorWidget: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 80,
                                          width: 80,
                                          child: Image.asset(
                                            ImageAssets.emptyPost,
                                            color: provider.IsThemeStatusBlack
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                          width:
                                              getWidth(context: context) * 0.7,
                                          child: Text(
                                            "Couldn't load .\nSomething went wrong.",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.nunito(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        )
                                      ],
                                    ),
                                    imageUrl: data.file)),
                          ),
                        ),
                      if (data.fileType == FileTypeOption.Video.toString())
                        chewiVideoPlayer(
                          videoController: VideoPlayerController.network(
                            data.file,
                          ),
                          url: data.file,
                        ),
                      Container(
                        padding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 4),
                        child: Row(
                          children: [
                            likeButton(
                              postId: data.postId,
                              userId: logedinUserInfo.UserId,
                              likes: data.likes,
                              idOfPostUser: data.userId,
                              username: data.username,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            postComments(
                              comments: data.comments,
                              viewModel: widget.viewModel,
                              postId: data.postId,
                              idOfPostUser: data.userId,
                              nameOfPostUser: data.username,
                            )
                          ],
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: ReadMoreText(
                            "${data.caption}",
                            preDataText: data.username,
                            preDataTextStyle: GoogleFonts.nunito(
                                fontSize: 14, fontWeight: FontWeight.w700),
                            trimMode: TrimMode.Line,
                            trimLines: 2,
                            style: GoogleFonts.nunito(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          )),
                      Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 3),
                          child: FutureBuilder(
                              future: getDateTerm(data.date),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return SizedBox.shrink();
                                } else if (snapshot.data!.isEmpty) {
                                  return SizedBox.shrink();
                                }
                                return Consumer<ThemeProvider>(
                                    builder: (ctx, provider, _) {
                                  return Text(
                                    snapshot.data!,
                                    style: GoogleFonts.nunito(
                                        color: provider.IsThemeStatusBlack
                                            ? Colors.white70
                                            : Colors.grey[700],
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  );
                                });
                              }))
                    ],
                  ),
                ),
              ],
            );
          });
    });
  }

  Future<int?> calculateDifference(DateTime date) async {
    try {
      now = await NTP.now();
    } catch (error) {
      return null;
    }
    return DateTime(now.year, now.month, now.day, now.hour)
        .difference(DateTime(date.year, date.month, date.day, date.hour))
        .inDays;
  }

  Future<int> calculateDifferenceInHours(DateTime date) async {
    return DateTime(now.year, now.month, now.day, now.hour, now.minute)
        .difference(
            DateTime(date.year, date.month, date.day, date.hour, date.minute))
        .inHours;
  }

  Future<int> calculateDifferenceInMinutes(DateTime date) async {
    return DateTime(now.year, now.month, now.day, now.hour, now.minute)
        .difference(
            DateTime(date.year, date.month, date.day, date.hour, date.minute))
        .inMinutes;
  }

  Future<String> getDateTerm(DateTime date) async {
    int? day = await calculateDifference(date);
    if (day == null) {
      return Empty;
    }
    switch (day) {
      case 0:
        int hours = await calculateDifferenceInHours(date);

        if (hours == 0) {
          int minutes = await calculateDifferenceInMinutes(date);
          if (minutes == 0) {
            return 'a moment ago';
          } else {
            if (minutes == 1) {
              return '${minutes} minute ago';
            } else {
              return '${minutes} minutes ago';
            }
          }
        } else {
          if (hours == 1) {
            return '${hours} hour ago';
          } else {
            return '${hours} hours ago';
          }
        }
      case 1:
        return '1 day ago';
      case 2:
        return '2 days ago';
      case 3:
        return '3 days ago';
      case 4:
        return '4 days ago';
      case 5:
        return '5 days ago';
      case 6:
        return '6 days ago';
      case 7:
        return 'a week ago';
      default:
        return '${DateFormat('yMMMMd').format(date)}';
    }
  }
}
