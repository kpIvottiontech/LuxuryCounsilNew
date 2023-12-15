import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/controllers/search_chat_controller.dart';

import '../constance/firestore_constants.dart';
import '../widgets/app_loader.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchChatController chatController = Get.put(SearchChatController());
  final ScrollController scrollController = ScrollController();
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  int page =1;
  String searchValue ='';

  // List<ChatData> _foundUsers = [];

  @override
  initState() {
    // chatController.searchChatListing = chatController.chatListing;
    context.loaderOverlay.show();
    chatController.getUserChatListWithSearching(context, page, 3,'');
    scrollController.addListener(pagination);
    // _foundUsers = _allUsers;
    super.initState();
  }

/*  void _runFilter(String enteredKeyword) {
    List<ChatData> results = [];
    if (enteredKeyword.isEmpty) {
      results = chatController.chatListing;
    } else {
      results = chatController.chatListing
          .where((user) =>
              user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()) || user["description"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundUsers = results;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.loginappbar,
      appBar: AppBar(
        backgroundColor: AppColor.appbar,
        bottomOpacity: 1.0,
        elevation: 4,
        leadingWidth: 30,
        leading: Container(
          margin: EdgeInsets.only(left: 18),
          child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                color: AppColor.appbar.withOpacity(0.001),
                padding: EdgeInsets.only(left: 8),
                width: double.infinity,
                height: 50,
                child: Icon(
                  Icons.arrow_back_ios,
                  color: AppColor.white,
                  size: 20,
                ),
              ),),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 20, top: 3),
            width: 300,
            height: 40,
            child: Center(
              child: TextField(
                autofocus: true,
                style: TextStyle(color: AppColor.white),
                onChanged: (value) {
                  searchValue = value;
                  _onTextChanged(value);
                },
                decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: AppColor.white),
                    border: InputBorder.none),
              ),
            ),
          ),
        ],
      ),
      body: Obx(()=>
    chatController.searchChatListing.isNotEmpty?
        Column(
          children: [
            Expanded(
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                controller: scrollController,
                itemCount: chatController.searchChatListing.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      Get.toNamed("/ChatDetails", arguments: [
                        chatController.searchChatListing[index].appUserId.toString(),
                        '',
                        '${chatController.searchChatListing[index].firstName} ${chatController.searchChatListing[index].lastName}',
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
                                    child: chatController.searchChatListing[index].profileImgUrl != null && chatController.searchChatListing[index].profileImgUrl != ''?
                                    Image.network(
                                      chatController.searchChatListing[index].profileImgUrl!, fit: BoxFit.cover,
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
                                _setOnline(chatController.searchChatListing[index].appUserId.toString())
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text('${chatController.searchChatListing[index].firstName} ${chatController.searchChatListing[index].lastName}',
                                      style: TextStyle(
                                          color: AppColor.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    width: 200,
                                    child: Text('',
                                      style: TextStyle(
                                        color: AppColor.lightgrey,
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: false,
                              child: Container(
                                margin:
                                EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                        '5',
                                        style: TextStyle(
                                            color: AppColor.white, fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
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
              visible: chatController.isLoadingSearch.value && page != 1,
              child: const AppLoader(
                type: LoaderType.activityIndicator,
              ),
            ),
          ],
        )
        :Center(
        child: const Text(
                        'No results found',
                        style: TextStyle(fontSize: 19, color: AppColor.white),
                      ),
      ),

    )
    );
  }

  void _onTextChanged(String value) {
    page=1;
    chatController.getUserChatListWithSearching(context, page, 3, searchValue);
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

  void pagination() {
    if ((scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) &&
        !chatController.isLastPageSearch.value &&
        !chatController.isLoadingSearch.value) {
      setState(() {
        chatController.isLoadingSearch = true.obs;
        page += 1;
        chatController.getUserChatListWithSearching(context, page, 3,searchValue);
        //add api for load the more data according to new page
      });
    }
  }
}
