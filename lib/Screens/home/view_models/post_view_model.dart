import 'dart:developer';

import 'package:social_media_app/Models/comment.dart';
import 'package:social_media_app/Models/post.dart';
import 'package:social_media_app/Screens/home/view_models/post_comment_view_state.dart';
import 'package:social_media_app/Utils/const.dart';

class PostViewModel {
  final PostModel post;
  PostViewModel({required this.post});

  String get username {
    return post.username;
  }

  List get likes {
    return post.likes;
  }

  List<postCommentViewState> get comments {
    if (post.comments.isEmpty) {
      return [];
    } else {
      final List<postCommentViewState> commentList = post.comments
          .map((e) => postCommentViewState.fromSnapshot(e))
          .toList();
      return commentList;
    }
  }

  String get userId {
    return post.userId;
  }

  String get postId {
    return post.postId!;
  }

  String get userImageUrl {
    return post.userProfileUrl;
  }

  String get file {
    return post.fileUrl;
  }

  String get caption {
    return post.caption;
  }

  String get place {
    return post.place;
  }

  String get fileType {
    return post.fileType;
  }

  DateTime get date {
    return post.date;
  }
}
