import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/controllers/chat_controller.dart';
import 'package:luxury_council/controllers/homeController.dart';
import 'package:luxury_council/controllers/notification_controller.dart';

import '../constance/firestore_constants.dart';
import '../constance/global_data.dart';
import '../models/chat/user_chat.dart';

class AppBarDetails extends StatelessWidget implements PreferredSizeWidget {
  final HomeController homeController = Get.put(HomeController());
  final ChatController chatController = Get.put(ChatController());
  final NotificationController notificationController = Get.put(NotificationController());
  final AppBar appBar;
  final String text;
   String? screenName;
   String? plan1 = '';
   bool? isNotSubscription;
  String? plan = '';
  String? content = '';
  String? subscriptionLevel = '';
  int subscriptionid = GlobalData().subscriptionId;
  int? type = 0;
  //final GestureTapCallback ontap;
  // BuildContext buildContext;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  AppBarDetails({required this.appBar, required this.text, this.isNotSubscription,this.screenName,this.plan1,this.plan,this.content,this.subscriptionLevel,this.type});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.appbar,
      bottomOpacity: 1.0,
      elevation: 4,
      leadingWidth: 30,
      title: Text(
        text.toString(),
        style: TextStyle(
            color: AppColor.white, fontWeight: FontWeight.bold, fontSize: 16),
        textAlign: TextAlign.left,
      ),
      centerTitle: false,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Container(
          color: AppColor.appbar.withOpacity(0.001),
          padding: EdgeInsets.only(left: 18),
          width: 50,
          height: 50,
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColor.white,
            size: 20,
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.toNamed("/Profile");
              },
              child: Container(
                margin: EdgeInsets.only(right: 0),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(
                    "assets/profile.png",
                    scale: 2.9,
                  ),
                ),
              ),
            ),
            subscriptionid == 0 ? SizedBox():
            GestureDetector(
              onTap: (){
                Get.offNamed("/NotificationScreen",arguments: [screenName,plan1,plan,content,subscriptionLevel,type],);
              },
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 0),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.asset(
                        "assets/notification.png",
                        scale: 2.9,
                      ),
                    )
                  ),
                  setUnreadNotiCount()
                ],
              ),
            ),
            subscriptionid == 3 ||
                subscriptionid == 4 ||
                subscriptionid == 5
                ? GestureDetector(
              onTap: () {
                Get.toNamed("/Chats");
              },
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 8),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0,right: 4,top: 11,bottom: 8),
                      child: Image.asset(
                        "assets/message.png",
                        scale: 2.9,
                      ),
                    ),
                  ),
                  setUnreadCount()
                ],
              ),
            )
                : Container()
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);

  Stream<QuerySnapshot>? getChatList() {
    return firebaseFirestore.collection(FirestoreConstants.chatList)
        .doc(GlobalData().userId.toString())
        .collection(GlobalData().userId.toString())
        .orderBy(FirestoreConstants.timeStampChat, descending: true)
        .snapshots();

  }
  setUnreadCount() {
    return StreamBuilder<QuerySnapshot>(
        stream: getChatList(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            chatController.counts.value = 0;
            for (DocumentSnapshot i in snapshot.data?.docs ?? []) {
              UserChat userChat = UserChat.fromDocument(i);
              chatController.counts.value = chatController.counts.value + (userChat.unreadCount ?? 0);
            }
            return (chatController.counts.value > 0)
                ? Positioned(
              top: 0,
              right: 8,
              child: Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 0),
                child: Text(
                  chatController.counts.value == 0 ? '' : chatController.counts.value.toString(),
                  style: TextStyle(
                      color: AppColor.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w600),
                ),
              ),
            )
                : Container(  height: 16,
              width: 16,color: Colors.transparent,);
          } else {
            return Container();
          }
        });
  }

  setUnreadNotiCount(){
    return Obx(() =>       notificationController.notificationCount.value == 0?
    SizedBox():
    Positioned(
      top: 8,
      right: 0,
      child: Container(
        height: 16,
        width: 16,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: 0),
        child: Text(
          notificationController.notificationCount.value == 0 ? '' : notificationController.notificationCount.value.toString(),
          style: TextStyle(
              color: AppColor.white,
              fontSize: 8,
              fontWeight: FontWeight.w600),
        ),
      ),
    ));
  }
}
