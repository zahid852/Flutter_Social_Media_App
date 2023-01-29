import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ntp/ntp.dart';
import 'package:social_media_app/Models/notification.dart';
import 'package:social_media_app/Models/post.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:social_media_app/Utils/logedin_user_info.dart';
import 'package:social_media_app/Utils/user_info.dart';
import 'package:uuid/uuid.dart';

class sharePostViewModel {
  String message = Empty;
  Future<bool> sharePost(
      {required File file,
      required FileTypeOption fileType,
      required String caption,
      required String address}) async {
    bool isDataSaved = false;
    String downloadUrl = Empty;
    try {
      final uuid = Uuid();
      final imagePath = "/posts/${uuid.v4()}";
      final storage = FirebaseStorage.instance.ref(imagePath);

      TaskSnapshot uploadTask = await storage.putFile(file);
      if (uploadTask.state == TaskState.success) {
        downloadUrl = await storage.getDownloadURL();

        final DateTime currentDate = await NTP.now();
        final post = PostModel(
            userId: logedinUserInfo.UserId,
            username: logedinUserInfo.Username,
            userProfileUrl: logedinUserInfo.imageUrl,
            fileUrl: downloadUrl,
            fileType: fileType.toString(),
            caption: caption,
            place: address,
            date: currentDate,
            likes: [],
            comments: []);

        await FirebaseFirestore.instance.collection('Posts').add(post.toMap());
        isDataSaved = true;
      }
    } on FirebaseException catch (firebaseAuthError) {
      message = firebaseAuthError.message.toString();
    } catch (error) {
      message = 'Something went wrong';
    }
    return isDataSaved;
  }

  Future<void> postNotification(
      {required String title,
      required String body,
      required DateTime date,
      required List<dynamic> toId,
      required String byId}) async {
    try {
      final addPostNotification = notificationModel(
          title: title,
          body: body,
          date: date,
          toId: toId,
          byId: byId,
          imageUrl: logedinUserInfo.imageUrl);
      await FirebaseFirestore.instance
          .collection('Notifications')
          .add(addPostNotification.toMap());
    } on FirebaseException catch (firebaseAuthError) {
      message = firebaseAuthError.message.toString();
    } catch (error) {
      message = 'Something went wrong';
    }
  }
}
