import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/constance/global_data.dart';
import 'package:luxury_council/controllers/chat_controller.dart';
import 'package:luxury_council/controllers/editprofileController.dart';
import 'package:luxury_council/controllers/filterController.dart';
import 'package:luxury_council/controllers/homeController.dart';
import 'package:luxury_council/controllers/loginController.dart';
import 'package:luxury_council/controllers/notification_controller.dart';
import 'package:luxury_council/screens/bottom_view_widget.dart';
import 'package:luxury_council/strings.dart';
import 'package:luxury_council/widgets/drawer.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constance/firestore_constants.dart';
import '../controllers/spotlight_listing_controller.dart';
import '../models/chat/user_chat.dart';

class HomeWithSignUp extends StatefulWidget {
  const HomeWithSignUp({super.key});

  @override
  State<HomeWithSignUp> createState() => HomeWithSignUpState();
}

class HomeWithSignUpState extends State<HomeWithSignUp>
    with WidgetsBindingObserver {
  final NotificationController notificationController = Get.put(NotificationController());
  final ChatController chatController = Get.put(ChatController());
  final HomeController homeController = Get.put(HomeController());
  final FilterController filterController = Get.put(FilterController());
  final SpotlightListingController spotlightController =
      Get.put(SpotlightListingController());
  final EditProfileController editProfileController =
      Get.put(EditProfileController());
  final LoginController loginController = Get.put(LoginController());

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  int _selectedIndex = -1;
  late ScrollController _scrollController;
  int limit = 10;
  String categorys = '';
  String interests = '';
  String mediatypes = '';
  bool isChat = false;
  bool isEvent = false;
  bool isNoti = false;
  int subscriptionid = GlobalData().subscriptionId;
  int selectedIndex = -1;


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    await GlobalData().retrieveLoggedInUserDetail();
    if (state == AppLifecycleState.resumed) {
      FirebaseFirestore.instance
          .collection(FirestoreConstants.pathUserCollection)
          .doc(GlobalData().userId.toString())
          .update({FirestoreConstants.isOnline: 1});
    } else {
      FirebaseFirestore.instance
          .collection(FirestoreConstants.pathUserCollection)
          .doc(GlobalData().userId.toString())
          .update({FirestoreConstants.isOnline: 0});
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    setChatVisibility();
    setEventVisibility();
    spotlightController.getSpotlightListingWithOutPagination(context);
    // homeController.articleList.clear();
    // homeController.pageNumber.value = 1;
    homeController.getArticleList(
      context,
      homeController.pageNumber.value,
      limit,
      homeController.searchController.text.toString(),
      categorys,
      mediatypes,
      interests,
    );
    homeController.getCategoriesList(context, null, 0, 100);
    homeController.getIntersetList(context, null, 0, 100);
    homeController.getMediaTypeList(
      context,
      null,
    );
    checkFirst();
    FirebaseMessaging.instance.getToken().then((value) {
      if ((value ?? '').isNotEmpty) {
        homeController.manageDeviceToken(context, value ?? '');
      }
    });
    // homeController.Favourite(context);
    _scrollController = ScrollController();
    getNotification();
    super.initState();
  }
  checkFirst() async {
    await filterController.getProfileIntersetList(context, null, 0, 100);
    await editProfileController.getprofile(context);
  }

  getNotification() async {
    notificationController.articleData.clear();
   await notificationController.getNotificationListing(Get.context!);
  }


  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() async {
       if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent ) {
        print('total page>total_page>${homeController.total_page.value}>> ${homeController.pageNumber.value}');
          if (homeController.articlelistresponce.isTrue) {
            homeController.articlelistresponce.value = false;
            print('check page>>${homeController.pageNumber.value} >>> ${homeController.articlelistresponce.value}');
            if((homeController.total_page.value) > homeController.pageNumber.value) {
              setState(() {
                homeController.pageNumber.value = homeController.pageNumber.value + 1;
              });
              print('check page>>${homeController.pageNumber.value} >>> ${homeController.total_page.value}');
              await  homeController.getArticleList(
                context,
                homeController.pageNumber.value,
                limit,
                homeController.searchController.text,
                categorys,
                mediatypes,
                interests,
              );
            }
          }
      }
    }
    });
    return GetBuilder<HomeController>(
      id: 'home',
      init: HomeController(),
      builder: (homeMain) {
        return Scaffold(
          backgroundColor: AppColor.loginappbar,
          key: _key,
          appBar: AppBar(
            leading: Container(
              margin: EdgeInsets.only(left: 8),
              child: GestureDetector(
                  onTap: () {
                    _key.currentState!.openDrawer();
                  },
                  child: Icon(
                    Icons.menu,
                    color: AppColor.white,
                    size: 30,
                  )),
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
                  GestureDetector(
                    onTap: () {
                      print('yes>>');
                      Get.toNamed("/NotificationScreen", arguments: ['/HomeWithSignUp', '', '', '', '', 1],
                      );
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
                       /* boxLength != 0
                            ? Positioned(
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
                                    boxLength == 0 ? '' : boxLength.toString(),
                                    style: TextStyle(
                                        color: AppColor.white,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              )
                            : Container(),*/
                        setUnreadNotiCount()
                      ],
                    ),
                  ),
                  //: SizedBox()
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
            elevation: 4,
          ),
          floatingActionButton: GlobalData().spotlightListing.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(
                    bottom: 0,
                  ),
                  child: Obx(
                    () => spotlightController.spotlightListingData.isNotEmpty
                        ? BottomViewWidget(
                            data: spotlightController.spotlightListingData[
                                spotlightController.randomNumber.value])
                        : Container(),
                  ),
                )
              : Container(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          drawerEnableOpenDragGesture: false,
          drawer: DrawerWidget(isChat: isChat, isEvent: isEvent),
          body: SafeArea(
              child: Container(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          margin: EdgeInsets.only(top: 15),
                          child: TextFormField(
                            controller: homeController.searchController,
                            style:
                                TextStyle(fontSize: 14, color: AppColor.white),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColor.black,
                                contentPadding: EdgeInsets.all(8),
                                hintText: 'Search Article...',
                                prefixIcon: Image.asset(
                                  'assets/search.png',
                                  scale: 2.9,
                                ),
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 14),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onFieldSubmitted: (value) {
                              if (homeController.searchController.text.toString() != '') {
                                homeController.articleList.clear();
                                homeController.pageNumber.value = 1;
                                homeController.getArticleList(
                                  context,
                                  homeController.pageNumber.value,
                                  10,
                                  homeController.searchController.text.toString(),
                                  categorys,
                                  mediatypes,
                                  interests,
                                );
                              } else {
                                homeController.articleList.clear();
                                homeController.pageNumber.value = 1;
                                homeController.getArticleList(
                                  context,
                                  homeController.pageNumber.value,
                                  10,
                                  homeController.searchController.text.toString(),
                                  categorys,
                                  mediatypes,
                                  interests,
                                );
                              }
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => homeController.categorieList.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        _showCategorySelect(context);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 10),
                                        height: 30,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: AppColor.primarycolor)),
                                        child: Center(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Obx(
                                              () => Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                                  child: Text(
                                                    homeController
                                                            .selectedCategoryValuesToDisplay
                                                            .value
                                                            .isEmpty
                                                        ? "Category"
                                                        : homeController
                                                            .selectedCategoryValuesToDisplay
                                                            .value,
                                                    // softWrap: true,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: AppColor.white,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Image.asset(
                                              'assets/dropdown.png',
                                              scale: 2.9,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            )
                                          ],
                                        )),
                                      ),
                                    )
                                  : Center(child: Text(noCategoryFound)),
                            ),
                            Obx(
                              () => homeController.interestList.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        _showInterestSelect(context);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 10),
                                        height: 30,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: AppColor.primarycolor)),
                                        child: Center(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Obx(
                                              () => Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                                  child: Text(
                                                    homeController
                                                            .selectedIntersetValuesToDisplay
                                                            .value
                                                            .isEmpty
                                                        ? "Interest"
                                                        : homeController
                                                            .selectedIntersetValuesToDisplay
                                                            .value,
                                                    // softWrap: true,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: AppColor.white,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Image.asset(
                                              'assets/dropdown.png',
                                              scale: 2.9,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            )
                                          ],
                                        )),
                                      ),
                                    )
                                  : Center(child: Text(noInterestFound)),
                            ),
                            Obx(
                              () => homeController.mediatList.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        _showMediaSelect(context);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 10),
                                        height: 30,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: AppColor.primarycolor)),
                                        child: Center(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Obx(
                                              () => Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 5),
                                                  child: Text(
                                                    homeController
                                                            .selectedMediaValuesToDisplay
                                                            .value
                                                            .isEmpty
                                                        ? "Media"
                                                        : homeController
                                                            .selectedMediaValuesToDisplay
                                                            .value,
                                                    // softWrap: true,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: AppColor.white,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Image.asset(
                                              'assets/dropdown.png',
                                              scale: 2.9,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            )
                                          ],
                                        )),
                                      ),
                                    )
                                  : Center(child: Text(noMediaFound)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: RefreshIndicator(
                            color: AppColor.primarycolor,
                            onRefresh: () {
                              return Future.delayed(
                                  Duration(
                                    seconds: 1,
                                  ), () {
                                homeController.articleList.clear();
                                homeController.pageNumber.value = 1;
                                homeController.getArticleList(
                                  context,
                                  homeController.pageNumber.value,
                                  10,
                                  homeController.searchController.text.toString(),
                                  categorys,
                                  mediatypes,
                                  interests,
                                );
                              });
                            },
                            child: SingleChildScrollView(
                              padding: EdgeInsets.only(bottom: 10),
                              controller: _scrollController,
                              child: Column(
                                children: [
                                  Obx(
                                    () => Container(
                                      margin: EdgeInsets.only(top: 15),
                                      child:
                                          homeController.articleList.isNotEmpty
                                              ? ListView.separated(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  shrinkWrap: true,
                                                  primary: false,
                                                  itemCount: homeController
                                                      .articleList.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          selectedIndex = index;
                                                        });
                                                        Get.toNamed(
                                                            "/ArticleVideoAudioDetails",
                                                            parameters: {
                                                              "index": index
                                                                  .toString(),
                                                              "articleId":
                                                                  homeController
                                                                      .articleList[
                                                                          index]
                                                                      .articleId
                                                                      .toString(),
                                                            });
                                                      },
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColor.black,
                                                        ),
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 5),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5.0,bottom: 5.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Flexible(
                                                                  flex: 2,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      if (homeController
                                                                              .articleList[index]
                                                                              .mediaSelection ==
                                                                          "Article") ...[
                                                                        Container(
                                                                          child:
                                                                              Text(
                                                                            "${homeController.articleList[index].articleName}",
                                                                            style: TextStyle(
                                                                                color: AppColor.white,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 14),
                                                                          ),
                                                                        ),
                                                                      ] else ...[
                                                                        Container(
                                                                          child:
                                                                              Text(
                                                                            "${homeController.articleList[index].articleName}",
                                                                            style: TextStyle(
                                                                                color: AppColor.white,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 14),
                                                                          ),
                                                                        ),
                                                                      ],

                                                                      if (homeController
                                                                              .articleList[index]
                                                                              .mediaSelection ==
                                                                          "Article") ...[
                                                                        Container(
                                                                          height:
                                                                              60,
                                                                          child:
                                                                              Text(
                                                                            "${homeController.articleList[index].articalShortDesc}",
                                                                            style: TextStyle(
                                                                                color: AppColor.textlight,
                                                                                fontSize: 14),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            maxLines:
                                                                                3,
                                                                          ),
                                                                        ),
                                                                      ] else ...[
                                                                        Container(
                                                                          height:
                                                                              60,
                                                                          width:
                                                                              200,
                                                                          child:
                                                                              Text(
                                                                            "${homeController.articleList[index].articalShortDesc}",
                                                                            style: TextStyle(
                                                                                color: AppColor.textlight,
                                                                                fontSize: 14),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            maxLines:
                                                                                3,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ],
                                                                  ),
                                                                ),

                                                                if (homeController
                                                                        .articleList[
                                                                            index]
                                                                        .mediaSelection ==
                                                                    "Article" || homeController
                                                                    .articleList[
                                                                index]
                                                                    .mediaSelection ==
                                                                    "Image") ...[
                                                                  if (homeController
                                                                      .articleList[
                                                                          index]
                                                                      .thumbnailImage!
                                                                      .isNotEmpty)
                                                                    Flexible(
                                                                      flex: 1,
                                                                      child: Stack(
                                                                        children: [
                                                                          Container(
                                                                            height:
                                                                                90,
                                                                            width:
                                                                                90,
                                                                            color:
                                                                                AppColor.grey,
                                                                            // decoration: BoxDecoration(
                                                                            //     border: Border.all(color: AppColor.grey)),
                                                                            child:
                                                                                Stack(
                                                                              children: [
                                                                                if (homeController.articleList[index].mediaSelection == "Article"||homeController
                                                                                    .articleList[
                                                                                index]
                                                                                    .mediaSelection ==
                                                                                    "Image")
                                                                                  if (homeController.articleList[index].thumbnailImage!.isNotEmpty)
                                                                                    Center(
                                                                                      child: Image.network(
                                                                                        homeController.articleList[index].thumbnailImage != null || homeController.articleList[index].image![0].imageurl == null ? "${homeController.articleList[index].thumbnailImage}" : "${homeController.articleList[index].image![0].imageurl}",
                                                                                        fit: BoxFit.cover,
                                                                                        height: 90,
                                                                                        width: 90,
                                                                                      ),
                                                                                    ),
                                                                                if (homeController.articleList[index].mediaSelection == "Video")
                                                                                  homeController.articleList[index].thumbnailImage != null
                                                                                      ? Image.network(
                                                                                          "${homeController.articleList[index].thumbnailImage}",
                                                                                          fit: BoxFit.cover,
                                                                                          height: 90,
                                                                                          width: 90,
                                                                                        )
                                                                                      : Center(
                                                                                          child: Icon(
                                                                                            Icons.video_settings,
                                                                                            color: AppColor.primarycolor,
                                                                                            size: 30,
                                                                                          ),
                                                                                        ),
                                                                                if (homeController.articleList[index].mediaSelection == "Audio")
                                                                                  homeController.articleList[index].thumbnailImage != null
                                                                                      ? Image.network(
                                                                                          "${homeController.articleList[index].thumbnailImage}",
                                                                                        )
                                                                                      : Center(
                                                                                          child: Image.asset(
                                                                                            "assets/audio.png",
                                                                                            scale: 2.9,
                                                                                          ),
                                                                                        ),
                                                                                if (homeController.articleList[index].mediaSelection == "Resource")
                                                                                  Center(
                                                                                    child: Image.asset(
                                                                                      "assets/docs.png",
                                                                                      scale: 20,
                                                                                      color: AppColor.primarycolor,
                                                                                    ),
                                                                                  ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                ] else ...[
                                                                  Flexible(
                                                                    flex: 1,
                                                                    child: Stack(
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              90,
                                                                          width:
                                                                              90,
                                                                          color: AppColor
                                                                              .grey,
                                                                          // decoration: BoxDecoration(
                                                                          //     border: Border.all(color: AppColor.grey)),
                                                                          child:
                                                                              Stack(
                                                                            children: [
                                                                              if (homeController.articleList[index].mediaSelection ==
                                                                                  "Article" ||homeController
                                                                                  .articleList[
                                                                              index]
                                                                                  .mediaSelection ==
                                                                                  "Image")
                                                                                if (homeController.articleList[index].image!.isNotEmpty || homeController.articleList[index].thumbnailImage!.isNotEmpty)
                                                                                  Center(
                                                                                    child: Image.network(
                                                                                      homeController.articleList[index].thumbnailImage != null || homeController.articleList[index].image![0].imageurl == null ? "${homeController.articleList[index].thumbnailImage}" : "${homeController.articleList[index].image![0].imageurl}",
                                                                                      fit: BoxFit.cover,
                                                                                      height: 90,
                                                                                      width: 90,
                                                                                    ),
                                                                                  ),
                                                                              if (homeController.articleList[index].mediaSelection == "Video" &&
                                                                                  homeController.articleList[index].thumbnailImage != null)
                                                                                homeController.articleList[index].thumbnailImage != null
                                                                                    ? Stack(
                                                                                        alignment: Alignment.center,
                                                                                        children: [
                                                                                          Image.network(
                                                                                            "${homeController.articleList[index].thumbnailImage}",
                                                                                            fit: BoxFit.cover,
                                                                                            height: 90,
                                                                                            width: 90,
                                                                                          ),
                                                                                          Center(
                                                                                            child: Container(
                                                                                              height: 28,
                                                                                              width: 28,
                                                                                              decoration: BoxDecoration(
                                                                                                color: AppColor.black.withOpacity(0.5),
                                                                                                borderRadius: BorderRadius.circular(15),
                                                                                              ),
                                                                                              child: Icon(
                                                                                                Icons.play_arrow,
                                                                                                color: AppColor.white,
                                                                                                size: 20,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    : Center(
                                                                                        child: Container(
                                                                                          height: 28,
                                                                                          width: 28,
                                                                                          decoration: BoxDecoration(
                                                                                            color: AppColor.black.withOpacity(0.5),
                                                                                            borderRadius: BorderRadius.circular(15),
                                                                                          ),
                                                                                          child: Icon(
                                                                                            Icons.video_settings,
                                                                                            color: AppColor.primarycolor,
                                                                                            size: 30,
                                                                                          ),
                                                                                        ),
                                                                                      ),

                                                                              if (homeController.articleList[index].mediaSelection == "Audio" &&
                                                                                  homeController.articleList[index].thumbnailImage != null)
                                                                                homeController.articleList[index].thumbnailImage != null
                                                                                    ? Stack(
                                                                                        alignment: Alignment.center,
                                                                                        children: [
                                                                                          Image.network(
                                                                                            "${homeController.articleList[index].thumbnailImage}",
                                                                                            fit: BoxFit.cover,
                                                                                            height: 90,
                                                                                            width: 90,
                                                                                          ),
                                                                                          Center(
                                                                                            child: Container(
                                                                                              height: 28,
                                                                                              width: 28,
                                                                                              decoration: BoxDecoration(
                                                                                                color: AppColor.black.withOpacity(0.5),
                                                                                                borderRadius: BorderRadius.circular(15),
                                                                                              ),
                                                                                              child: Image.asset(
                                                                                                "assets/audio.png",
                                                                                                scale: 2.9,
                                                                                                color: AppColor.white,
                                                                                                height: 10,
                                                                                                width: 10,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    : Center(
                                                                                        child: Container(
                                                                                          height: 28,
                                                                                          width: 28,
                                                                                          decoration: BoxDecoration(
                                                                                            color: AppColor.black.withOpacity(0.5),
                                                                                            borderRadius: BorderRadius.circular(15),
                                                                                          ),
                                                                                          child: Image.asset(
                                                                                            "assets/audio.png",
                                                                                            scale: 2.9,
                                                                                            color: AppColor.white,
                                                                                            height: 10,
                                                                                            width: 10,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                              if (homeController.articleList[index].mediaSelection == "Resource" &&
                                                                                  homeController.articleList[index].thumbnailImage != null)
                                                                                homeController.articleList[index].thumbnailImage != null
                                                                                    ? Stack(
                                                                                        alignment: Alignment.center,
                                                                                        children: [
                                                                                          Image.network(
                                                                                            "${homeController.articleList[index].thumbnailImage}",
                                                                                            fit: BoxFit.cover,
                                                                                            height: 90,
                                                                                            width: 90,
                                                                                          ),
                                                                                          Center(
                                                                                            child: Image.asset(
                                                                                              "assets/docs.png",
                                                                                              scale: 2.9,
                                                                                              color: AppColor.white,
                                                                                              height: 24,
                                                                                              width: 24,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    : Center(
                                                                                        child: Image.asset(
                                                                                          "assets/docs.png",
                                                                                          scale: 2.9,
                                                                                          color: AppColor.white,
                                                                                          height: 24,
                                                                                          width: 24,
                                                                                        ),
                                                                                      ),

                                                                              // Center(
                                                                              //     child: homeController
                                                                              //             .articleList[
                                                                              //                 index]
                                                                              //             .image!
                                                                              //             .isNotEmpty
                                                                              //         ? Image.network(
                                                                              //             "${homeController.articleList[index].image![0].imageurl}",
                                                                              //             fit: BoxFit.cover,
                                                                              //             height: 90,
                                                                              //             width: 90,
                                                                              //           )
                                                                              //         : homeController
                                                                              //                     .articleList[
                                                                              //                         index]
                                                                              //                     .image!
                                                                              //                     .length ==
                                                                              //                 2
                                                                              //             ? Image.network(
                                                                              //                 "${homeController.articleList[index].image![1].imageurl}",
                                                                              //                 fit: BoxFit
                                                                              //                     .cover,
                                                                              //                 height: 90,
                                                                              //                 width: 90,
                                                                              //               )
                                                                              //             : SizedBox()),
                                                                              // homeController
                                                                              //             .articleList[
                                                                              //                 index]
                                                                              //             .mediaSelection ==
                                                                              //         'Video'
                                                                              //     ? Center(
                                                                              //         child: Image.asset(
                                                                              //           "assets/circularplay.png",
                                                                              //           scale: 2.9,
                                                                              //         ),
                                                                              //       )
                                                                              //     : SizedBox(),
                                                                              // homeController
                                                                              //             .articleList[
                                                                              //                 index]
                                                                              //             .mediaSelection ==
                                                                              //         'Video'
                                                                              //     ? Center(
                                                                              //         child: Image.asset(
                                                                              //           "assets/circularplay2.png",
                                                                              //           scale: 2.9,
                                                                              //         ),
                                                                              //       )
                                                                              //     : SizedBox(),
                                                                              // homeController
                                                                              //             .articleList[
                                                                              //                 index]
                                                                              //             .mediaSelection ==
                                                                              //         'Video'
                                                                              //     ? Container(
                                                                              //         margin:
                                                                              //             EdgeInsets.only(
                                                                              //                 top: 2,
                                                                              //                 left: 2),
                                                                              //         child: Center(
                                                                              //           child: Image.asset(
                                                                              //             "assets/play.png",
                                                                              //             scale: 2.9,
                                                                              //           ),
                                                                              //         ),
                                                                              //       )
                                                                              //     : homeController
                                                                              //                 .articleList[
                                                                              //                     index]
                                                                              //                 .mediaSelection ==
                                                                              //             'Audio'
                                                                              //         ? Container(
                                                                              //             margin: EdgeInsets
                                                                              //                 .only(
                                                                              //                     top: 2,
                                                                              //                     left: 2),
                                                                              //             child: Center(
                                                                              //               child:
                                                                              //                   Image.asset(
                                                                              //                 "assets/audio.png",
                                                                              //                 scale: 2.9,
                                                                              //               ),
                                                                              //             ),
                                                                              //           ):homeController
                                                                              //                 .articleList[
                                                                              //                     index]
                                                                              //                 .mediaSelection ==
                                                                              //             'Resource'?Container(
                                                                              //             margin: EdgeInsets
                                                                              //                 .only(
                                                                              //                     top: 2,
                                                                              //                     left: 2),
                                                                              //             child: Center(
                                                                              //               child:
                                                                              //                   Image.asset(
                                                                              //                 "assets/docs.png",
                                                                              //                 scale: 30,color: AppColor.white,
                                                                              //               ),
                                                                              //             ),
                                                                              //           )
                                                                              //         : SizedBox()
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  separatorBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return SizedBox(
                                                      height: 8,
                                                    );
                                                  },
                                                )
                                              : Center(
                                                  child: Text(noArticleFound)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 7,
                )
                /* Obx(
              () => spotlightController.spotlightListingData.isNotEmpty
                  ? BottomViewWidget(
                      data: spotlightController.spotlightListingData[
                          spotlightController.randomNumber.value])
                  : Container(),
            ),*/
              ],
            ),
          )),
        );
      },
    );
  }

  void _showCategorySelect(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return Container(
          margin: EdgeInsets.only(
              right: 0,
              top: MediaQuery.of(context).size.height / 4.5,
              bottom: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColor.loginappbar,
          ),
          alignment: Alignment.topRight,
          child: MultiSelectDialog(
            title: Text(''),
            backgroundColor: AppColor.black,
            // separateSelectedItems: true,
            checkColor: AppColor.black,
            selectedColor: AppColor.primarycolor,
            unselectedColor: AppColor.primarycolor,
            itemsTextStyle: TextStyle(color: AppColor.white),
            selectedItemsTextStyle: TextStyle(color: AppColor.primarycolor),
            items: homeController.CategoryTextList.map(
                (element) => MultiSelectItem(element, element)).toList(),
            initialValue: homeController.CategorySelectedServices.value,
            onConfirm: (values) {
              homeController.CategorySelectedServices.value = values;
              homeController.selectedCategoryValuesToDisplay.value = "";
              values.forEach((element) {
                print("selected category : $element");
                homeController.selectedCategoryValuesToDisplay.value +=
                    element + ", ";
              });
              print('object${homeController.CategorySelectedServices.value}');

              if (homeController
                  .selectedCategoryValuesToDisplay.value.isNotEmpty) {
                homeController.selectedCategoryValuesToDisplay.value =
                    homeController.selectedCategoryValuesToDisplay.value
                        .replaceRange(
                      homeController
                          .selectedCategoryValuesToDisplay.value.length -
                      2,
                      homeController.selectedCategoryValuesToDisplay.value.length,
                  "",
                );

                List<String> ids = [];
                homeController.categorieList.forEach((element) {
                  homeController.CategorySelectedServices.forEach(
                      (ownerJobType) {
                    if (ownerJobType == element.categoryName) {
                      ids.add(element.categoryId.toString());
                    }
                  });
                });
                setState(() {
                  categorys = ids.join(',');
                });
                homeController.selectedCategoryValuesToDisplay.value;
                homeController.articleList.clear();
                homeController.pageNumber.value = 1;
                homeController.getArticleList(
                  context,
                  homeController.pageNumber.value,
                  10,
                  homeController.searchController.text.toString(),
                  categorys,
                  mediatypes,
                  interests,
                );
                print(
                    'object${homeController.CategorySelectedServices.value}');
              } else {
                setState(() {
                  categorys = '';
                });
                homeController.selectedCategoryValuesToDisplay.value;
                homeController.articleList.clear();
                homeController.pageNumber.value = 1;
                homeController.getArticleList(
                  context,
                  homeController.pageNumber.value,
                  10,
                  homeController.searchController.text.toString(),
                  categorys,
                  mediatypes,
                  interests,
                );
                print(
                    'object${homeController.IntersetSelectedServices.value}');
              }
            },
          ),
        );
      },
    );
  }

  void _showInterestSelect(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return Container(
          margin: EdgeInsets.only(
              right: 0,
              top: MediaQuery.of(context).size.height / 4.5,
              bottom: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColor.loginappbar,
          ),
          alignment: Alignment.topRight,
          child: MultiSelectDialog(
            title: Text(''),
            backgroundColor: AppColor.black,
            //separateSelectedItems: true,
            checkColor: AppColor.black,
            selectedColor: AppColor.primarycolor,
            unselectedColor: AppColor.primarycolor,
            itemsTextStyle: TextStyle(color: AppColor.white),
            selectedItemsTextStyle: TextStyle(color: AppColor.primarycolor),
            items: homeController.IntersetTextList.map(
                (element) => MultiSelectItem(element, element)).toList(),
            initialValue: homeController.IntersetSelectedServices.value,
            onConfirm: (values) {
              homeController.IntersetSelectedServices.value = values;
              homeController.selectedIntersetValuesToDisplay.value = "";
              values.forEach((element) {
                print("selected interest : $element");
                homeController.selectedIntersetValuesToDisplay.value +=
                    element + ", ";
              });
              print('object${homeController.IntersetSelectedServices.value}');
              if (homeController
                  .selectedIntersetValuesToDisplay.value.isNotEmpty) {
                homeController.selectedIntersetValuesToDisplay.value =
                    homeController.selectedIntersetValuesToDisplay.value
                        .replaceRange(
                      homeController
                          .selectedIntersetValuesToDisplay.value.length -
                      2,
                      homeController.selectedIntersetValuesToDisplay.value.length,
                  "",
                );

                List<String> ids = [];
                homeController.interestList.forEach((element) {
                  homeController.IntersetSelectedServices.forEach(
                      (ownerJobType) {
                    if (ownerJobType == element.interestName) {
                      ids.add(element.interestId.toString());
                    }
                  });
                });
                setState(() {
                  interests = ids.join(',');
                });
                homeController.selectedIntersetValuesToDisplay.value;
                homeController.articleList.clear();
                homeController.pageNumber.value = 1;
                homeController.getArticleList(
                  context,
                  homeController.pageNumber.value,
                  10,
                  homeController.searchController.text.toString(),
                  categorys,
                  mediatypes,
                  interests,
                );
                print(
                    'object${homeController.IntersetSelectedServices.value}');
              } else {
                setState(() {
                  interests = '';
                });
                homeController.selectedIntersetValuesToDisplay.value;
                homeController.articleList.clear();
                homeController.pageNumber.value = 1;
                homeController.getArticleList(
                  context,
                  homeController.pageNumber.value,
                  10,
                  homeController.searchController.text.toString(),
                  categorys,
                  mediatypes,
                  interests,
                );
                print(
                    'object${homeController.IntersetSelectedServices.value}');
              }
            },
          ),
        );
      },
    );
  }

  void _showMediaSelect(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return Container(
          margin: EdgeInsets.only(
              right: 0,
              top: MediaQuery.of(context).size.height / 4.5,
              bottom: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColor.loginappbar,
          ),
          alignment: Alignment.topRight,
          child: MultiSelectDialog(
            title: Text(''),
            backgroundColor: AppColor.black,
            //separateSelectedItems: true,
            checkColor: AppColor.black,
            selectedColor: AppColor.primarycolor,
            unselectedColor: AppColor.primarycolor,
            itemsTextStyle: TextStyle(color: AppColor.white),
            selectedItemsTextStyle: TextStyle(color: AppColor.primarycolor),
            items: homeController.MediaTextList.map(
                (element) => MultiSelectItem(element, element)).toList(),
            initialValue: homeController.MediaSelectedServices.value,
            onConfirm: (values) {
              homeController.MediaSelectedServices.value = values;
              homeController.selectedMediaValuesToDisplay.value = "";
              values.forEach((element) {
                print("selected media type : $element");
                homeController.selectedMediaValuesToDisplay.value +=
                    element + ", ";
              });
              print('object${homeController.MediaSelectedServices.value}');
              if (homeController
                  .selectedMediaValuesToDisplay.value.isNotEmpty) {
                homeController.selectedMediaValuesToDisplay.value =
                    homeController.selectedMediaValuesToDisplay.value
                        .replaceRange(
                      homeController.selectedMediaValuesToDisplay.value.length -
                      2,
                      homeController.selectedMediaValuesToDisplay.value.length,
                  "",
                );

                List<String> ids = [];
                homeController.mediatList.forEach((element) {
                  homeController.MediaSelectedServices.forEach(
                      (ownerJobType) {
                    if (ownerJobType == element.mediaName) {
                      ids.add(element.mediaId.toString());
                    }
                  });
                });
                setState(() {
                  mediatypes = ids.join(',');
                });
                homeController.selectedMediaValuesToDisplay.value;
                homeController.articleList.clear();
                homeController.pageNumber.value = 1;
                homeController.getArticleList(
                  context,
                  homeController.pageNumber.value,
                  10,
                  homeController.searchController.text.toString(),
                  categorys,
                  mediatypes,
                  interests,
                );
                print('object${homeController.MediaSelectedServices.value}');
              } else {
                setState(() {
                  mediatypes = '';
                });
                homeController.selectedMediaValuesToDisplay.value;
                homeController.articleList.clear();
                homeController.pageNumber.value = 1;
                homeController.getArticleList(
                  context,
                  homeController.pageNumber.value,
                  10,
                  homeController.searchController.text.toString(),
                  categorys,
                  mediatypes,
                  interests,
                );
                print('object${homeController.MediaSelectedServices.value}');
              }
            },
          ),
        );
      },
    );
  }

  Future<void> setChatVisibility() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int id = pref.getInt('subscription_id') ?? 0;
    setState(() {
      isChat = id == 3 || id == 4 || id == 5;
    });
    FirebaseFirestore.instance
        .collection(FirestoreConstants.pathUserCollection)
        .doc(GlobalData().userId.toString())
        .update({FirestoreConstants.isOnline: 1});
    // GlobalData().retrieveLoggedInUserDetail();
  }

  Future<void> setEventVisibility() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int id = pref.getInt('subscription_id') ?? 0;
    setState(() {
      isEvent = id == 4 || id == 5;
    });
    FirebaseFirestore.instance
        .collection(FirestoreConstants.pathUserCollection)
        .doc(GlobalData().userId.toString())
        .update({FirestoreConstants.isOnline: 1});
    // GlobalData().retrieveLoggedInUserDetail();
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

  setUnreadNotiCount(){
    return Obx(() => notificationController.notificationCount.value == 0?
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
