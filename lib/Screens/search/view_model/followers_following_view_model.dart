import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/Screens/search/view_model/search_profile_model_viewstate.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/Utils/logedin_user_info.dart';

class FollowersFollowingViewModel {
  String message = Empty;
  final StreamController<int> followerStreamController = StreamController();
  final StreamController<int> followingStreamController = StreamController();
  FollowersFollowingViewModel({
    required String id,
  }) {
    getFollowers(userId: id);
    getFollowings(userId: id);
  }

  Future<void> getFollowers({required String userId}) async {
    try {
      await FirebaseFirestore.instance
          .collection('Follow')
          .doc(userId)
          .snapshots()
          .listen((data) {
        if (data.exists) {
          List<dynamic> followers = data['followers'];
          followerStreamController.sink.add(followers.length);
        } else {
          followerStreamController.sink.add(0);
        }
      });
    } on FirebaseException catch (error) {
      message = error.message.toString();
    } catch (error) {
      message = 'Something went wrong';
    }
  }

  Future<void> getFollowings({required String userId}) async {
    try {
      await FirebaseFirestore.instance
          .collection('Follow')
          .where('followers', arrayContains: userId)
          .snapshots()
          .listen((data) {
        if (data.docs.isNotEmpty) {
          int followings = data.docs.length;
          followingStreamController.sink.add(followings);
        } else {
          followingStreamController.sink.add(0);
        }
      });
    } on FirebaseException catch (error) {
      message = error.message.toString();
    } catch (error) {
      message = 'Something went wrong';
    }
  }
}
