import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ntp/ntp.dart';
import 'package:social_media_app/Models/comment.dart';
import 'package:social_media_app/Models/post.dart';
import 'package:social_media_app/Screens/home/view_models/post_comment_view_state.dart';
import 'package:social_media_app/Screens/home/view_models/post_view_model.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/Utils/logedin_user_info.dart';

class NotificationClickMessageViewModel {
  String message = Empty;
  final StreamController<List<postCommentViewState>> MessagesStreamController =
      StreamController();
  NotificationClickMessageViewModel({required String postId}) {
    _subscribeToPostMessageStream(postId: postId);
  }
  void _subscribeToPostMessageStream({required String postId}) async {
    try {
      FirebaseFirestore.instance
          .collection('Posts')
          .doc(postId)
          .snapshots()
          .listen((data) {
        if (data.exists) {
          if (data['comments'] == []) {
            MessagesStreamController.sink.add([]);
          } else {
            final List<dynamic> commentMaps = data['comments'];

            final List<postCommentViewState> postComments = commentMaps
                .map((messageMap) =>
                    postCommentViewState.fromSnapshot(messageMap))
                .toList();

            MessagesStreamController.sink.add(postComments);
          }
        } else {
          MessagesStreamController.sink.add([]);
        }
      });
    } on FirebaseException catch (firebaseError) {
      throw firebaseError.message.toString();
    } catch (error) {
      throw error.toString();
    }
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
