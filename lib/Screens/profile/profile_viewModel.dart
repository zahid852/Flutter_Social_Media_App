import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media_app/Models/profile.dart';
import 'package:social_media_app/Utils/const.dart';
import 'package:uuid/uuid.dart';

class ProfileViewModel {
  String message = Empty;

  Future<String> uploadFile(File imageFile) async {
    String downloadUrl = Empty;

    final uuid = Uuid();
    final imagePath = "/images/${uuid.v4()}.jpg";
    final storage = FirebaseStorage.instance.ref(imagePath);
    try {
      TaskSnapshot uploadTask = await storage.putFile(imageFile);
      if (uploadTask.state == TaskState.success) {
        downloadUrl = await storage.getDownloadURL();
      }
    } on FirebaseException catch (error) {
      message = error.message.toString();
    } catch (error) {
      message = 'Something went wrong';
    }
    return downloadUrl;
  }

  Future<bool> saveProfile(
      {required String name,
      required String about,
      required String date,
      required String imageUrl}) async {
    bool isSaved = false;
    final profileSetup =
        ProfileModel(name: name, about: about, date: date, imageUrl: imageUrl);
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(userId)
          .set(profileSetup.toMap());

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
}
