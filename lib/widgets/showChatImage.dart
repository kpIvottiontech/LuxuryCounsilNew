import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_council/api_config/api_services.dart';
import 'package:luxury_council/api_config/urls.dart';
import 'package:luxury_council/constance/firestore_constants.dart';
import 'package:luxury_council/controllers/chat_controller.dart';
import 'package:luxury_council/models/chat/user_chat.dart';
import 'package:luxury_council/models/recent_chat_model.dart';

import '../config/colors.dart';

class ShowChatImage extends StatefulWidget {
  UserChat? userChat;
  ShowChatImage({
    super.key,
    this.userChat,
  });

  @override
  State<ShowChatImage> createState() => ShowChatImageState();
}

class ShowChatImageState extends State<ShowChatImage> {
  String image = '';
  String username = '';
  final ChatController chatController = Get.put(ChatController());
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    print('>>>>>>>${widget.userChat!.id}');
    getApi(widget.userChat!.id!);
    super.initState();

  }

  getApi(String id) async {
    await getRecentChat(context, id);
  }

  getRecentChat(BuildContext context, String userId) async {
    await POST_API({
      "app_user_id": userId,
    }, Urls.recentChat, context)
        .then((response) {
      Map<String, dynamic> chatResponse = jsonDecode(response);
      if (chatResponse["data"].isEmpty) {
      } else {
        if (chatResponse['status'] != true) {
        } else {
          RecentChatModel recentChatModel =
              RecentChatModel.fromJson(jsonDecode(response));
          setState(() {
            image = recentChatModel.data![0].profileImgUrl!;
            username = recentChatModel.data![0].firstName!+' '+recentChatModel.data![0].lastName!;
          });
        }
      }
    }, onError: (e) {
      print('========================${e.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 1500), () {
      getApi(widget.userChat!.id!);
    });
    return GetBuilder<ChatController>(
        id: 'chat',
        init: ChatController(),
        builder: (chat) {
          return GestureDetector(
            onTap: () {
              print('${widget.userChat!.id.toString()}>>>>>> ${username} ');
              Get.offAndToNamed("/ChatDetails", arguments: [
                widget.userChat!.id.toString(),
                '',
                username
              ],parameters: {
                "key": "",
              }
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: AppColor.loginappbar,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        flex: 3,
                        child:  Row(
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(500),
                                  child: Container(
                                    height: MediaQuery.of(context).size.width / 6.35,
                                    width: MediaQuery.of(context).size.width / 6.35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColor.white,
                                    ),
                                    child: image.isNotEmpty
                                        ? image != null && image != ''
                                        ? Image.network(
                                      image,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context, Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes !=
                                                  null
                                                  ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                                  loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        }
                                      },
                                    )
                                        : Image.asset(
                                      'assets/ic_user_placeholder.jpeg',
                                      fit: BoxFit.cover,
                                      //scale: 2.9,
                                    )
                                        : Image.asset(
                                      'assets/ic_user_placeholder.jpeg',
                                      fit: BoxFit.cover,
                                      //scale: 2.9,
                                    ),
                                  ),
                                ),
                                _setOnline(widget.userChat!.id)
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    username ?? '',
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: AppColor.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text(
                                      widget.userChat!.message ?? '',
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: AppColor.lightgrey,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                    Flexible(
                      flex: 1,
                      child: Visibility(
                        visible: widget.userChat!.unreadCount != null &&
                            widget.userChat!.unreadCount.toString() != "0" &&
                            widget.userChat!.unreadCount.toString().isNotEmpty,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: AppColor.lightgrey,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  widget.userChat!.unreadCount.toString() ?? '',
                                  style: TextStyle(
                                      color: AppColor.white, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });



  }

  _setOnline(String? appUserId) {
    return StreamBuilder<DocumentSnapshot>(
        stream: getUserData(appUserId),
        builder:(BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot){
          if (snapshot.data?.data() != null && (snapshot.data?.data() as Map<String, dynamic>).containsKey(FirestoreConstants.isOnline) && snapshot.data?[FirestoreConstants.isOnline] == 1 ){
            return  Container(
              margin: EdgeInsets.only(top: 43, left: 45),
              child: Image.asset(
                'assets/active.png',
                scale: 2.9,
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        });
  }

  Stream<DocumentSnapshot>? getUserData(String? appUserId) {
    return firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(appUserId)
        .snapshots();
  }
}
