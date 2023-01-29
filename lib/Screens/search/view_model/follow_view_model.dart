import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_media_app/Screens/auth/components/login_form_widget.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/Utils/logedin_user_info.dart';

import '../../../Models/notification.dart';

class FollowersViewModel with ChangeNotifier {
  String message = Empty;
  bool isFollow = false;
  int posts = 0;
  List<dynamic> allUsers = [];
  Future<void> getFollowers({
    required String userId,
  }) async {
    try {
      allUsers = [];
      isFollow = false;

      final data = await FirebaseFirestore.instance
          .collection('Follow')
          .doc(userId)
          .get();
      if (data.exists) {
        allUsers = data['followers'];

        if (allUsers.contains(logedinUserInfo.UserId)) {
          isFollow = true;
        }
      }
    } on FirebaseException catch (error) {
      message = error.message.toString();
    } catch (e) {
      message = "Something went wrong";
    }
    notifyListeners();
  }

  Future<void> FollowUser({
    required String userId,
  }) async {
    try {
      allUsers.add(logedinUserInfo.UserId);
      final data = await FirebaseFirestore.instance
          .collection('Follow')
          .doc(userId)
          .set({'followers': allUsers}, SetOptions(merge: true));
      isFollow = true;
    } on FirebaseException catch (error) {
      message = error.message.toString();
      isFollow = false;
    } catch (e) {
      message = "Something went wrong";
      isFollow = false;
    }
    notifyListeners();
  }

  Future<void> FollowNotification(
      {required String title,
      required String body,
      required DateTime date,
      required List<dynamic> toId,
      required String byId}) async {
    try {
      final addLikeNotification = notificationModel(
          title: title,
          body: body,
          date: date,
          toId: toId,
          byId: byId,
          imageUrl: logedinUserInfo.imageUrl);
      await FirebaseFirestore.instance
          .collection('Notifications')
          .add(addLikeNotification.toMap());
    } on FirebaseException catch (firebaseAuthError) {
      message = firebaseAuthError.message.toString();
    } catch (error) {
      message = 'Something went wrong';
    }
  }

  Future<void> UnfollowUser({
    required String userId,
  }) async {
    try {
      allUsers.remove(logedinUserInfo.UserId);
      final data = await FirebaseFirestore.instance
          .collection('Follow')
          .doc(userId)
          .set({'followers': allUsers}, SetOptions(merge: true));

      isFollow = false;
    } on FirebaseException catch (error) {
      message = error.message.toString();
      isFollow = true;
    } catch (e) {
      message = "Something went wrong";
      isFollow = true;
    }
    notifyListeners();
  }

  Future<void> getPostsLength({required String userId}) async {
    posts = 0;
    try {
      final data = await FirebaseFirestore.instance
          .collection('Posts')
          .where('userId', isEqualTo: userId)
          .get();

      posts = data.docs.length;
    } on FirebaseException catch (error) {
      message = error.message.toString();
    } catch (error) {
      message = 'Something went wrong';
    }
    notifyListeners();
  }
}
