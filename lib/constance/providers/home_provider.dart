import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luxury_council/constance/global_data.dart';

import '../firestore_constants.dart';

class HomeProvider {
  final FirebaseFirestore? firebaseFirestore;

  HomeProvider({this.firebaseFirestore});

  Future<void>? updateDataFirestore(
      String collectionPath, String path, Map<String, String> dataNeedUpdate) {
    return firebaseFirestore
        ?.collection(collectionPath)
        .doc(path)
        .update(dataNeedUpdate);
  }

  Stream<QuerySnapshot>? getChatList(int limit, String textSearch) {

    return firebaseFirestore?.collection(FirestoreConstants.chatList)
        .doc(GlobalData().userId.toString())
        .collection(GlobalData().userId.toString())
        .limit(limit)
        .orderBy(FirestoreConstants.timeStampChat, descending: true)
        .snapshots();

  }


}
