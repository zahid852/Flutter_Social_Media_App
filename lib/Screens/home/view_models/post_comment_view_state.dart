import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class postCommentViewState {
  final String userId;
  final String username;
  final String message;
  final DateTime date;
  final String imageUrl;

  postCommentViewState({
    required this.userId,
    required this.username,
    required this.message,
    required this.date,
    required this.imageUrl,
  });

  factory postCommentViewState.fromSnapshot(Map<String, dynamic> doc) {
    return postCommentViewState(
      userId: doc['userId'],
      username: doc['username'],
      message: doc['message'],
      date: doc['date'].toDate(),
      imageUrl: doc['imageUrl'],
    );
  }
}
