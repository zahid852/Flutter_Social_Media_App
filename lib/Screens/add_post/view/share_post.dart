import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ntp/ntp.dart';
import 'package:social_media_app/Resources/asset_manager.dart';
import 'package:social_media_app/Resources/color_manager.dart';
import 'package:social_media_app/Resources/routes_manager.dart';
import 'package:social_media_app/Screens/add_post/view_model/share_post_view_model.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/Utils/logedin_user_info.dart';
import 'package:social_media_app/Utils/utils.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class sharePost extends StatefulWidget {
  final File? file;
  final FileTypeOption? fileType;

  sharePost({
    required this.file,
    required this.fileType,
  });
  @override
  State<sharePost> createState() => _sharePostState();
}

class _sharePostState extends State<sharePost> {
  sharePostViewModel _postViewModel = sharePostViewModel();

  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayer;
  bool _isVisible = true;
  final _toast = FToast();
  bool _isLoading = false;
  TextEditingController _captionEditingController = TextEditingController();
  TextEditingController _placeEditingController = TextEditingController();
  String _address = Empty;
  bool _isDataSaving = false;
  @override
  void initState() {
    _toast.init(context);
    if (widget.fileType == FileTypeOption.Video) {
      _videoPlayerController = VideoPlayerController.file(widget.file!);
      _initializeVideoPlayer = _videoPlayerController.initialize();
      _videoPlayerController.addListener(() {
        if (_videoPlayerController.value.position ==
            _videoPlayerController.value.duration) {
          setState(() {
            _isVisible = true;
          });
        }
      });
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    if (widget.fileType == FileTypeOption.Video) {
      _videoPlayerController.dispose();
    }
    _captionEditingController.dispose();
    _placeEditingController.dispose();
    super.dispose();
  }

  String _videoDuration(Duration duration) {
    String twoDigits(int n) {
      return n.toString().padLeft(2, '0');
    }

    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 1) hours, minutes, seconds].join(':');
  }

  void sendPushMessage({
    required List<String> token,
    required String title,
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
            'title': title,
            'type': 'share'
          },
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
            'android_channel_id': 'social_media_app'
          },
          'registration_ids': token
        }));
  }

  @override
  Widget build(BuildContext context) {
    bool _isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: getWidth(context: context),
                  height: 70,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            left: 5,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.arrow_back_ios)),
                          ),
                          Center(
                            child: Text(
                              'New Post',
                              style: GoogleFonts.nunito(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: _isDataSaving
                                ? const Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: CircleAvatar(
                                        radius: 13,
                                        backgroundColor: Colors.transparent,
                                        child: Center(
                                            child:
                                                CircularProgressIndicator())),
                                  )
                                : TextButton(
                                    onPressed: () async {
                                      if (!_isLoading) {
                                        setState(() {
                                          _isDataSaving = true;
                                        });
                                        bool internetConnection =
                                            await InternetConnectionChecker()
                                                .hasConnection;
                                        if (!internetConnection) {
                                          _toast.showToast(
                                              child: builtToast(
                                                  verdict: toastMessageVerdict
                                                      .Error.toString(),
                                                  mes:
                                                      'No internet connection'));
                                          setState(() {
                                            _isDataSaving = false;
                                          });
                                        } else {
                                          final result =
                                              await _postViewModel.sharePost(
                                                  file: widget.file!,
                                                  fileType: widget.fileType!,
                                                  caption:
                                                      _captionEditingController
                                                          .text,
                                                  address:
                                                      _placeEditingController
                                                          .text);
                                          if (result) {
                                            final date = await NTP.now();

                                            final snap = await FirebaseFirestore
                                                .instance
                                                .collection('Follow')
                                                .doc(logedinUserInfo.UserId)
                                                .get();
                                            if (snap.exists) {
                                              List<dynamic> allFollowers =
                                                  snap['followers'];

                                              final allUsersTokens =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('UserTokens')
                                                      .get();

                                              List<String> val = [];

                                              allUsersTokens.docs
                                                  .forEach((element) {
                                                if (allFollowers
                                                    .contains(element.id)) {
                                                  val.add(element['token']);
                                                }
                                              });
                                              await _postViewModel.postNotification(
                                                  title: 'Hi there!',
                                                  body:
                                                      '${logedinUserInfo.Username} share a post',
                                                  date: date,
                                                  toId: allFollowers,
                                                  byId: logedinUserInfo.UserId);
                                              sendPushMessage(
                                                  token: val,
                                                  title: 'Hi there!',
                                                  body:
                                                      '${logedinUserInfo.Username} share a post');
                                            }
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    routes.mainScreensRoute,
                                                    arguments: true);
                                          } else {
                                            _toast.showToast(
                                                child: builtToast(
                                                    verdict: toastMessageVerdict
                                                        .Error.toString(),
                                                    mes: _postViewModel
                                                        .message));
                                            setState(() {
                                              _isDataSaving = false;
                                            });
                                          }
                                        }
                                      }
                                    },
                                    child: Text(
                                      'Share',
                                      style: GoogleFonts.nunito(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    )),
                          ),
                        ],
                      )),
                ),
                Expanded(
                    child: Column(
                  children: [
                    if (widget.fileType == FileTypeOption.Image)
                      _isKeyboard
                          ? const SizedBox.shrink()
                          : AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: ColorManager.black,
                                    image: DecorationImage(
                                        image: FileImage(widget.file!))),
                              )),
                    if (widget.fileType == FileTypeOption.Video)
                      _isKeyboard
                          ? const SizedBox.shrink()
                          : FutureBuilder(
                              future: _initializeVideoPlayer,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else {
                                  return AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: Container(
                                      alignment: Alignment.center,
                                      color: ColorManager.black,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          AspectRatio(
                                            aspectRatio: 1 / 1,
                                            child: Container(
                                              color: Colors.black,
                                            ),
                                          ),
                                          AspectRatio(
                                            aspectRatio: _videoPlayerController
                                                .value.aspectRatio,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _isVisible = !_isVisible;
                                                });
                                              },
                                              child: VideoPlayer(
                                                  _videoPlayerController),
                                            ),
                                          ),
                                          Visibility(
                                            visible: _isVisible,
                                            maintainState: true,
                                            maintainAnimation: true,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 30, right: 30),
                                              child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (_videoPlayerController
                                                        .value.isPlaying) {
                                                      _videoPlayerController
                                                          .pause();
                                                    } else {
                                                      _videoPlayerController
                                                          .play();
                                                    }
                                                  });

                                                  if (_videoPlayerController
                                                      .value.isPlaying) {
                                                    Timer(
                                                        const Duration(
                                                            milliseconds: 1000),
                                                        () {
                                                      if (_videoPlayerController
                                                              .value.position !=
                                                          _videoPlayerController
                                                              .value.duration) {
                                                        setState(() {
                                                          _isVisible = false;
                                                        });
                                                      }
                                                    });
                                                  }

                                                  if (!_videoPlayerController
                                                          .value.isPlaying &&
                                                      (_videoPlayerController
                                                              .value.position ==
                                                          _videoPlayerController
                                                              .value
                                                              .duration)) {
                                                    Timer(
                                                        const Duration(
                                                            milliseconds: 1000),
                                                        () {
                                                      setState(() {
                                                        _isVisible = false;
                                                      });
                                                    });
                                                  }
                                                },
                                                icon: Icon(
                                                  _videoPlayerController
                                                          .value.isPlaying
                                                      ? Icons.pause_circle
                                                      : Icons.play_circle,
                                                  color: Colors.white,
                                                  size: 60,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 10,
                                            left: 14,
                                            right: 14,
                                            child: Container(
                                              height: 20,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  ValueListenableBuilder(
                                                      valueListenable:
                                                          _videoPlayerController,
                                                      builder:
                                                          (BuildContext ctx,
                                                              VideoPlayerValue
                                                                  value,
                                                              _) {
                                                        return Text(
                                                          _videoDuration(
                                                              value.position),
                                                          style: GoogleFonts.nunito(
                                                              fontSize: 12,
                                                              color:
                                                                  ColorManager
                                                                      .white),
                                                        );
                                                      }),
                                                  const SizedBox(
                                                    width: 12,
                                                  ),
                                                  Expanded(
                                                      child: SizedBox(
                                                    height: 10,
                                                    child:
                                                        VideoProgressIndicator(
                                                      _videoPlayerController,
                                                      allowScrubbing: true,
                                                    ),
                                                  )),
                                                  const SizedBox(
                                                    width: 12,
                                                  ),
                                                  Text(
                                                    _videoDuration(
                                                        _videoPlayerController
                                                            .value.duration),
                                                    style: GoogleFonts.nunito(
                                                        fontSize: 12,
                                                        color:
                                                            ColorManager.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  bottom: 10,
                                  top: _isKeyboard ? 10 : 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: CircleAvatar(
                                      radius: 26,
                                      backgroundColor:
                                          ColorManager.primeryColor,
                                      child: CircleAvatar(
                                        radius: 24,
                                        child: ClipOval(
                                          child: FancyShimmerImage(
                                              boxDecoration: BoxDecoration(
                                                  shape: BoxShape.circle),
                                              boxFit: BoxFit.cover,
                                              imageUrl:
                                                  logedinUserInfo.imageUrl),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Card(
                                      color: ColorManager.white,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        child: TextField(
                                            minLines: 1,
                                            maxLines: 10,
                                            style: GoogleFonts.nunito(
                                                fontSize: 16,
                                                color: ColorManager.black),
                                            textAlignVertical:
                                                TextAlignVertical.top,
                                            controller:
                                                _captionEditingController,
                                            decoration: InputDecoration(
                                              fillColor: ColorManager.white,
                                              filled: true,
                                              isDense: true,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 0),
                                              hintText: 'Write caption here',
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              hintStyle: GoogleFonts.nunito(
                                                  fontSize: 15,
                                                  color: ColorManager.grey),
                                            )),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 0),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 23,
                                    child: Icon(
                                      IconlyBold.location,
                                      color: Color(0xff0479E0),
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Card(
                                      color: ColorManager.white,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        child: TextField(
                                            minLines: 1,
                                            maxLines: 10,
                                            style: GoogleFonts.nunito(
                                                fontSize: 16,
                                                color: ColorManager.black),
                                            textAlignVertical:
                                                TextAlignVertical.top,
                                            controller: _placeEditingController,
                                            decoration: InputDecoration(
                                              fillColor: ColorManager.white,
                                              filled: true,
                                              isDense: true,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 0),
                                              hintText: 'Where was this taken?',
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              hintStyle: GoogleFonts.nunito(
                                                  fontSize: 15,
                                                  color: ColorManager.grey),
                                            )),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            _isLoading
                                ? const SizedBox(
                                    height: 45,
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  )
                                : SizedBox(
                                    height: 45,
                                    width: getWidth(context: context) * 0.65,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30))),
                                        onPressed: () async {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          bool internetConnection =
                                              await InternetConnectionChecker()
                                                  .hasConnection;
                                          if (!internetConnection) {
                                            _toast.showToast(
                                                child: builtToast(
                                                    verdict: toastMessageVerdict
                                                        .Error.toString(),
                                                    mes:
                                                        'No internet connection'));
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            return;
                                          }

                                          Position position =
                                              await determinePosition();
                                          List<Placemark> placemark =
                                              await GetAddressFromLatLong(
                                                  postion: position);
                                          final Placemark place = placemark[2];
                                          _address =
                                              "${place.street}, ${place.locality}";
                                          _placeEditingController.text =
                                              _address;
                                          setState(() {
                                            FocusScope.of(context).unfocus();
                                            _isLoading = false;
                                          });
                                        },
                                        child: Text(
                                          'Get my current location',
                                          style: GoogleFonts.nunito(
                                              fontSize: 14,
                                              color: ColorManager.white,
                                              fontWeight: FontWeight.w500),
                                        )),
                                  )
                          ],
                        ),
                      ),
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
