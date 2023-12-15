import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_council/api_config/api_services.dart';
import 'package:luxury_council/api_config/urls.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/controllers/chat_controller.dart';
import 'package:luxury_council/controllers/editprofileController.dart';
import 'package:luxury_council/models/recent_chat_model.dart';
import 'package:luxury_council/widgets/player_screen.dart';
import 'package:luxury_council/widgets/showChatImage.dart';

import '../constance/firestore_constants.dart';
import '../constance/global_data.dart';
import '../models/chat/user_chat.dart';
import '../widgets/app_loader.dart';
import 'bottom_view_widget.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final ChatController chatController = Get.put(ChatController());
  EditProfileController editProfileController =
  Get.put(EditProfileController());
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final List<bool> _selectedButton = <bool>[false,true];
  final ScrollController scrollController = ScrollController();
  int page =1;
  int randomNumber =0;
  String? keys = '';

  @override
  initState() {
    keys = Get.parameters["key"] ?? '';
    PlayerScreenState().assetsAudioPlayer.dispose();
/*    Random random = new Random();
   // randomNumber = random.nextInt(GlobalData().spotlightListing.length);*/
    getCurrentId();
    getChatUser();
    checkFirst();
    scrollController.addListener(pagination);
    super.initState();
  }

  getChatUser() async {
   await chatController.getUserChatList(context, page, GlobalData().subscriptionId);
  }

  checkFirst() async {
    if (keys != null) {
      if (keys == 'key')  {
        await editProfileController.getProfileIntersetList(context, null, 0, 100);
        await editProfileController.getprofile(context);
      }else{
        await editProfileController.getProfileIntersetList(context, null, 0, 100);
        await editProfileController.getprofile(context);
      }
    }else{
      await editProfileController.getProfileIntersetList(context, null, 0, 100);
      await editProfileController.getprofile(context);
    }
  }

  returnToSreen(){
    if (keys != null) {
      if (keys == 'key')  {
        // Get.back();
        Get.offAndToNamed("/HomeWithSignUp");
      }else{
        Get.back();
      }
    }else{
      Get.back();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return returnToSreen();
      },
      child: GetBuilder<ChatController>(
          id: 'chat',
          init: ChatController(),
          builder: (chat) {
            return   Scaffold(
                backgroundColor: AppColor.loginappbar,
                appBar: AppBar(
                  backgroundColor: AppColor.appbar,
                  bottomOpacity: 1.0,
                  elevation: 4,
                  leadingWidth: 30,
                  centerTitle: false,
                  title: Text(
                    "CHATS",
                    style: TextStyle(
                        color: AppColor.white, fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                  leading: Container(
                    margin: EdgeInsets.only(left: 18),
                    child: GestureDetector(
                      onTap: () {
                        returnToSreen();
                      },
                      child: Container(
                        color: AppColor.appbar.withOpacity(0.001),
                        // color: Colors.yellow,
                        width:double.infinity,
                        height: 60,
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: AppColor.white,
                          size: 20,
                        ),
                      ),),
                  ),
                  actions: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed("/SearchPage");
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset(
                                "assets/search.png",
                                color: AppColor.white,
                                scale: 2.3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                body:
                Obx(()=>
                chatController.chatListingResponse.value?
                Column(
                  children: [
                    Container(
                      color: AppColor.appbar.withOpacity(0.5),
                      child: ToggleButtons(
                          direction: Axis.horizontal,
                          onPressed: (int index) {
                            setState(() {
                              for (int i = 0; i < _selectedButton.length; i++) {
                                _selectedButton[i] = i == index;
                              }
                            });
                          },
                          selectedBorderColor: AppColor.grey,
                          selectedColor: Colors.white,
                          fillColor: AppColor.primarycolor,
                          color: Colors.white,
                          constraints: const BoxConstraints(
                            minHeight: 50.0,
                            minWidth: 175.0,
                          ),
                          isSelected: _selectedButton,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "All",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "Chats",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ]),
                    ),
                    Expanded(
                        child: _selectedButton[0] ? _setAllUseListing():_setChatListing(chat)
                    ),
                    SizedBox(
                      height: 40,
                    )
                    /* GlobalData().spotlightListing.isNotEmpty ?
           BottomViewWidget(data : GlobalData().spotlightListing[randomNumber]):
           Container()*/
                  ],
                ): Container()
                )
            );
          }
      ),
    );

  }

  _setAllUseListing() {
    return chatController.chatListing.isNotEmpty
        ? Column(
      children: [
        Expanded(
          child: ListView.separated(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: chatController.chatListing.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Get.toNamed("/ChatDetails", arguments: [
                    chatController.chatListing[index].appUserId.toString(),
                    chatController.chatListing[index].profileImgUrl,
                    '${chatController.chatListing[index].firstName} ${chatController.chatListing[index].lastName}',
                    chatController.chatListing[index].profileImgUrl,
                  ],parameters: {
                    "key": "",
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: AppColor.loginappbar,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                  child: chatController.chatListing[index].profileImgUrl != null && chatController.chatListing[index].profileImgUrl != ''?
                                  Image.network(
                                    chatController.chatListing[index].profileImgUrl!, fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context, Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      }
                                    },
                                  )
                                      :  Image.asset(
                                    'assets/ic_user_placeholder.jpeg',
                                    fit: BoxFit.cover,
                                    //scale: 2.9,
                                  ),
                              ),
                            ),
                            /*ClipOval(
                              // radius: 30,
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(28),
                                child: Image.asset(
                                  'assets/ic_user_placeholder.jpeg',
                                  fit: BoxFit.cover,
                                  //scale: 2.9,
                                ),
                              ),
                            ),*/
                           /* CircleAvatar(
                              radius: 30,
                              child: Image.asset(
                                'assets/chatimg.png',
                                //scale: 2.9,
                              ),
                            ),*/
                            _setOnline(chatController.chatListing[index].appUserId.toString())
                          ],
                        ),
                        Expanded(
                          child: Container(
                            margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${chatController.chatListing[index].firstName} ${chatController.chatListing[index].lastName}',
                                  style: TextStyle(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                SizedBox(height: 5,),
                                _setLastMsg(chatController.chatListing[index].appUserId!.toInt()),
                              ],
                            ),
                          ),
                        ),
                        setUnreadCount(chatController.chatListing[index].appUserId!.toInt())
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 10,
              );
            },
          ),
        ),
        Visibility(
          visible: chatController.isLoading.value && page != 1,
          child: const AppLoader(
            type: LoaderType.activityIndicator,
          ),
        ),
      ],
    )
        : Center(
            child: const Text(
              'No results found',
              style: TextStyle(fontSize: 18, color: AppColor.white),
            ),
          );
  }

  Future checkApi(String id) async {
   var response =  await POST_API({
      "app_user_id": id,
    }, Urls.recentChat, context);
   RecentChatModel recentChatModel =
   RecentChatModel.fromJson(jsonDecode(response));
   return recentChatModel;
  }

  _setChatListing(ChatController chat) {
    return StreamBuilder<QuerySnapshot>(
      stream: getChatList(10),
        builder:(BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot){
         // if (snapshot.hasData) {
          if (snapshot.hasData) {
            print('testing');
            return ((snapshot.data?.docs.length ?? 0) > 0) ?
              ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data?.docs.length ?? 0,
              itemBuilder: (context, index) {
                return chatListingView(snapshot.data?.docs[index],index,chat);
          /*checkApi(snapshot.data!.docs[index].id.toString()).then((value) {
            RecentChatModel recentChatModel = value;
          });
                return */
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 10,
                );
              },
            )
                : Center(
              child: const Text(
                'No results found',
                style: TextStyle(fontSize: 18, color: AppColor.white),
              ),
            );
        /*  :Center(
              child: CircularProgressIndicator(
                color: AppColor.primarycolor,
              ),
            );*/
          }
          else {
            return Center(
              child: CircularProgressIndicator(
                color: AppColor.primarycolor,
              ),
            );
          }
        });
  }

  Stream<QuerySnapshot>? getChatList(int limit) {

    return firebaseFirestore.collection(FirestoreConstants.chatList)
        .doc(GlobalData().userId.toString())
        .collection(GlobalData().userId.toString())
        .limit(limit)
        .orderBy(FirestoreConstants.timeStampChat, descending: true)
        .snapshots();

  }

  chatListingView( DocumentSnapshot? document,int index,ChatController chat) {
    if(document != null){
      UserChat userChat = UserChat.fromDocument(document);
      print('id>>> ${userChat.id.toString()}');
      //ShowChatImageState().initState();
      return ShowChatImage(userChat: userChat);
     // return Text('${userChat.id.toString()}',style: TextStyle(color: Colors.white),);
        /*GestureDetector(
          onTap: () {
            print('${userChat.id.toString()}>>>>>> ${userChat.name} >>>$index');
            Get.toNamed("/ChatDetails", arguments: [
              userChat.id.toString(),
              '',
              userChat.name,
              '',
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
                      child: ShowChatImage( key: Key('chat_image_$index'),userChat: userChat)),
                  Flexible(
                    flex: 1,
                    child: Visibility(
                      visible: userChat.unreadCount != null &&
                          userChat.unreadCount.toString() != "0" &&
                          userChat.unreadCount.toString().isNotEmpty,
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
                                userChat.unreadCount.toString() ?? '',
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
        );*/
    }
    else{
      return Container();
    }
  }

  void getCurrentId() async {
    await GlobalData().retrieveLoggedInUserDetail();
  }

   _setLastMsg(int? appUserId)  {
    return FutureBuilder(
      future: getUserChat(appUserId),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> text) {
        if (text.data?.data() == null) {
          return SizedBox.shrink();
        } else {
          return Text(
            text.data?[FirestoreConstants.message],
            style: TextStyle(
              color: AppColor.lightgrey,
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          );
        }
      },
    );
  }

  setUnreadCount(int? appUserId) {
    return FutureBuilder(
      future: getUserChat(appUserId),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> text) {
        if (text.data?.data() == null ||
            text.data?[FirestoreConstants.unreadCount] == 0) {
          return SizedBox.shrink();
        } else {
          return Container(
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
                    text.data?[FirestoreConstants.unreadCount].toString() ??'',
                    style: TextStyle(
                        color: AppColor.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<DocumentSnapshot>? getUserChat(int? appUserId) {
    return firebaseFirestore
        .collection(FirestoreConstants.chatList)
        .doc(GlobalData().userId.toString())
        .collection(GlobalData().userId.toString())
        .doc(appUserId.toString())
        .get();
  }

  Stream<DocumentSnapshot>? getUserData(String? appUserId) {
    return firebaseFirestore
        .collection(FirestoreConstants.pathUserCollection)
        .doc(appUserId)
        .snapshots();
  }

  void pagination() {
    if ((scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) &&
        !chatController.isLastPage.value &&
        !chatController.isLoading.value) {
      setState(() {
        chatController.isLoading = true.obs;
        page += 1;
        chatController.getUserChatList(context, page, GlobalData().subscriptionId);
        //add api for load the more data according to new page
      });
    }
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

}
