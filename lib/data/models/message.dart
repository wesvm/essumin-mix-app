import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  String content;
  String userId;
  Timestamp timestamp;

  Message({
    required this.id,
    required this.content,
    required this.userId,
    required this.timestamp,
  });
}
