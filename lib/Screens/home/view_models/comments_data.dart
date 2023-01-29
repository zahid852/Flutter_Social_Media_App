import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:social_media_app/Screens/home/view_models/post_comment_view_state.dart';
import 'package:social_media_app/Utils/const.dart';

class commentsData extends ChangeNotifier {
  List<postCommentViewState> commentList = [];
  String postId = Empty;

  void setComments(
      {required List<postCommentViewState> data, required String post_Id}) {
    if (postId == post_Id) {
      commentList = data;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void setInitialComments(
      {required List<postCommentViewState> data, required String post_Id}) {
    commentList = data;
    postId = post_Id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
