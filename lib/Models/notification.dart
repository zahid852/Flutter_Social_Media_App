import 'package:cloud_firestore/cloud_firestore.dart';

class notificationModel {
  final String? id;
  final String title;
  final String body;
  final DateTime date;
  final List<dynamic> toId;
  final String byId;
  final String imageUrl;
  notificationModel(
      {this.id,
      required this.title,
      required this.body,
      required this.date,
      required this.toId,
      required this.byId,
      required this.imageUrl});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'date': date,
      'toId': toId,
      'byId': byId,
      'imageUrl': imageUrl
    };
  }

  factory notificationModel.fromSnapshot(QueryDocumentSnapshot doc) {
    return notificationModel(
        id: doc.id,
        title: doc['title'],
        body: doc['body'],
        date: doc['date'].toDate(),
        toId: doc['toId'],
        byId: doc['byId'],
        imageUrl: doc['imageUrl']);
  }
}
