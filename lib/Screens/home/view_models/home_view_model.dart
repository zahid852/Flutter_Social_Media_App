import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:ntp/ntp.dart';
import 'package:social_media_app/Models/comment.dart';
import 'package:social_media_app/Models/notification.dart';
import 'package:social_media_app/Models/post.dart';
import 'package:social_media_app/Screens/home/view_models/post_comment_view_state.dart';
import 'package:social_media_app/Screens/home/view_models/post_view_model.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/Utils/logedin_user_info.dart';
import 'package:uuid/uuid.dart';

class homeViewModel {
  String message = Empty;
  final StreamController<List<PostViewModel>> postStreamController =
      StreamController();
  homeViewModel() {
    _subscribeToPostsStream();
  }
  void _subscribeToPostsStream() async {
    try {
      List<String> FollowingUsers = [];
      final yourFollowings = await FirebaseFirestore.instance
          .collection('Follow')
          .where('followers', arrayContains: logedinUserInfo.UserId)
          .get();

      yourFollowings.docs.forEach((element) {
        FollowingUsers.add(element.id);
      });

      FollowingUsers.add(logedinUserInfo.UserId);

      FirebaseFirestore.instance
          .collection('Posts')
          .where('userId', whereIn: FollowingUsers)
          .orderBy('date', descending: true)
          .snapshots()
          .listen((data) {
        if (data.size == 0) {
          postStreamController.sink.add([]);
        } else if (data.size != 0) {
          final List<PostModel> PostsModels =
              data.docs.map((post) => PostModel.fromSnapshot(post)).toList();

          final List<PostViewModel> postViewModels =
              PostsModels.map((postModel) => PostViewModel(post: postModel))
                  .toList();

          postStreamController.sink.add(postViewModels);
        }
      });
    } on FirebaseException catch (firebaseError) {
      throw firebaseError.message.toString();
    } catch (error) {
      throw error.toString();
    }
  }

  Future<bool> addLike(
      {required String postId, required List<dynamic> data}) async {
    bool isDataSaved = false;

    try {
      await FirebaseFirestore.instance
          .collection('Posts')
          .doc(postId)
          .set({'likes': data}, SetOptions(merge: true));
      isDataSaved = true;
    } on FirebaseException catch (firebaseAuthError) {
      message = firebaseAuthError.message.toString();
    } catch (error) {
      message = 'Something went wrong';
    }
    return isDataSaved;
  }

  Future<void> addLikeNotification(
      {required String title,
      required String body,
      required DateTime date,
      required List<dynamic> toId,
      required String byId,
      required String imageUrl}) async {
    try {
      final addLikeNotification = notificationModel(
          title: title,
          body: body,
          date: date,
          toId: toId,
          byId: byId,
          imageUrl: imageUrl);
      await FirebaseFirestore.instance
          .collection('Notifications')
          .add(addLikeNotification.toMap());
    } on FirebaseException catch (firebaseAuthError) {
      message = firebaseAuthError.message.toString();
    } catch (error) {
      message = 'Something went wrong';
    }
  }

  Future<bool> DeletePost({required String postId}) async {
    bool isDataSaved = false;

    try {
      await FirebaseFirestore.instance
          .runTransaction((Transaction myTransaction) async {
        await myTransaction.delete(
            await FirebaseFirestore.instance.collection('Posts').doc(postId));
      });
      isDataSaved = true;
      message = 'Post deleted succesfully';
    } on FirebaseException catch (firebaseAuthError) {
      message = firebaseAuthError.message.toString();
    } catch (error) {
      message = 'Something went wrong';
    }
    return isDataSaved;
  }

  Future<bool> addComment(
      {required String postId,
      required String userId,
      required String username,
      required String message,
      required String imageUrl,
      required List<postCommentViewState> previousComments}) async {
    bool isSaved = false;
    DateTime date = await NTP.now();
    final CommentSetup = postCommentModel(
        userId: userId,
        username: username,
        message: message,
        date: date,
        imageUrl: imageUrl);
    List<dynamic> allComments = [];

    previousComments.forEach((e) {
      final Map<String, dynamic> commentEntry = postCommentModel(
              userId: e.userId,
              username: e.username,
              message: e.message,
              date: e.date,
              imageUrl: e.imageUrl)
          .toMap();

      allComments.add(commentEntry);
    });

    allComments.add(CommentSetup.toMap());

    try {
      await FirebaseFirestore.instance
          .collection('Posts')
          .doc(postId)
          .set({'comments': allComments}, SetOptions(merge: true));

      isSaved = true;
    } on FirebaseException catch (error) {
      message = error.message.toString();
      isSaved = false;
    } catch (e) {
      message = "Something went wrong";
      isSaved = false;
    }
    return isSaved;
  }

  Future<void> commentNotification(
      {required String title,
      required String body,
      required DateTime date,
      required List<dynamic> toId,
      required String byId}) async {
    try {
      final addCommentNotification = notificationModel(
          title: title,
          body: body,
          date: date,
          toId: toId,
          byId: byId,
          imageUrl: logedinUserInfo.imageUrl);
      await FirebaseFirestore.instance
          .collection('Notifications')
          .add(addCommentNotification.toMap());
    } on FirebaseException catch (firebaseAuthError) {
      message = firebaseAuthError.message.toString();
    } catch (error) {
      message = 'Something went wrong';
    }
  }

  Future<bool> DeletePostComment(
      {required String postId,
      required List<postCommentViewState> listComment,
      required postCommentViewState messageToDelete}) async {
    bool isDataSaved = false;
    listComment.removeWhere((element) => element == messageToDelete);

    List<dynamic> allComments = [];
    listComment.forEach((e) {
      final Map<String, dynamic> commentEntry = postCommentModel(
              userId: e.userId,
              username: e.username,
              message: e.message,
              date: e.date,
              imageUrl: e.imageUrl)
          .toMap();

      allComments.add(commentEntry);
    });

    try {
      await FirebaseFirestore.instance
          .collection('Posts')
          .doc(postId)
          .set({'comments': allComments}, SetOptions(merge: true));
      isDataSaved = true;
      message = 'Comment deleted succesfully';
    } on FirebaseException catch (firebaseAuthError) {
      message = firebaseAuthError.message.toString();
    } catch (error) {
      message = 'Something went wrong';
    }
    return isDataSaved;
  }
}
