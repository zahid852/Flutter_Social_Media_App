import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/Models/comment.dart';
import 'package:social_media_app/Utils/const.dart';

class PostModel {
  final String? postId;
  final String userId;
  final String username;
  final String userProfileUrl;
  final String fileUrl;
  final String fileType;
  final String caption;
  final String place;
  final DateTime date;
  final List<dynamic> likes;
  final List<dynamic> comments;

  PostModel(
      {this.postId,
      required this.userId,
      required this.username,
      required this.userProfileUrl,
      required this.fileUrl,
      required this.fileType,
      required this.caption,
      required this.place,
      required this.date,
      required this.likes,
      required this.comments});
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'userProfileUrl': userProfileUrl,
      'fileUrl': fileUrl,
      'fileType': fileType,
      'caption': caption,
      'place': place,
      'date': date,
      'likes': likes,
      'comments': comments
    };
  }

  factory PostModel.fromSnapshot(QueryDocumentSnapshot doc) {
    // log('in ${doc['comments']}');
    // final List<dynamic> commentsDate=doc['comments'];
    return PostModel(
        postId: doc.id,
        userId: doc['userId'],
        username: doc['username'],
        userProfileUrl: doc['userProfileUrl'],
        fileUrl: doc['fileUrl'],
        fileType: doc['fileType'],
        caption: doc['caption'],
        place: doc['place'],
        date: doc['date'].toDate(),
        likes: doc['likes'],
        comments: doc['comments']);
  }
}
