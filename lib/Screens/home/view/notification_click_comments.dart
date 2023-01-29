import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:social_media_app/Resources/asset_manager.dart';
import 'package:social_media_app/Resources/color_manager.dart';
import 'package:social_media_app/Resources/routes_manager.dart';
import 'package:social_media_app/Screens/home/view_models/notification_click_message_view_model.dart';
import 'package:social_media_app/Screens/home/view_models/post_comment_view_state.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/Utils/logedin_user_info.dart';
import 'package:social_media_app/Utils/utils.dart';
import 'package:http/http.dart' as http;

class notificationClickMessageScreen extends StatefulWidget {
  final String postId;

  notificationClickMessageScreen({required this.postId});
  @override
  State<notificationClickMessageScreen> createState() =>
      _notificationClickMessageScreenState();
}

class _notificationClickMessageScreenState
    extends State<notificationClickMessageScreen> {
  TextEditingController _messageEditingController = TextEditingController();
  List<postCommentViewState> prevComments = [];
  final _toast = FToast();
  final _scrollController = ScrollController();
  late NotificationClickMessageViewModel _notificationClickMessageViewModel;
  @override
  void initState() {
    _notificationClickMessageViewModel =
        NotificationClickMessageViewModel(postId: widget.postId);
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

  Widget commentListWidget(List<postCommentViewState> commentsDataObject) {
    _scrollToBottom();
    return ListView.builder(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        itemCount: commentsDataObject.length,
        itemBuilder: (ctx, index) {
          final postCommentViewState message = commentsDataObject[index];
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
                        title: Text('Delete'),
                        trailingIcon: Icon(Icons.delete),
                        onPressed: () async {
                          bool result = await _notificationClickMessageViewModel
                              .DeletePostComment(
                                  postId: widget.postId,
                                  listComment: commentsDataObject,
                                  messageToDelete: message);
                          if (result) {
                            _toast.showToast(
                                child: builtToast(
                                    verdict: toastMessageVerdict.WithoutError
                                        .toString(),
                                    mes: _notificationClickMessageViewModel
                                        .message));
                          } else {
                            _toast.showToast(
                                child: builtToast(
                                    verdict:
                                        toastMessageVerdict.Error.toString(),
                                    mes: _notificationClickMessageViewModel
                                        .message));
                          }
                        })
                  ],
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: getWidth(context: context) * 0.7,
                        minWidth: getWidth(context: context) * 0.3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: ColorManager.primeryColor.withOpacity(0.2)),
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
                              color: ColorManager.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 7.5,
                        ),
                        Text(
                          DateFormat('dd/MM/yy hh:mm a').format(message.date),
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.black54, fontSize: 11),
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
                      color: ColorManager.grey.withOpacity(0.2)),
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
                            color: ColorManager.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 7.5,
                      ),
                      Text(
                        DateFormat('dd/MM/yy hh:mm a').format(message.date),
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.black54, fontSize: 11),
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
    return SafeArea(
      child: Scaffold(
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
                            Navigator.of(context)
                                .pushReplacementNamed(routes.mainScreensRoute);
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
                  child: StreamBuilder<List<postCommentViewState>>(
                stream: _notificationClickMessageViewModel
                    .MessagesStreamController.stream,
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return MediaQuery.of(context).viewInsets.bottom != 0
                        ? SizedBox.shrink()
                        : Center(
                            child: Container(
                              padding: EdgeInsets.only(bottom: 90),
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
                          );
                  } else {
                    prevComments = snapshot.data ?? [];
                    return commentListWidget(snapshot.data ?? []);
                  }
                },
              )),
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
                            final String mes = _messageEditingController.text;
                            _messageEditingController.clear();
                            final result =
                                await _notificationClickMessageViewModel
                                    .addComment(
                                        postId: widget.postId,
                                        userId: logedinUserInfo.UserId,
                                        username: logedinUserInfo.Username,
                                        message: mes,
                                        imageUrl: logedinUserInfo.imageUrl,
                                        previousComments: prevComments);
                            if (result) {
                              final data = await FirebaseFirestore.instance
                                  .collection('Posts')
                                  .doc(widget.postId)
                                  .get();

                              final snap = await FirebaseFirestore.instance
                                  .collection('Follow')
                                  .doc(data['userId'])
                                  .get();
                              List<dynamic> allFollowers = snap['followers'];
                              allFollowers.add(data['userId']);

                              final allUsersTokens = await FirebaseFirestore
                                  .instance
                                  .collection('UserTokens')
                                  .get();

                              List<String> val = [];
                              allUsersTokens.docs.forEach((element) {
                                if (allFollowers.contains(element.id)) {
                                  if (element.id != logedinUserInfo.UserId) {
                                    val.add(element['token']);
                                  }
                                }
                              });

                              sendPushMessage(
                                  token: val,
                                  title: logedinUserInfo.Username,
                                  body: mes);
                            } else if (!result) {
                              _toast.showToast(
                                  child: builtToast(
                                      verdict:
                                          toastMessageVerdict.Error.toString(),
                                      mes: _notificationClickMessageViewModel
                                          .message));
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
      )),
    );
  }

  void sendPushMessage(
      {required List<String> token,
      required String title,
      required String body}) async {
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
            'body': widget.postId,
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
