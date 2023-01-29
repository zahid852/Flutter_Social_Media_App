import 'dart:developer';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:social_media_app/Models/notification.dart';
import 'package:social_media_app/Resources/color_manager.dart';
import 'package:social_media_app/Screens/notification/components/notification_loading_widget.dart';
import 'package:social_media_app/Screens/notification/view_model/notification_view_model.dart';
import 'package:social_media_app/Theme/theme_provider.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/Utils/utils.dart';

import '../../../Resources/asset_manager.dart';

class notificationScreen extends StatefulWidget {
  @override
  State<notificationScreen> createState() => _notificationScreenState();
}

class _notificationScreenState extends State<notificationScreen> {
  late NotificationViewModel _notificationViewModel;
  late DateTime now;
  @override
  void initState() {
    _notificationViewModel = NotificationViewModel();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ThemeProvider>(builder: (ctx, provider, _) {
        return Container(
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
                    Text(
                      'Notification',
                      style: GoogleFonts.akayaTelivigala(
                          color: ColorManager.primeryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: StreamBuilder<List<notificationModel>>(
                      stream: _notificationViewModel
                          .NotificationStreamController.stream,
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListView.builder(
                              itemCount: 15,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, snapshot) {
                                return notificationLoadingWidget();
                              });
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
                                      "Something went wrong",
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
                        } else if (snapshot.data!.isEmpty) {
                          return Center(
                            child: Container(
                              padding: EdgeInsets.only(bottom: 60),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: getHeight(context: context) * 0.32,
                                    width: getWidth(context: context) * 0.6,
                                    child: Lottie.asset(LottieAssets.empty),
                                  ),
                                  Container(
                                    width: getWidth(context: context) * 0.7,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "No notifications here",
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
                          return ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (ctx, index) {
                                final snap = snapshot.data![index];
                                return Column(
                                  children: [
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              radius: 26,
                                              backgroundColor:
                                                  ColorManager.primeryColor,
                                              child: CircleAvatar(
                                                radius: 24,
                                                child: ClipOval(
                                                  child: FancyShimmerImage(
                                                      boxDecoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle),
                                                      boxFit: BoxFit.cover,
                                                      imageUrl: snap.imageUrl),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    snap.title,
                                                    softWrap: true,
                                                    style: GoogleFonts.nunito(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  ReadMoreText(
                                                    "${snap.body}",
                                                    trimMode: TrimMode.Line,
                                                    trimLines: 2,
                                                    trimExpandedText:
                                                        ' show less',
                                                    trimCollapsedText:
                                                        ' read more',
                                                    style: GoogleFonts.nunito(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    height: 6,
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: FutureBuilder(
                                                            future: getDateTerm(
                                                                snap.date),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .waiting) {
                                                                return SizedBox
                                                                    .shrink();
                                                              } else if (snapshot
                                                                  .data!
                                                                  .isEmpty) {
                                                                return SizedBox
                                                                    .shrink();
                                                              }
                                                              return Text(
                                                                snapshot.data!,
                                                                style: GoogleFonts.nunito(
                                                                    color: provider.IsThemeStatusBlack
                                                                        ? Colors
                                                                            .white70
                                                                        : Colors.grey[
                                                                            700],
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              );
                                                            })),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      height: 1,
                                      color: provider.IsThemeStatusBlack
                                          ? Colors.grey[700]
                                          : Colors.grey[300],
                                    ),
                                  ],
                                );
                              });
                        }
                      }))
            ],
          ),
        );
      }),
    );
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
