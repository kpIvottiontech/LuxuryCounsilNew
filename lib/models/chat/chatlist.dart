import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constance/firestore_constants.dart';

class ChatList {
  String? id;
  String? timestamp;
  String? message;
  String? name;
  String? groupId;
  String? myId;
  String? photoUrl;
  int? unreadCount;

  ChatList({
    this.id,
    this.timestamp,
    this.message,
    this.name,
    this.groupId,
    this.myId,
    this.photoUrl,
    this.unreadCount,

  });

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.id: this.id,
      FirestoreConstants.timeStampChat: this.timestamp,
      FirestoreConstants.message: this.message,
      FirestoreConstants.name: this.name,
      FirestoreConstants.grpid: this.groupId,
      FirestoreConstants.myId: this.myId,
      FirestoreConstants.photoUrl: this.photoUrl,
      FirestoreConstants.unreadCount: this.unreadCount,
    };
  }

  factory ChatList.fromDocument(DocumentSnapshot doc) {
    String id = doc.get(FirestoreConstants.id);
    String timestamp = doc.get(FirestoreConstants.timeStampChat);
    String message = doc.get(FirestoreConstants.message);
    String name = doc.get(FirestoreConstants.name);
    String grpid = doc.get(FirestoreConstants.grpid);
    String photoUrl = doc.get(FirestoreConstants.photoUrl);
    int unreadCount = doc.get(FirestoreConstants.unreadCount);
    return ChatList(id: id,timestamp: timestamp, message: message, name: name,groupId: grpid,photoUrl: photoUrl,unreadCount: unreadCount);
  }
}
