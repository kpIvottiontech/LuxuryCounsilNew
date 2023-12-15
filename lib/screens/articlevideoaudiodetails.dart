import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/constance/global_data.dart';
import 'package:luxury_council/controllers/chat_controller.dart';
import 'package:luxury_council/controllers/homeController.dart';
import 'package:luxury_council/controllers/loginController.dart';
import 'package:luxury_council/controllers/notification_controller.dart';
import 'package:luxury_council/widgets/drawer.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:luxury_council/widgets/local_video_player.dart';
import 'package:luxury_council/widgets/player_screen.dart';
import 'package:luxury_council/widgets/video_player_screen.dart';

import 'package:video_player/video_player.dart';
import 'package:webview_flutter/src/webview_flutter_legacy.dart';
import 'package:open_file/open_file.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:chewie/chewie.dart';
import '../constance/firestore_constants.dart';
import '../models/chat/user_chat.dart';
import '../strings.dart';
import 'bottom_view_widget.dart';

class ArticleVideoAudioDetails extends StatefulWidget {
  const ArticleVideoAudioDetails({super.key});

  @override
  State<ArticleVideoAudioDetails> createState() =>
      _ArticleVideoAudioDetailsState();
}

class _ArticleVideoAudioDetailsState extends State<ArticleVideoAudioDetails> {
  final HomeController homeController = Get.put(HomeController());
  final ChatController chatController = Get.put(ChatController());
  final NotificationController notificationController = Get.put(NotificationController());
  final LoginController loginController = Get.put(LoginController());
  final GlobalKey<ScaffoldState> _key =  GlobalKey();
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final _key1 = UniqueKey();
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  late ScrollController _scrollController;
  int _pageNumber = 10;
  int randomNumber = 0;

  bool isFullscreen = false;

  bool like = false;

  void _toggleView() {
    setState(() {
      like = !like;
    });
  }

  num _stackToView = 1;
  String downloadFolderPath = "";
  int subscriptionid = GlobalData().subscriptionId;
  int index = -1;
  bool isPlaying = true;
  String? articleId;
  String? keys = '';

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    Random random = new Random();
    if (GlobalData().spotlightListing.length > 0) {
      randomNumber = random.nextInt(GlobalData().spotlightListing.length);
    }
    articleId = Get.parameters["articleId"];
    keys = Get.parameters["key"];
    print('articleId>>@@@@> $articleId >>> $keys');
    homeController.article_id = 0.obs;
    getArticleDetails();
    deleteNotification();
    askPermission();
    initPlatformState();
    _scrollController = ScrollController();
    super.initState();
    index = int.parse(Get.parameters["index"] ?? '-1');

  }

  getArticleDetails() async {
    await homeController.getArticleDetailsList(
      context,
      int.parse(articleId.toString()),
    );
  }

  deleteNotification() async {
    print('articleId>>> $articleId>>> $keys');
    if (keys != null) {
      print('articleId>>> $articleId');
      await notificationController.deleteNotification(context, articleId.toString());
      await notificationController.getNotificationListing(context);
    }
  }

  void initPlatformState() async {
    downloadFolderPath = await getDownloadPath() ?? "";
    print("folder path :::::: $downloadFolderPath");
    if (!mounted) return;
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists())
          directory = await getExternalStorageDirectory();
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }

  Future<void> _startDownload(
      BuildContext context, String fileUrl, String savePath) async {
    context.loaderOverlay.show();
    final filename = fileUrl.substring(fileUrl.lastIndexOf("/") + 1);
    print("file url ::: $fileUrl");
    print("savePath ::: $savePath");
    print("file name ::: $filename");
    print("file download url ::: ${savePath + "/" + filename}");
    try {
      await Dio().download(fileUrl, savePath + "/" + filename);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Download completed'),),
      // );
      context.loaderOverlay.hide();
      OpenFile.open(savePath + "/" + filename);
    } catch (e) {
      context.loaderOverlay.hide();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: $e')),
      );
      print("Download failed: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
   // _ArticleVideoAudioDetailsState();
   // homeController.youtubeController.dispose();
    _scrollController.dispose();

  }


  bool _checkEnd() {
    List end = ['mp4', 'wav', 'amr', 'ac4', 'ac3', 'mp3', 'avi'];
    bool isEnd = false;
    end.forEach((element) {
      if (homeController.youtube_url.value.endsWith(element)) {
        isEnd = true;
      }
    });

    return isEnd;
  }

  returnToSreen(){
    if (keys != null) {
      if (keys == 'key')  {
        Get.offNamed("/HomeWithSignUp",arguments: ['/HomeWithSignUp', '', '', '', '', 1]);
      }else{
        Get.offNamed("/NotificationScreen",
            arguments: ['/HomeWithSignUp', '', '', '', '', 1]);
      }
    }else{
      Get.back();
    }
    return false;
  }

  bool isYouTubeLink(String input) {
    final List<RegExp> youtubeRegexList = [
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:music\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/shorts\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
    ];

    for (RegExp regex in youtubeRegexList) {
      if (regex.hasMatch(input)) {
        return true;
      }
    }

    return false;
  }


  @override
  Widget build(BuildContext context) {
   // var h = homeController.artical_long_desc.toString();
    /*String processedHtmlContent = homeController.artical_long_desc.toString().replaceAllMapped(
      RegExp(r'<img.*?src=["\"](.*?)["\"].*?>'),
        (match) {
    final imageUrl = match.group(1);
    return '<img src="$imageUrl" />'; });*/
    return WillPopScope(
      onWillPop: () async {
        return returnToSreen();
      },
      child: GetBuilder<HomeController>(
          id: 'home',
          init: HomeController(),
          builder: (homeMain) {
            return Scaffold(
              backgroundColor: AppColor.grey,
              key: _key,
              appBar:  AppBar(
                leading: GestureDetector(
                  onTap: () {
                    if (keys != null) {
                      if (keys == 'key')  {
                        Get.offNamed("/HomeWithSignUp",arguments: ['/HomeWithSignUp', '', '', '', '', 1]);
                      }else{
                        Get.offNamed("/NotificationScreen",
                            arguments: ['/HomeWithSignUp', '', '', '', '', 1]);
                      }
                    }else{
                      Get.back();
                    }
                  },
                  child: Container(
                    color: AppColor.appbar.withOpacity(0.001),
                    padding: EdgeInsets.only(left: 8),
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: AppColor.white,
                      size: 20,
                    ),
                  ),
                ),
                title: Container(
                  margin: EdgeInsets.only(right: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/logo-img.png",
                      scale: 2.9,
                    ),
                  ),
                ),
                actions: [Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        PlayerScreenState().dispose();
                        homeController.audio.isNotEmpty
                            ? Get.offNamed("/Profile")
                            : Get.toNamed("/Profile");
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
                    GestureDetector(
                      onTap: () {
                        if(  homeController.audio.isNotEmpty){
                          PlayerScreenState().dispose();
                        }
                        Get.offNamed("/NotificationScreen",arguments: ['/ArticleVideoAudioDetails',articleId,'','','',1],parameters:{
                          "key": keys.toString(),
                        });
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
                            ),
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
                backgroundColor: AppColor.appbar,
                //   shadowColor: AppColor.loginappbar,
                centerTitle: true,
                bottomOpacity: 1.0,
                toolbarHeight:60,
                elevation: 4,
              ),
              floatingActionButton:
              GlobalData().spotlightListing.isNotEmpty
                  ? Padding(
                padding: EdgeInsets.only(bottom: 0,),
                child: BottomViewWidget(
                    data: GlobalData().spotlightListing[randomNumber]),
              )
                  : Container(),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              drawerEnableOpenDragGesture: false,
              drawer: DrawerWidget(),
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Obx(
                            () => Container(
                          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15 ),
                          child: ((homeController.data.value.isNotEmpty))
                              ? Visibility(
                            visible: (context.loaderOverlay.visible.obs != true),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: AppColor.grey,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    (homeController.image.isNotEmpty)?
                                    ListView.separated(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.only(bottom: 10),
                                      primary: false,
                                      itemCount: homeController.image.length,
                                      itemBuilder: (context, index) {
                                        if (homeController.image[index] != null)
                                          return Container(
                                            height: 200,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Image.network(
                                              "${homeController.image[index]}",
                                              fit: BoxFit.cover,
                                              // scale: 2.9,
                                            ),
                                          );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return SizedBox(
                                          height: 8,
                                        );
                                      },
                                    ):
                                    SizedBox(),
                                    homeController.youtube_url.isNotEmpty
                                        ? isYouTubeLink(homeController.youtube_url.value)
                                        ? youtubeWidget(url:YoutubePlayer.convertUrlToId(homeController.youtube_url.value))
                                        : _checkEnd()
                                        ?  LocalVideoPlayer(url: homeController.youtube_url.value)
                                        : SizedBox()
                                        : SizedBox(),
                                    homeController.audio.isNotEmpty
                                        ? Container(
                                        alignment: Alignment.topLeft,
                                        width:
                                        MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context)
                                            .size
                                            .height /
                                            7,
                                        child: PlayerScreen(
                                          audioUrl:
                                          homeController.audio.value,
                                        )
                                    )
                                        : SizedBox(),
                                    homeController.resource.isNotEmpty
                                        ? Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                              // color: AppColor.black,
                                                border: Border.all(
                                                    color: AppColor.black),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    5)),
                                            alignment: Alignment.topLeft,
                                            // width: 330,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 100,
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: [
                                                  Image.asset(
                                                    "assets/docs.png",
                                                    scale: 15,
                                                    color: AppColor
                                                        .primarycolor,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      _startDownload(
                                                        context,
                                                        '${homeController.resource}',
                                                        downloadFolderPath,
                                                      );
                                                    },
                                                    child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                            horizontal:
                                                            3,
                                                            vertical:
                                                            3),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: AppColor
                                                                    .primarycolor),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                5)),
                                                        child: Text(
                                                          'Download',
                                                          style: TextStyle(
                                                              color: AppColor
                                                                  .primarycolor),
                                                        )),
                                                  )
                                                ],
                                              ),
                                            )),
                                      ],
                                    )
                                        : SizedBox(),
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 300,
                                              child: Text(
                                                "${homeController.article_name}",
                                                style: TextStyle(
                                                  color: AppColor.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                // _toggleView();
                                                if (homeController.fav.value == 0) {
                                                  setState(() {
                                                    homeController.fav.value = 1;
                                                  });
                                                  homeController.Favourite1(
                                                      context,
                                                      int.parse(homeController
                                                          .article_id
                                                          .toString()),
                                                      // int.parse(
                                                      // loginController.appuserid.toString()),
                                                      1,
                                                      index);
                                                } else if (homeController.fav.value ==
                                                    1) {
                                                  setState(() {
                                                    homeController.fav.value = 0;
                                                  });
                                                  homeController.Favourite1(
                                                      context,
                                                      int.parse(homeController
                                                          .article_id
                                                          .toString()),
                                                      //  int.parse(
                                                      // loginController.appuserid.toString()),
                                                      0,
                                                      index);
                                                }
                                              },
                                              child: Obx(
                                                    () => Container(
                                                  margin: EdgeInsets.only(top: 0),
                                                  child: Image.asset(
                                                    homeController.fav.value == 1
                                                        ? 'assets/heart.png'
                                                        : 'assets/heart1.png',
                                                    scale:
                                                    homeController.fav.value == 1
                                                        ? 1.4
                                                        : 1.2,
                                                    color: AppColor.primarycolor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              // margin: EdgeInsets.only(top: 3),
                                                child: Icon(
                                                  Icons.circle,
                                                  size: 6,
                                                  color: AppColor.white,
                                                )),
                                            Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "  Author:",
                                                      style: TextStyle(
                                                          color: AppColor.white,
                                                          fontSize: 10),
                                                    ),
                                                    Text(
                                                      " ${homeController.publisher}",
                                                      style: TextStyle(
                                                          color: AppColor.white,
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  // margin: EdgeInsets.only(top: 3),
                                                    child: Icon(
                                                      Icons.circle,
                                                      size: 6,
                                                      color: AppColor.white,
                                                    )),
                                                Text(
                                                  "  Date: "
                                                      ""  '${DateFormat('dd/MM/yyyy').format(DateTime.parse(homeController.publish_date.toString()))}',
                                                  // "${homeController.publish_date} ",
                                                  style: TextStyle(
                                                      color: AppColor.white,
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: Container(
                                            child:
                                            Html(
                                              //  style: {
                                              //     "body": Style(
                                              //       color: AppColor.white,
                                              //       fontSize: FontSize(14.0),
                                              //     ),
                                              //   },
                                              style: {
                                                '#': Style(color: Colors.white),
                                                'h1': Style(color: Colors.white),
                                                'body': Style(
                                                    color: Colors.white,
                                                    fontSize: FontSize.medium),
                                                'p': Style(
                                                    color: Colors.white,
                                                    fontSize: FontSize.medium),
                                              },
                                              data:
                                              "${homeController.artical_long_desc.toString().replaceAllMapped(
                                                  RegExp(r'<img.*?src=["\"](.*?)["\"].*?>'),
                                                      (match) {
                                                    final imageUrl = match.group(1);
                                                    return '<img src="$imageUrl" />'; })}",

                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          )
                              : Visibility(
                            visible: (context.loaderOverlay.visible.obs != true),
                            child: Container(
                                child: Text(
                                  noArticleDetailsFound,
                                  style: TextStyle(color: AppColor.primarycolor),
                                )),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 6,
                  )

                  /* GlobalData().spotlightListing.isNotEmpty
                ? BottomViewWidget(
                    data: GlobalData().spotlightListing[randomNumber])
                : Container(),*/
                ],
              ),
            );
          }),
    );
  }

  Widget buildLocalVideo(_chewieController) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Chewie(
            controller: _chewieController,
          ),
        ],
      ),
    );
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

  Future<void> askPermission() async {
    print("ask permission called---------------------------------");
    //storage permission
    var isStoragePermissionDenied = await Permission.storage.isDenied;
    print("Storage permission status : $isStoragePermissionDenied");
    if (isStoragePermissionDenied) {
      var status = await Permission.storage.request();
    }

    // photo permission
    var isPhotoPermissionDenied = await Permission.photos.isDenied;
    print("Photo permission status : $isPhotoPermissionDenied");
    if (isPhotoPermissionDenied) {
      var status = await Permission.photos.request();
    }

    // video permission
    var isVideoPermissionDenied = await Permission.videos.isDenied;
    print("Video permission status : $isVideoPermissionDenied");
    if (isVideoPermissionDenied) {
      var status = await Permission.videos.request();
    }

    //manage external storage permission
    var isExtStoragePermissionDenied =
        await Permission.manageExternalStorage.isDenied;
    print("External Storage permission status : $isExtStoragePermissionDenied");
    if (isExtStoragePermissionDenied) {
      var status = await Permission.manageExternalStorage.request();
    }
  }

  Stream<QuerySnapshot>? getChatList() {
    return firebaseFirestore
        .collection(FirestoreConstants.chatList)
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
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (Duration delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<Duration>>[
                for (final Duration offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }


}
