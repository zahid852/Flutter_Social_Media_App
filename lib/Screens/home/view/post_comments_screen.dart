import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/Resources/color_manager.dart';
import 'package:social_media_app/Screens/home/view_models/comments_data.dart';
import 'package:social_media_app/Screens/home/view_models/home_view_model.dart';
import 'package:social_media_app/Screens/home/view_models/post_comment_view_state.dart';
import 'package:social_media_app/Theme/theme_provider.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/Utils/logedin_user_info.dart';
import 'package:social_media_app/Utils/utils.dart';
import 'package:http/http.dart' as http;
import '../../../resources/asset_manager.dart';

class postCommentsScreen extends StatefulWidget {
  final homeViewModel viewModel;
  final String postId;
  final String nameOfPostUser;
  final idOfPostUser;
  postCommentsScreen(
      {required this.viewModel,
      required this.postId,
      required this.nameOfPostUser,
      required this.idOfPostUser});

  @override
  State<postCommentsScreen> createState() => _postCommentsScreenState();
}

class _postCommentsScreenState extends State<postCommentsScreen> {
  TextEditingController _messageEditingController = TextEditingController();
  final _toast = FToast();
  final _scrollController = ScrollController();

  @override
  void initState() {
    _toast.init(context);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _scrollToBottom() {
    Timer(Duration(milliseconds: 0), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
    });
  }

  Widget commentListWidget(
      commentsData commentsDataObject, ThemeProvider provider) {
    _scrollToBottom();
    return ListView.builder(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        itemCount: commentsDataObject.commentList.length,
        itemBuilder: (ctx, index) {
          final postCommentViewState message =
              commentsDataObject.commentList[index];
          return Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: message.userId == logedinUserInfo.UserId
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (message.userId == logedinUserInfo.UserId)
                FocusedMenuHolder(
                  onPressed: () {},
                  menuBoxDecoration: BoxDecoration(),
                  blurSize: 1.5,
                  menuWidth: getWidth(context: context) * 0.4,
                  menuItems: [
                    FocusedMenuItem(
                        title: Text(
                          'Delete',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w400),
                        ),
                        trailingIcon: Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),
                        onPressed: () async {
                          bool result = await widget.viewModel
                              .DeletePostComment(
                                  postId: widget.postId,
                                  listComment: commentsDataObject.commentList,
                                  messageToDelete: message);
                          if (result) {
                            _toast.showToast(
                                child: builtToast(
                                    verdict: toastMessageVerdict.WithoutError
                                        .toString(),
                                    mes: widget.viewModel.message));
                          } else {
                            _toast.showToast(
                                child: builtToast(
                                    verdict:
                                        toastMessageVerdict.Error.toString(),
                                    mes: widget.viewModel.message));
                          }
                        })
                  ],
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: getWidth(context: context) * 0.7,
                        minWidth: getWidth(context: context) * 0.3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: !provider.IsThemeStatusBlack
                            ? ColorManager.primeryColor.withOpacity(0.2)
                            : ColorManager.primeryColor),
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message.username,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          message.message,
                          style: GoogleFonts.nunito(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 7.5,
                        ),
                        Text(
                          DateFormat('dd/MM/yy hh:mm a').format(message.date),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: provider.IsThemeStatusBlack
                                  ? Colors.white70
                                  : Colors.black54,
                              fontSize: 11),
                        )
                      ],
                    ),
                  ),
                ),
              if (message.userId != logedinUserInfo.UserId)
                Container(
                  constraints: BoxConstraints(
                      maxWidth: getWidth(context: context) * 0.7,
                      minWidth: getWidth(context: context) * 0.3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: provider.IsThemeStatusBlack
                          ? Colors.grey[600]
                          : ColorManager.grey.withOpacity(0.2)),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message.username,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        message.message,
                        style: GoogleFonts.nunito(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 7.5,
                      ),
                      Text(
                        DateFormat('dd/MM/yy hh:mm a').format(message.date),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: provider.IsThemeStatusBlack
                                ? Colors.white70
                                : Colors.black54,
                            fontSize: 11),
                      )
                    ],
                  ),
                ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final commentsDataObject = Provider.of<commentsData>(context);

    return SafeArea(
      child: Consumer<ThemeProvider>(builder: (ctx, provider, _) {
        return Scaffold(
            backgroundColor:
                provider.IsThemeStatusBlack ? Colors.grey[900] : Colors.white,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Column(children: [
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
                            left: 14,
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
                            'Comments',
                            style: GoogleFonts.akayaTelivigala(
                                color: ColorManager.primeryColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: commentsDataObject.commentList.isEmpty
                            ? MediaQuery.of(context).viewInsets.bottom != 0
                                ? SizedBox.shrink()
                                : Center(
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 90),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height:
                                                getHeight(context: context) *
                                                    0.32,
                                            width: getWidth(context: context) *
                                                0.6,
                                            child: Lottie.asset(
                                                LottieAssets.empty),
                                          ),
                                          Container(
                                            width: getWidth(context: context) *
                                                0.7,
                                            alignment: Alignment.center,
                                            child: Text(
                                              "No Comments here",
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
                                  )
                            : commentListWidget(commentsDataObject, provider)),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 10, left: 20, right: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: TextField(
                                style: GoogleFonts.nunito(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                                minLines: 1,
                                controller: _messageEditingController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(
                                          color: ColorManager.primeryColor)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                          BorderSide(color: ColorManager.grey)),
                                  hintText: 'Enter text',
                                  hintStyle: GoogleFonts.nunito(
                                      color: ColorManager.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                maxLines: 5,
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                if (_messageEditingController.text.isNotEmpty) {
                                  final String mes =
                                      _messageEditingController.text;
                                  _messageEditingController.clear();
                                  final result = await widget.viewModel
                                      .addComment(
                                          postId: widget.postId,
                                          userId: logedinUserInfo.UserId,
                                          username: logedinUserInfo.Username,
                                          message: mes,
                                          imageUrl: logedinUserInfo.imageUrl,
                                          previousComments:
                                              commentsDataObject.commentList);
                                  if (result) {
                                    final date = await NTP.now();
                                    final snap = await FirebaseFirestore
                                        .instance
                                        .collection('Follow')
                                        .doc(widget.idOfPostUser)
                                        .get();
                                    List<dynamic> allFollowers =
                                        snap['followers'];
                                    allFollowers.add(widget.idOfPostUser);

                                    final allUsersTokens =
                                        await FirebaseFirestore.instance
                                            .collection('UserTokens')
                                            .get();

                                    List<String> val = [];

                                    allUsersTokens.docs.forEach((element) {
                                      if (allFollowers.contains(element.id)) {
                                        if (element.id !=
                                            logedinUserInfo.UserId) {
                                          val.add(element['token']);
                                        }
                                      }
                                    });
                                    final List<dynamic> toIds = [];

                                    allFollowers.forEach((element) {
                                      if (element != logedinUserInfo.UserId) {
                                        toIds.add(element);
                                      }
                                    });
                                    await widget.viewModel.commentNotification(
                                        title:
                                            "${logedinUserInfo.Username} commented on ${widget.idOfPostUser == logedinUserInfo.UserId ? 'his' : "${widget.nameOfPostUser}'s"} post",
                                        body: mes,
                                        date: date,
                                        toId: toIds,
                                        byId: logedinUserInfo.UserId);
                                    sendPushMessage(
                                        token: val,
                                        title: logedinUserInfo.Username,
                                        body: mes);
                                  } else if (!result) {
                                    _toast.showToast(
                                        child: builtToast(
                                            verdict: toastMessageVerdict.Error
                                                .toString(),
                                            mes: widget.viewModel.message));
                                  }
                                }
                              },
                              icon: Icon(
                                Icons.send,
                                color: ColorManager.primeryColor,
                              ))
                        ],
                      ),
                    ),
                  ])),
            ));
      }),
    );
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
            'body': '${widget.postId}',
            'title': title,
            'type': 'chat'
          },
          'notification': <String, dynamic>{
            'title': title,
            'body': body,
            'android_channel_id': 'social_media_app'
          },
          'registration_ids': token
        }));
  }
}
