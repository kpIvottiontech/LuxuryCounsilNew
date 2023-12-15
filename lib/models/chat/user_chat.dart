import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constance/firestore_constants.dart';

class UserChat {
  String? id;
  String? timeStampChat;
  String? message;
  String? name;
  String? groupId;
  String? photoUrl;
  String? oppId;
  int? unreadCount;
  UserChat({this.id,this.timeStampChat,this.message, this.name,this.groupId,this.photoUrl,this.oppId,this.unreadCount});

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.id: id ??'',
      FirestoreConstants.timeStampChat: timeStampChat ?? '',
      FirestoreConstants.message: message ??'',
      FirestoreConstants.nickname: name?? '',
      FirestoreConstants.grpid: groupId?? '',
      FirestoreConstants.photoUrl:photoUrl ?? '',
      FirestoreConstants.oppId: oppId ?? '',
      FirestoreConstants.unreadCount: unreadCount ?? 0
    };
  }

  factory UserChat.fromDocument(DocumentSnapshot doc) {
    String aboutMe = "";
    String nickname = "";
    String id = "";
    String timeStampChat = "";
    String message = "";
    String grpid = "";
    String oppId = "";
    String photoUrl = "";
    int unreadCount = 0;

    try {
      id = doc.get(FirestoreConstants.id);
    } catch (e) {}
    try {
      message = doc.get(FirestoreConstants.message);
    } catch (e) {}
    try {
      timeStampChat = doc.get(FirestoreConstants.timeStampChat);
    } catch (e) {}
    try {
      nickname = doc.get(FirestoreConstants.nickname);
    } catch (e) {}
    try {
      grpid = doc.get(FirestoreConstants.grpid);
    } catch (e) {}
    try {
      photoUrl = doc.get(FirestoreConstants.photoUrl);
    } catch (e) {}
    try {
      oppId = doc.get(FirestoreConstants.oppId);
    } catch (e) {}
    try {
      unreadCount = doc.get(FirestoreConstants.unreadCount);
    } catch (e) {}
    return UserChat(
      id: doc.id,
      timeStampChat: timeStampChat,
      message: message,
      name: nickname,
      groupId: grpid,
      photoUrl: photoUrl,
      oppId: oppId,
      unreadCount: unreadCount,
    );
  }
}
