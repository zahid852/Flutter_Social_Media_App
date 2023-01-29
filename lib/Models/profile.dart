import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  final String? profileId;
  final String username;
  final String usernameForQuery;
  final String email;
  final String name;
  final String about;
  final String date;
  final String imageUrl;
  ProfileModel(
      {this.profileId,
      required this.username,
      required this.usernameForQuery,
      required this.email,
      required this.name,
      required this.about,
      required this.date,
      required this.imageUrl});
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'usernameForQuery': usernameForQuery,
      'email': email,
      'name': name,
      'about': about,
      'date': date,
      'imageUrl': imageUrl
    };
  }

  factory ProfileModel.fromSnapshot(DocumentSnapshot doc) {
    return ProfileModel(
      profileId: doc.id,
      username: doc['username'],
      usernameForQuery: doc['usernameForQuery'],
      email: doc['email'],
      name: doc['name'],
      about: doc['about'],
      date: doc['date'],
      imageUrl: doc['imageUrl'],
    );
  }
}
