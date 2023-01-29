import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/Models/notification.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/Utils/logedin_user_info.dart';

class NotificationViewModel {
  final StreamController<List<notificationModel>> NotificationStreamController =
      StreamController();
  NotificationViewModel() {
    _subscribeToNotificationStream();
  }

  void _subscribeToNotificationStream() async {
    try {
      FirebaseFirestore.instance
          .collection('Notifications')
          .where('toId', arrayContains: logedinUserInfo.UserId)
          .orderBy('date', descending: true)
          .snapshots()
          .listen((data) {
        if (data.size == 0) {
          NotificationStreamController.sink.add([]);
        } else if (data.size != 0) {
          log('ho ${data.docs}');
          final List<notificationModel> Notifications = data.docs
              .map((post) => notificationModel.fromSnapshot(post))
              .toList();

          NotificationStreamController.sink.add(Notifications);
        }
      });
    } on FirebaseException catch (firebaseError) {
      throw firebaseError.message.toString();
    } catch (error) {
      throw error.toString();
    }
  }
}
