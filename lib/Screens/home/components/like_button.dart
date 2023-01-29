import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/Screens/home/view_models/home_view_model.dart';
import 'package:http/http.dart' as http;
import 'package:social_media_app/Theme/theme_provider.dart';
import 'package:social_media_app/Utils/const.dart';

import '../../../Utils/logedin_user_info.dart';

class likeButton extends StatefulWidget {
  final String postId;
  final String userId;
  final List<dynamic> likes;
  final String idOfPostUser;
  final String username;

  likeButton({
    required this.postId,
    required this.userId,
    required this.likes,
    required this.idOfPostUser,
    required this.username,
  });

  @override
  State<likeButton> createState() => _likeButtonState();
}

class _likeButtonState extends State<likeButton> {
  homeViewModel _homeViewModel = homeViewModel();
  bool previousStatus = false;
  @override
  void initState() {
    previousStatus = widget.likes.contains(widget.userId);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isFavorite = widget.likes.contains(widget.userId);

    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 2),
      child: Row(
        children: [
          widget.likes.isEmpty
              ? SizedBox.shrink()
              : Text(
                  widget.likes.length.toString(),
                  style: GoogleFonts.nunito(
                      fontSize: 17, fontWeight: FontWeight.w500),
                ),
          IconButton(onPressed: () async {
            if (widget.likes.contains(widget.userId)) {
              widget.likes.remove(widget.userId);
              isFavorite = false;
            } else {
              widget.likes.add(widget.userId);
              isFavorite = true;
            }
            setState(() {});
            final result = await _homeViewModel.addLike(
                postId: widget.postId, data: widget.likes);
            if (result &&
                widget.idOfPostUser != logedinUserInfo.UserId &&
                isFavorite) {
              final date = await NTP.now();
              await _homeViewModel.addLikeNotification(
                  title: widget.username,
                  body: '${logedinUserInfo.Username} liked your post',
                  date: date,
                  toId: [widget.idOfPostUser],
                  byId: widget.userId,
                  imageUrl: logedinUserInfo.imageUrl);
              final UsersToken = await FirebaseFirestore.instance
                  .collection('UserTokens')
                  .doc(widget.idOfPostUser)
                  .get();

              String token = Empty;

              token = UsersToken['token'];

              sendPushMessage(
                  token: token,
                  title: widget.username,
                  body: '${logedinUserInfo.Username} liked your post');
            } else if (!result) {
              if (previousStatus) {
                widget.likes.add(widget.userId);
                isFavorite = true;
              } else {
                widget.likes.remove(widget.userId);
                isFavorite = false;
              }
              setState(() {});
            }
          }, icon: Consumer<ThemeProvider>(builder: (ctx, provider, _) {
            return Icon(
              isFavorite ? Icons.favorite : Icons.favorite_outline,
              size: 30,
              color: isFavorite
                  ? Colors.red
                  : provider.IsThemeStatusBlack
                      ? Colors.white
                      : Colors.black,
            );
          })),
        ],
      ),
    );
  }

  void sendPushMessage({
    required String token,
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
            'type': 'like'
          },
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
            'android_channel_id': 'social_media_app'
          },
          'to': token
        }));
  }
}
