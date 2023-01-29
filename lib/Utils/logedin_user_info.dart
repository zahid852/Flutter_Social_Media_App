import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/Models/profile.dart';

import 'package:social_media_app/Utils/user_info.dart';

late userInfo logedinUserInfo;

class UserInfoViewModel {
  Future<void> getData() async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
      final DocumentSnapshot Data = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(currentUserId)
          .get();

      final ProfileModel user = ProfileModel.fromSnapshot(Data);

      logedinUserInfo = userInfo(user: user);
    } on FirebaseException catch (firebaseError) {
      throw firebaseError.message.toString();
    } catch (e) {
      log('error $e');
      throw 'Something went wrong';
    }
  }
}
