import 'package:cloud_firestore/cloud_firestore.dart';

class postCommentModel {
  final String userId;
  final String username;
  final String message;
  final DateTime date;
  final String imageUrl;

  postCommentModel({
    required this.userId,
    required this.username,
    required this.message,
    required this.date,
    required this.imageUrl,
  });
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'message': message,
      'date': date,
      'imageUrl': imageUrl
    };
  }
}
