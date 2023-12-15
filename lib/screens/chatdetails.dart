import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:luxury_council/api_config/api_services.dart';
import 'package:luxury_council/api_config/urls.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/constance/global_data.dart';
import 'package:luxury_council/controllers/editprofileController.dart';
import 'package:luxury_council/models/recent_chat_model.dart';
import '../constance/firestore_constants.dart';
import '../models/chat/chatlist.dart';
import '../models/chat/message_chat.dart';
import 'package:http/http.dart' as http;

String currentChatId = '';

class ChatDetails extends StatefulWidget {
  final String peerId;
  final String peerImage;
  final String peerNickname;

  ChatDetails({
    super.key,
    required this.peerId,
    required this.peerImage,
    required this.peerNickname,
  });

  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  String? currentUserId;
  String? currentUserName;
  String groupChatId = "";
  EditProfileController editProfileController =
      Get.put(EditProfileController());
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot> listMessage = [];
  final ScrollController listScrollController = ScrollController();
  int _limit = 20;
  int _limitIncrement = 20;
  DateTime newTime = DateTime.now();
  String formattedDate = "";
  DateTime previous = DateTime.now();
  DateTime? displayedDate = DateTime.now();

  bool isAfterDate = false;
  String image = '';
  Offset _tapPosition = Offset.infinite;
  String? keys = '';


  void _showContextMenu(BuildContext context) async {
    final RenderObject? overlay =
        Overlay.of(context)?.context.findRenderObject();

    final result = await showMenu(
        context: context,
        position: RelativeRect.fromRect(
            Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 100, 100),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                overlay!.paintBounds.size.height)),
        items: [
          const PopupMenuItem(
            child: Text('Delete'),
            value: "fav",
          ),
          const PopupMenuItem(
            child: Text('Copy'),
            value: "close",
          )
        ]);
    // perform action on selected menu item
    switch (result) {
      case 'fav':
        print("fav");
        break;
      case 'close':
        print('close');
        Navigator.pop(context);
        break;
    }
  }

  TextEditingController typeController = TextEditingController();

  @override
  void initState() {
    keys = Get.parameters["key"];
    checkFirst();
    getApi(widget.peerId);
    print('>>>>>c>>>>>>${widget.peerId}>> >> ${currentChatId}>>');
    readLocal();
    _updateUnreadCount();
    listScrollController.addListener(_scrollListener);
    currentChatId = widget.peerId;
   // setCurrentChatId(widget.peerId);
    //currentChatId = widget.peerId;
    super.initState();
  }
  setCurrentChatId(String id) {
    setState(() {
      currentChatId = id;
    });
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

  getApi(String id) async {
    await getRecentChat(context,id);
  }

  getRecentChat(BuildContext context,String userId) async {
    await POST_API({
      "app_user_id": userId,
    }, Urls.recentChat, context)
        .then((response) {
      Map<String, dynamic> chatResponse = jsonDecode(response);
      if (chatResponse["data"].isEmpty) {
       /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'No url found',
            style: TextStyle(color: AppColor.white),
          ),
        ));*/
      } else {
        if (chatResponse['status'] != true) {
        } else {
          RecentChatModel recentChatModel = RecentChatModel.fromJson(jsonDecode(response));
          setState(() {
            image = recentChatModel.data![0].profileImgUrl!;
          });
        }
      }

    }, onError: (e) {
      print('========================${e.toString()}');
      /*ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));*/
    });
  }

  returnToSreen(){
    if (keys != null) {
      if (keys == 'key')  {
       // Get.back();
        Get.offAndToNamed("/Chats",parameters: {
        "key": "key",
        });
      }else{
        Get.offAndToNamed("/Chats",parameters: {
          "key": "",
        });
        setCurrentChatId('');
       // Get.back();
      }
    }else{
      Get.offAndToNamed("/Chats",parameters: {
        "key": "",
      });
      setCurrentChatId('');
    // Get.back();
    }
    return false;
  }

  @override
  void dispose() {
    //setCurrentChatId('');
    currentChatId = '';
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return returnToSreen();
      },
      child: Scaffold(
        backgroundColor: AppColor.loginappbar,
        appBar: AppBar(
          backgroundColor: AppColor.appbar,
          bottomOpacity: 1.0,
          elevation: 4,
          leadingWidth: 30,
          centerTitle: false,
          title: Text(
            widget.peerNickname,
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
                width: double.infinity,
                height: 60,
                child: Icon(
                  Icons.arrow_back_ios,
                  color: AppColor.white,
                  size: 20,
                ),
              ),
            ),
          ),
          /* actions: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      "assets/dotmenu.png",
                      scale: 2.9,
                    ),
                  ),
                ),
              ],
            ),
          ],*/
        ),
        body: Column(
          children: [
            Expanded(child: buildListMessage()),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding:
                    EdgeInsets.only(left: 10, bottom: 18, top: 10, right: 10),
                height: 80,
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Container(
                        height: 55,
                        child: TextField(
                          controller: typeController,
                          style: TextStyle(color: AppColor.white),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: AppColor.appbar,
                            hintText: "Type Something here...",
                            hintStyle: TextStyle(color: AppColor.darkgrey),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: AppColor.primarycolor),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    FloatingActionButton(
                      shape: CircleBorder(),
                      onPressed: () {
                        setState(() {
                          if (typeController.text.isNotEmpty) {
                            onSendMessage(typeController.text.toString());
                            typeController.clear();
                          }
                        });
                      },
                      child: Icon(
                        Icons.arrow_forward_outlined,
                        color: Colors.black,
                        size: 35,
                      ),
                      backgroundColor: AppColor.primarycolor,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void readLocal() {
    currentUserId = GlobalData().userId.toString();
   // currentUserName = '${GlobalData().firstName} ${GlobalData().lastName}';
    currentUserName = '${GlobalData().firstName} ${GlobalData().lastName}';

    int oppId = int.parse(widget.peerId);

    if (GlobalData().userId > oppId) {
      groupChatId = '$currentUserId-${widget.peerId}';
    } else {
      groupChatId = '${widget.peerId}-$currentUserId';
    }
    /* chatProvider?.updateDataFirestore(
      FirestoreConstants.pathUserCollection,
      currentUserId ?? '',
      {FirestoreConstants.chattingWith: peerId},
    );*/
  }

  Future<void> _checkNewMsg(int index) async {
    /*if (index == 0 && firstVisibleItemIndex < 1) {
      updateReadValue(false);
    }*/
    firebaseFirestore
        .collection(FirestoreConstants.chatList)
        .doc(currentUserId)
        .collection(currentUserId ?? '')
        .doc(widget.peerId)
        .update({FirestoreConstants.unreadCount: 0});
  }

  void onSendMessage(String message) async {
    sendPush(message);
    DocumentSnapshot? snapChat = await firebaseFirestore
        .collection(FirestoreConstants.chatList)
        .doc(widget.peerId)
        .collection(widget.peerId)
        .doc(currentUserId ?? '')
        .get();
    int unreadCount = 0;
    if (snapChat.data() != null) {
      unreadCount = snapChat[FirestoreConstants.unreadCount];
    }
    unreadCount = unreadCount + 1;
    String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();

    DocumentReference documentReference = firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(timeStamp);

    MessageChat messageChat = MessageChat(
      idFrom: currentUserId,
      idTo: widget.peerId,
      timestamp: timeStamp,
      content: message,
      type: 0,
    );

    firebaseFirestore.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        messageChat.toJson(),
      );
    });

    ChatList sender = ChatList(
        id: currentUserId,
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        message: message,
        name: currentUserName,
        groupId: groupChatId,
        myId: widget.peerId,
        photoUrl: editProfileController.imagePath.value,
        unreadCount: unreadCount);

    firebaseFirestore
        .collection(FirestoreConstants.chatList)
        .doc(widget.peerId)
        .collection(widget.peerId)
        .doc(currentUserId)
        .set(sender.toJson());

    ChatList receiver = ChatList(
        id: widget.peerId,
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        message: message,
        name: widget.peerNickname,
        groupId: groupChatId,
        myId: currentUserId,
        photoUrl: image,
        unreadCount: 0);

    firebaseFirestore
        .collection(FirestoreConstants.chatList)
        .doc(currentUserId)
        .collection(currentUserId.toString())
        .doc(widget.peerId)
        .set(receiver.toJson());
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget buildListMessage() {
    return groupChatId.isNotEmpty
        ? StreamBuilder<QuerySnapshot>(
            stream: getChatStream(_limit),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                listMessage = snapshot.data?.docs ?? [];

                if (listMessage.length > 0) {
                  List<Widget> messageWidgets = [];
                  String?
                      currentDay; // Initialize currentDay as nullable string
                  int messageCountForCurrentDay = 0;

                  for (int index = 0; index < listMessage.length; index++) {
                    DateTime messageDate = DateTime.fromMillisecondsSinceEpoch(
                        int.parse(listMessage[index]['timestamp']));
                    final day =
                        DateFormat('EEEE, dd.MM.yyyy').format(messageDate);

                    if (index != 0 && index < listMessage.length - 1) {
                      if (DateFormat('EEEE, dd.MM.yyyy').format(
                              DateTime.fromMillisecondsSinceEpoch(int.parse(
                                  listMessage[index]['timestamp']))) !=
                          DateFormat('EEEE, dd.MM.yyyy').format(
                              DateTime.fromMillisecondsSinceEpoch(int.parse(
                                  listMessage[index + 1]['timestamp'])))) {
                        // Insert the date at the third position
                        messageWidgets
                            .add(_buildItem(index, listMessage[index], day));
                      } else {
                        messageWidgets
                            .add(_buildItem(index, listMessage[index], ''));
                      }
                    } else if (index == listMessage.length - 1) {
                      // Insert the date at the last position of the day
                      messageWidgets
                          .add(_buildItem(index, listMessage[index], day));
                    } else {
                      messageWidgets
                          .add(_buildItem(index, listMessage[index], ''));
                    }
                  }

                  return ListView(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    children: messageWidgets,
                    controller: listScrollController,
                    reverse: true,
                  );
                } else {
                  return Center(child: Text("No messages here yet..."));
                }
              } else {
                return Center(
                    child: CircularProgressIndicator(
                        color: AppColor.primarycolor));
              }
            },
          )
        : Container();
  }

  Widget _buildDateSeparator(String day) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        day,
        style: TextStyle(
          color: AppColor.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Stream<QuerySnapshot>? getChatStream(
    int limit,
  ) {
    // print('newGrpId::${groupChatId}');
    // if(groupChatId.isEmpty){
    //   groupChatId = currentUserId+'-'+peerid;
    // }
    print('newGrpId::${groupChatId}');
    return firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(limit)
        .snapshots();
  }

  Widget _buildItem(
      int index, DocumentSnapshot? document, String formattedDate) {
    if (document != null) {
      MessageChat messageChat = MessageChat.fromDocument(document);
      _checkNewMsg(index);
      return GestureDetector(
        onTap: () {
          print('index>>>>$index');
        },
        child: Column(
          children: [
            formattedDate != ''
                ? Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Text('${formattedDate}',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center)),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                : Container(),
            Container(
                padding: EdgeInsets.only(
                    left: messageChat.idTo == currentUserId ? 14 : 50,
                    right: messageChat.idTo == currentUserId ? 50 : 14,
                    top: 10,
                    bottom: 10),
                child: Align(
                  alignment: (messageChat.idTo == currentUserId
                      ? Alignment.topLeft
                      : Alignment.topRight),
                  child: Row(
                    crossAxisAlignment: messageChat.idTo == currentUserId
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    mainAxisAlignment: messageChat.idTo == currentUserId
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      messageChat.idTo == currentUserId
                          ? ClipOval(
                              // radius: 30,
                              child: SizedBox.fromSize(
                                  size: Size.fromRadius(18),
                                  child: image != ''
                                      ? Image.network(
                                    image!,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
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
                                        )),
                            )
                          : SizedBox(),
                      SizedBox(
                        width: 7,
                      ),
                      Flexible(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          color: (messageChat.idTo == currentUserId
                              ? AppColor.black
                              : AppColor.primarycolor),
                          child: Text(
                            messageChat.content ?? '',
                            style:
                                TextStyle(fontSize: 15, color: AppColor.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      messageChat.idFrom == currentUserId
                          ? ClipOval(
                              // radius: 30,
                              child: SizedBox.fromSize(
                                  size: Size.fromRadius(18),
                                  child: editProfileController
                                          .imagePath.value.isNotEmpty
                                      ? Image.network(
                                          editProfileController.imagePath.value,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            }
                                          },
                                        )
                                      : Image.asset(
                                          'assets/drawerprofile.png',
                                          fit: BoxFit.cover,
                                        )),
                            )
                          /*CircleAvatar(
                        radius: 17,
                        child: Image.asset(
                          'assets/chatimg.png',
                        ),
                      )*/
                          : SizedBox(),
                    ],
                  ),
                )),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  void sendPush(
    String content,
  ) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection(FirestoreConstants.pathUserCollection)
        .doc(widget.peerId)
        .get();
    String token = snap[FirestoreConstants.deviceToken];

    await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAstZB1mY:APA91bEd2LfKwZIJCsdJSdde7v_Sg-9bsakjqNaPaOW-TBEKSmzrS087x2B-Zhc4rndr8Ubu7mKUNOiKVe1VsvVkIEfpRpSKG5V9nS-a7wjzWQaCtX8RcuPRZhbpEmUAeOLN7z9MeCPx'
        },
        body: jsonEncode(<String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{
            'status': 'done',
            'body': content,
            'title': currentUserName,
            'peerId': currentUserId,
            'peerAvatar': '',
            'peerNickname': currentUserName,
            'grpId': groupChatId,
          },
          'notification': <String, dynamic>{
            'body': content,
            'title': currentUserName,
            'android_channel_id': "high_importance_channel"
          },
          "to": token
        }));
  }

  void _updateUnreadCount() async {
    DocumentSnapshot? snapshot = await firebaseFirestore
        .collection(FirestoreConstants.chatList)
        .doc(currentUserId ?? '')
        .collection(currentUserId ?? '')
        .doc(widget.peerId)
        .get();
    if (snapshot.data() != null) {
      firebaseFirestore
          .collection(FirestoreConstants.chatList)
          .doc(currentUserId ?? '')
          .collection(currentUserId ?? '')
          .doc(widget.peerId)
          .update({FirestoreConstants.unreadCount: 0});
    }
  }

  void _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange &&
        _limit <= listMessage.length) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }
}
