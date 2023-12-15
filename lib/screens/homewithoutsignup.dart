import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/controllers/editprofileController.dart';
import 'package:luxury_council/controllers/homeController.dart';
import 'package:luxury_council/controllers/loginController.dart';
import 'package:luxury_council/screens/custom_alert.dart';
import 'package:luxury_council/widgets/drawer.dart';
import 'package:luxury_council/widgets/local_video_player.dart';
import 'package:luxury_council/widgets/multi_select.dart';
import 'package:luxury_council/widgets/video_player_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../config/prefrance.dart';
import '../constance/global_data.dart';
import '../controllers/filterController.dart';
import '../controllers/spotlight_listing_controller.dart';
import '../strings.dart';
import 'bottom_view_widget.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class HomeWithoutSignUp extends StatefulWidget {
  const HomeWithoutSignUp({super.key});

  @override
  State<HomeWithoutSignUp> createState() => _HomeWithoutSignUpState();
}

class _HomeWithoutSignUpState extends State<HomeWithoutSignUp> {
  final HomeController homeController = Get.put(HomeController());
  final LoginController loginController = Get.put(LoginController());
  final FilterController filterController = Get.put(FilterController());
  final SpotlightListingController spotlightController = Get.put(SpotlightListingController());
  final EditProfileController editProfileController =
  Get.put(EditProfileController());
  late ScrollController _scrollController;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _key1 = UniqueKey();
  List<String> _selectedItems = [];
  late YoutubePlayerController youtubeController1;

  int _pageNumber = 1;
  int limit = 10;
  int subscriptionid = GlobalData().subscriptionId;
  TextEditingController searchController = TextEditingController();
  String categorys = '';
  String mediatypes = '';
  bool isFullscreen = false;
  bool isPlaying = true;

  @override
  void initState() {
    spotlightController.getSpotlightListingWithOutPagination(context);
    homeController.getNonSubscribeArticleList(context, homeController.pageNumber.value, limit,  searchController.text.toString(), categorys, mediatypes, "");
    //editProfileController.getprofile(context);
    filterController.getCategoriesList(context, null, 0, 100);
    filterController.getMediaTypeList(
      context,
      null,
    );
    FirebaseMessaging.instance.getToken().then((value) {
      if((value?? '').isNotEmpty){
        homeController.manageDeviceToken(context,value ?? '');
      }
    });
    checkFirst();
    super.initState();
    _scrollController = ScrollController();
  }
  checkFirst() async {
    await filterController.getProfileIntersetList(context, null, 0, 100);
    await editProfileController.getprofile(context);
  }

  @override
  void dispose() {
   // ytbPlayerController.close();
    super.dispose();

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

  void listener() {
    if (mounted && youtubeController1.value.isFullScreen) {
      isFullscreen = false;
      print('fullscreen>> false>>');
    }else{
      print('fullscreen>>>  true>');
      isFullscreen = true;
    }
  }

  bool startedPlaying = false;

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() async {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent ) {
          print('total page>total_page>${homeController.total_page.value}>> ${homeController.pageNumber.value}');
          if (homeController.noarticlelistresponce.isTrue) {
            homeController.noarticlelistresponce.value = false;
            print('check page>>${homeController.pageNumber.value} >>> ${homeController.noarticlelistresponce.value}');
            if((homeController.total_page.value) > homeController.pageNumber.value) {
              setState(() {
                homeController.pageNumber.value = homeController.pageNumber.value + 1;
              });
              print('check page>>${homeController.pageNumber.value} >>> ${homeController.total_page.value}');
              await  homeController.getNonSubscribeArticleList(
                  context,  homeController.pageNumber.value, limit, searchController.text.toString(), categorys, mediatypes, "");
            }
          }
        }
      }
    /*  if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (homeController.noarticlelistresponce.isTrue) {
            setState(() {
              homeController.pageNumber.value =  homeController.pageNumber.value + 1;
            });
            print('object = ' +  homeController.pageNumber.value.toString());
            homeController.noarticlelistresponce.value = false;
            homeController.getNonSubscribeArticleList(
                context,  homeController.pageNumber.value, limit, searchController.text.toString(), categorys, mediatypes, "");
          }

        }
      }*/
    });
    return Scaffold(
      backgroundColor: AppColor.loginappbar,
      key: _key,
      appBar: AppBar(
        leading:Container(
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
                  margin: EdgeInsets.only(right: 15),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      "assets/profile.png",
                      scale: 2.9,
                    ),
                  ),
                ),
              ),
              /*  Container(
                margin: EdgeInsets.only(right: 16),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(
                    "assets/notification.png",
                    scale: 2.9,
                  ),
                ),
              ),*/
              // Container(
              //   margin: EdgeInsets.only(right: 8),
              //   child: Padding(
              //     padding: const EdgeInsets.all(4.0),
              //     child: Image.asset(
              //       "assets/message.png",
              //       scale: 2.9,
              //     ),
              //   ),
              // ),
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
      drawerEnableOpenDragGesture: false,
      drawer: DrawerWidget2(),
      /*floatingActionButton: GlobalData().spotlightListing.isNotEmpty
          ? Padding(
        padding: EdgeInsets.only(bottom: 0,),
        child:  Obx(() =>
        spotlightController.spotlightListingData.isNotEmpty?
        BottomViewWidget(data : spotlightController.spotlightListingData[spotlightController.randomNumber.value]): Container(),
        ),
      )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,*/
      body: SafeArea(
          child:   Obx(() =>
          (homeController.nosubsarticleList.isNotEmpty || homeController.nosubsvideoList.isNotEmpty) ?
          Column(
            children: [
              Container(
                height: 40,
                margin: EdgeInsets.only(top: 15,left: 15,right: 15),
                child: TextFormField(
                  controller: searchController,
                  style: TextStyle(fontSize: 14, color: AppColor.white),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColor.black,
                      contentPadding: EdgeInsets.all(8),
                      hintText: 'Search Article...',
                      prefixIcon: Image.asset(
                        'assets/search.png',
                        scale: 2.9,
                      ),
                      hintStyle:
                      TextStyle(color: Colors.white, fontSize: 14),
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
                    if (searchController.text.toString() != '') {
                      homeController.nosubsarticleList.clear();
                      homeController.pageNumber.value = 1;
                      homeController.getNonSubscribeArticleList(context, homeController.pageNumber.value, 10,  searchController.text.toString(), categorys, mediatypes, "");
                    } else {
                      homeController.nosubsarticleList.clear();
                      homeController.pageNumber.value = 1;
                      homeController.getNonSubscribeArticleList(context, homeController.pageNumber.value, 10,  searchController.text.toString(), categorys, mediatypes, "");
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                          () => filterController.categorieList.isNotEmpty
                          ? GestureDetector(
                        onTap: () {
                          _showCategorySelect(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
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
                                            horizontal: 5, vertical: 5),
                                        child: Text(
                                          filterController
                                              .selectedCategoryValuesToDisplay
                                              .value
                                              .isEmpty
                                              ? "Category"
                                              : filterController
                                              .selectedCategoryValuesToDisplay
                                              .value,
                                          // softWrap: true,
                                          overflow: TextOverflow.ellipsis,
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
                          () => filterController.mediatList.isNotEmpty
                          ? GestureDetector(
                        onTap: () {
                          _showMediaSelect(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
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
                                            horizontal: 5, vertical: 5),
                                        child: Text(
                                          filterController
                                              .selectedMediaValuesToDisplay
                                              .value
                                              .isEmpty
                                              ? "Media"
                                              : filterController
                                              .selectedMediaValuesToDisplay
                                              .value,
                                          // softWrap: true,
                                          overflow: TextOverflow.ellipsis,
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
              ),
              Expanded(
                child: RefreshIndicator(
                  color: AppColor.primarycolor,
                  onRefresh: () {
                    return Future.delayed(
                        Duration(
                          seconds: 1,
                        ), () {
                      homeController.nosubsarticleList.clear();
                      homeController.nosubsvideoList.clear();
                      homeController.pageNumber.value = 1;
                      homeController.getNonSubscribeArticleList(
                          context,homeController.pageNumber.value, limit,  searchController.text.toString(), categorys, mediatypes, "");
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child:(homeController.nosubsarticleList.isNotEmpty || homeController.nosubsvideoList.isNotEmpty) ?
                        Column(
                          children: [
                            Container(
                                margin: EdgeInsets.only(top: 15),
                                child: ListView.separated(
                                  // controller: _scrollController,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: homeController.nosubsvideoList.length,
                                  itemBuilder: (context, index) {
                                    print('index>> $index >> ${homeController.nosubsvideoList[index].video}');
                                    print(index);
                                   /* ChewieController _chewieController =
                                    ChewieController(
                                      videoPlayerController:
                                      VideoPlayerController.network(
                                          '${homeController.nosubsvideoList[index].video}',
                                          videoPlayerOptions: VideoPlayerOptions(
                                              allowBackgroundPlayback: false,
                                              mixWithOthers: true)),
                                      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp, ],
                                      deviceOrientationsOnEnterFullScreen: [DeviceOrientation.landscapeLeft,
                                        DeviceOrientation.landscapeRight,],
                                      aspectRatio: 16 / 9,
                                      allowMuting: true,
                                      progressIndicatorDelay: null,
                                    );*/

                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColor.grey, width: 1),
                                        color: AppColor.black,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          isYouTubeLink(homeController.nosubsvideoList[index].video.toString())
                                          // (homeController.nosubsvideoList[index].video.toString().startsWith('https://www.youtube.com/') || homeController.nosubsvideoList[0].video.toString().startsWith('www.youtube.com/'))
                                               ? youtubeWidget(url:YoutubePlayer.convertUrlToId(homeController.nosubsvideoList[index].video.toString()))
                                         : LocalVideoPlayer(url: homeController.nosubsvideoList[index].video.toString()),
                                         // buildLocalVideo(_chewieController),
                                          Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 10),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 8.0),
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
                                                      "${homeController.nosubsvideoList[index].content ?? ''}",
                                                    ),
                                                  //  HtmlWidget(homeController.nosubsvideoList[index].content ?? '',textStyle: TextStyle(color: AppColor.white, fontSize: 14)),
                                                  ),
                                                  /* Text(
                                                      "${homeController.nosubsvideoList[index].content}",
                                                      style: TextStyle(
                                                          color: AppColor.textlight,
                                                          fontSize: 14),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),*/
                                                ],
                                              ))
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      height: 8,
                                    );
                                  },
                                )
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              child: ListView.separated(
                                scrollDirection:
                                Axis.vertical,
                                shrinkWrap: true,
                                primary: false,
                                itemCount: homeController.nosubsarticleList.length,
                                itemBuilder:
                                    (context, index) {
                                  return GestureDetector(
                                    onTap: (){
                                      CustomAlert.showAlert(
                                          context, 'Please subscribe to access this article',
                                          title: 'Luxury Council', btnFirst: 'Ok', handler: (int index) {
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
                                                    if (homeController.nosubsarticleList[index]
                                                        .mediaSelection ==
                                                        "Article") ...[
                                                      Container(
                                                        child:
                                                        Text(
                                                          "${homeController.nosubsarticleList[index].articleName}",
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
                                                          "${homeController.nosubsarticleList[index].articleName}",
                                                          style: TextStyle(
                                                              color: AppColor.white,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 14),
                                                        ),
                                                      ),
                                                    ],

                                                    if (homeController.nosubsarticleList[index] ==
                                                        "Article") ...[
                                                      Container(
                                                        height:
                                                        60,
                                                        child:
                                                        Text(
                                                          "${homeController.nosubsarticleList[index].articalShortDesc}",
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
                                                          "${homeController.nosubsarticleList[index].articalShortDesc}",
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

                                              if (homeController.nosubsarticleList[index]
                                                  .mediaSelection ==
                                                  "Article" || homeController.nosubsarticleList[index]
                                                  .mediaSelection ==
                                                  "Image") ...[
                                                if (homeController.nosubsarticleList[index]
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
                                                              if (homeController.nosubsarticleList[index].mediaSelection == "Article"||homeController.nosubsarticleList[index]
                                                                  .mediaSelection ==
                                                                  "Image")
                                                                if (homeController.nosubsarticleList[index].thumbnailImage!.isNotEmpty)
                                                                  Center(
                                                                    child: Image.network(
                                                                      homeController.nosubsarticleList[index].thumbnailImage != null || homeController.nosubsarticleList[index].image![0].imageurl == null ? "${homeController.nosubsarticleList[index].thumbnailImage}" : "${homeController.nosubsarticleList[index].image![0].imageurl}",
                                                                      fit: BoxFit.cover,
                                                                      height: 90,
                                                                      width: 90,
                                                                    ),
                                                                  ),
                                                              if (homeController.nosubsarticleList[index].mediaSelection == "Video")
                                                                homeController.nosubsarticleList[index].thumbnailImage != null
                                                                    ? Image.network(
                                                                  "${homeController.nosubsarticleList[index].thumbnailImage}",
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
                                                              if (homeController.nosubsarticleList[index].mediaSelection == "Audio")
                                                                homeController.nosubsarticleList[index].thumbnailImage != null
                                                                    ? Image.network(
                                                                  "${homeController.nosubsarticleList[index].thumbnailImage}",
                                                                )
                                                                    : Center(
                                                                  child: Image.asset(
                                                                    "assets/audio.png",
                                                                    scale: 2.9,
                                                                  ),
                                                                ),
                                                              if (homeController.nosubsarticleList[index].mediaSelection == "Resource")
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
                                                            if (homeController.nosubsarticleList[index].mediaSelection ==
                                                                "Article" ||homeController.nosubsarticleList[index]
                                                                .mediaSelection ==
                                                                "Image")
                                                              if (homeController.nosubsarticleList[index].image!.isNotEmpty || homeController.nosubsarticleList[index].thumbnailImage!.isNotEmpty)
                                                                Center(
                                                                  child: Image.network(
                                                                    homeController.nosubsarticleList[index].thumbnailImage != null || homeController.nosubsarticleList[index].image![0].imageurl == null ? "${homeController.nosubsarticleList[index].thumbnailImage}" : "${homeController.nosubsarticleList[index].image![0].imageurl}",
                                                                    fit: BoxFit.cover,
                                                                    height: 90,
                                                                    width: 90,
                                                                  ),
                                                                ),
                                                            if (homeController.nosubsarticleList[index].mediaSelection == "Video" &&
                                                                homeController.nosubsarticleList[index].thumbnailImage != null)
                                                              homeController.nosubsarticleList[index].thumbnailImage != null
                                                                  ? Stack(
                                                                alignment: Alignment.center,
                                                                children: [
                                                                  Image.network(
                                                                    "${homeController.nosubsarticleList[index].thumbnailImage}",
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

                                                            if (homeController.nosubsarticleList[index].mediaSelection == "Audio" &&
                                                                homeController.nosubsarticleList[index].thumbnailImage != null)
                                                              homeController.nosubsarticleList[index].thumbnailImage != null
                                                                  ? Stack(
                                                                alignment: Alignment.center,
                                                                children: [
                                                                  Image.network(
                                                                    "${homeController.nosubsarticleList[index].thumbnailImage}",
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
                                                            if (homeController.nosubsarticleList[index].mediaSelection == "Resource" &&
                                                                homeController.nosubsarticleList[index].thumbnailImage != null)
                                                              homeController.nosubsarticleList[index].thumbnailImage != null
                                                                  ? Stack(
                                                                alignment: Alignment.center,
                                                                children: [
                                                                  Image.network(
                                                                    "${homeController.nosubsarticleList[index].thumbnailImage}",
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

                         /*     ListView.separated(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                primary: false,
                                itemCount: homeController.nosubsarticleList.length,
                                itemBuilder: (context, index) {
                                  print(homeController.nosubsarticleList[index].articleName);
                                  return GestureDetector(
                                    onTap: (){
                                      CustomAlert.showAlert(
                                          context, 'Please subscribe to access this article',
                                          title: 'Luxury Council', btnFirst: 'Ok', handler: (int index) {
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        border:
                                        Border.all(color: AppColor.grey, width: 1),
                                        color: AppColor.grey,
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 3.0, color: AppColor.black),
                                        ],
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              flex: 2,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      "${homeController.nosubsarticleList[index].articleName}",
                                                      style: TextStyle(
                                                          color: AppColor.white,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      "${homeController.nosubsarticleList[index].articalShortDesc}",
                                                      style: TextStyle(
                                                          color: AppColor.textlight,
                                                          fontSize: 14),
                                                      maxLines: 5,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (homeController.nosubsarticleList[index]
                                                .image!.isNotEmpty)
                                              Flexible(
                                                flex: 1,
                                                child: Container(
                                                  height: 90,
                                                  width: 90,
                                                  decoration: BoxDecoration(
                                                      color: AppColor.primarycolor,
                                                      border: Border.all(
                                                          color: AppColor.grey)),
                                                  child: Stack(
                                                    children: [
                                                      Center(
                                                          child: homeController
                                                              .nosubsarticleList[
                                                          index]
                                                              .image!
                                                              .isNotEmpty
                                                              ? Image.network(
                                                            "${homeController.nosubsarticleList[index].image![0].imageurl}",
                                                            fit: BoxFit.cover,
                                                            height: 90,
                                                            width: 90,
                                                          )
                                                              : homeController
                                                              .nosubsarticleList[
                                                          index]
                                                              .image!
                                                              .length ==
                                                              2
                                                              ? Image.network(
                                                            "${homeController.nosubsarticleList[index].image![1].imageurl}",
                                                            fit: BoxFit.cover,
                                                            height: 90,
                                                            width: 90,
                                                          )
                                                              : SizedBox()),
                                                      homeController
                                                          .nosubsarticleList[
                                                      index]
                                                          .mediaSelection ==
                                                          'Video'
                                                          ? Center(
                                                        child: Image.asset(
                                                          "assets/circularplay.png",
                                                          scale: 2.9,
                                                        ),
                                                      )
                                                          : SizedBox(),
                                                      homeController
                                                          .nosubsarticleList[
                                                      index]
                                                          .mediaSelection ==
                                                          'Video'
                                                          ? Center(
                                                        child: Image.asset(
                                                          "assets/circularplay2.png",
                                                          scale: 2.9,
                                                        ),
                                                      )
                                                          : SizedBox(),
                                                      homeController
                                                          .nosubsarticleList[
                                                      index]
                                                          .mediaSelection ==
                                                          'Video'
                                                          ? Container(
                                                        margin: EdgeInsets.only(
                                                            top: 2, left: 2),
                                                        child: Center(
                                                          child: Image.asset(
                                                            "assets/play.png",
                                                            scale: 2.9,
                                                          ),
                                                        ),
                                                      )
                                                          : homeController
                                                          .nosubsarticleList[
                                                      index]
                                                          .mediaSelection ==
                                                          'Audio'
                                                          ? Container(
                                                        margin:
                                                        EdgeInsets.only(
                                                            top: 2,
                                                            left: 2),
                                                        child: Center(
                                                          child: Image.asset(
                                                            "assets/audio.png",
                                                            scale: 2.9,
                                                          ),
                                                        ),
                                                      )
                                                          : homeController
                                                          .nosubsarticleList[
                                                      index]
                                                          .mediaSelection ==
                                                          'Resource'
                                                          ? Container(
                                                        margin: EdgeInsets
                                                            .only(
                                                            top: 2,
                                                            left: 2),
                                                        child: Center(
                                                          child:
                                                          Image.asset(
                                                            "assets/docs.png",
                                                            scale: 30,
                                                            color: AppColor
                                                                .white,
                                                          ),
                                                        ),
                                                      )
                                                          : SizedBox()
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (BuildContext context, int index) {
                                  return SizedBox(
                                    height: 8,
                                  );
                                },
                              ),*/
                            ),
                            // Container(
                            //   margin: EdgeInsets.only(top: 15),
                            //   child: ListView.separated(
                            //     scrollDirection: Axis.vertical,
                            //     shrinkWrap: true,
                            //     primary: false,
                            //     itemCount: 1,
                            //     itemBuilder: (context, index) {
                            //       return Container(
                            //         width: MediaQuery.of(context).size.width,
                            //         decoration: BoxDecoration(
                            //           color: AppColor.black,
                            //           boxShadow: [
                            //             BoxShadow(blurRadius: 3.0, color: AppColor.black),
                            //           ],
                            //         ),
                            //         child: Container(
                            //           margin:
                            //               EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            //           child: Row(
                            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //             crossAxisAlignment: CrossAxisAlignment.start,
                            //             children: [
                            //               Column(
                            //                 mainAxisAlignment: MainAxisAlignment.start,
                            //                 crossAxisAlignment: CrossAxisAlignment.start,
                            //                 children: [
                            //                   Container(
                            //                     width: 200,
                            //                     child: Text(
                            //                       '3 KEY TAKE-AWAYS ABOUT DIGITAL MARKETING FROM TOP BRANDS',
                            //                       style: TextStyle(
                            //                           color: AppColor.white,
                            //                           fontWeight: FontWeight.bold,
                            //                           fontSize: 10),
                            //                     ),
                            //                   ),
                            //                   Container(
                            //                     width: 200,
                            //                     child: Text(
                            //                       'Top-performing marketers — those ranked “Genius” on the Gartner Digital IQ index — offer critical lessons to use in email, on social, in advertising and on other channels. Contributor: Jackie Wiles',
                            //                       style: TextStyle(
                            //                           color: AppColor.textlight,
                            //                           fontSize: 9),
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //               Container(
                            //                 height: 90,
                            //                 width: 90,
                            //                 child: Center(
                            //                   child: Image.asset(
                            //                     "assets/homeimage2.png",
                            //                     fit: BoxFit.fitWidth,
                            //                   ),
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //     separatorBuilder: (BuildContext context, int index) {
                            //       return SizedBox(
                            //         height: 8,
                            //       );
                            //     },
                            //   ),
                            // ),
                            // Container(
                            //   margin: EdgeInsets.only(top: 15),
                            //   child: ListView.separated(
                            //     scrollDirection: Axis.vertical,
                            //     shrinkWrap: true,
                            //     primary: false,
                            //     itemCount: 1,
                            //     itemBuilder: (context, index) {
                            //       return Container(
                            //         width: MediaQuery.of(context).size.width,
                            //         decoration: BoxDecoration(
                            //           border: Border.all(color: AppColor.grey, width: 1),
                            //           color: AppColor.grey,
                            //           boxShadow: [
                            //             BoxShadow(blurRadius: 3.0, color: AppColor.black),
                            //           ],
                            //         ),
                            //         child: Container(
                            //           margin:
                            //               EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            //           child: Column(
                            //             mainAxisAlignment: MainAxisAlignment.start,
                            //             crossAxisAlignment: CrossAxisAlignment.start,
                            //             children: [
                            //               Container(
                            //                 child: Text(
                            //                   '3 KEY TAKE-AWAYS ABOUT DIGITAL MARKETING FROM TOP BRANDS',
                            //                   style: TextStyle(
                            //                       color: AppColor.white,
                            //                       fontWeight: FontWeight.bold,
                            //                       fontSize: 10),
                            //                 ),
                            //               ),
                            //               Container(
                            //                 child: Text(
                            //                   'Top-performing marketers — those ranked “Genius” on the Gartner Digital IQ index — offer critical lessons to use in email, on social, in advertising and on other channels. Contributor: Jackie Wiles',
                            //                   style: TextStyle(
                            //                       color: AppColor.textlight,
                            //                       fontSize: 9),
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //     separatorBuilder: (BuildContext context, int index) {
                            //       return SizedBox(
                            //         height: 8,
                            //       );
                            //     },
                            //   ),
                            // ),
                            SizedBox(
                              height: 25,
                            ),
                          ],
                        ): Center(
                          child: Text(
                            noArticleFound,
                            style: TextStyle(color: AppColor.white),
                          ),
                        ) ,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed("/Subscription");
                },
                child: Container(
                  margin: EdgeInsets.only(left:15, right: 15, top: 10,bottom: 10),
                  height: 35,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColor.primarycolor),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Subscribe to view more',
                          style: TextStyle(color: AppColor.black, fontSize: 14),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Image.asset(
                          'assets/doublegreater.png',
                          scale: 2.9,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Obx(() =>
              spotlightController.spotlightListingData.isNotEmpty?
              BottomViewWidget(data : spotlightController.spotlightListingData[spotlightController.randomNumber.value]): Container(),
              ),
            ],
          ):
          Container()
          )
      ),
    );
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

  Widget buildYouTubeVideo(String url) {
    String videoId = YoutubePlayer.convertUrlToId(url)!;
    return AspectRatio(
      aspectRatio: !isFullscreen? 16 / 9 : 2.2,
      child: YoutubePlayer(
    controller: YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(autoPlay: false),
    ),
      showVideoProgressIndicator: true,
      onReady: () {
        youtubeController1
            .addListener(listener);
      },
    ),
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

  void getData() async{
    await GlobalData().retrieveLoggedInUserDetail();
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
            items: filterController.MediaTextList.map(
                    (element) => MultiSelectItem(element, element)).toList(),
            initialValue: filterController.MediaSelectedServices.value,
            onConfirm: (values) {
              filterController.MediaSelectedServices.value = values;
              filterController.selectedMediaValuesToDisplay.value = "";
              values.forEach((element) {
                print("selected media type : $element");
                filterController.selectedMediaValuesToDisplay.value +=
                    element + ", ";
              });
              print('object${filterController.MediaSelectedServices.value}');
              if (filterController
                  .selectedMediaValuesToDisplay.value.isNotEmpty) {
                filterController.selectedMediaValuesToDisplay.value =
                    filterController.selectedMediaValuesToDisplay.value
                        .replaceRange(
                      filterController.selectedMediaValuesToDisplay.value.length -
                          2,
                      filterController.selectedMediaValuesToDisplay.value.length,
                      "",
                    );

                List<String> ids = [];
                filterController.mediatList.forEach((element) {
                  filterController.MediaSelectedServices.forEach(
                          (ownerJobType) {
                        if (ownerJobType == element.mediaName) {
                          ids.add(element.mediaId.toString());
                        }
                      });
                });
                setState(() {
                  mediatypes = ids.join(',');
                });
                filterController.selectedMediaValuesToDisplay.value;
                homeController.nosubsarticleList.clear();
                homeController.pageNumber.value = 1;
                homeController.getNonSubscribeArticleList(context, homeController.pageNumber.value, 10,  searchController.text.toString(), categorys, mediatypes, "");
                print('object${filterController.MediaSelectedServices.value}');
              } else {
                setState(() {
                  mediatypes = '';
                });
                filterController.selectedMediaValuesToDisplay.value;
                homeController.nosubsarticleList.clear();
                homeController.pageNumber.value = 1;
                homeController.getNonSubscribeArticleList(context, homeController.pageNumber.value, 10,  searchController.text.toString(), categorys, mediatypes, "");
                print('object${filterController.MediaSelectedServices.value}');
              }
            },
          ),
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
            items: filterController.CategoryTextList.map(
                    (element) => MultiSelectItem(element, element)).toList(),
            initialValue: filterController.CategorySelectedServices.value,
            onConfirm: (values) {
              filterController.CategorySelectedServices.value = values;
              filterController.selectedCategoryValuesToDisplay.value = "";
              values.forEach((element) {
                print("selected category : $element");
                filterController.selectedCategoryValuesToDisplay.value +=
                    element + ", ";
              });
              print('object${filterController.CategorySelectedServices.value}');

              if (filterController
                  .selectedCategoryValuesToDisplay.value.isNotEmpty) {
                filterController.selectedCategoryValuesToDisplay.value =
                    filterController.selectedCategoryValuesToDisplay.value
                        .replaceRange(
                      filterController
                          .selectedCategoryValuesToDisplay.value.length -
                          2,
                      filterController.selectedCategoryValuesToDisplay.value.length,
                      "",
                    );

                List<String> ids = [];
                filterController.categorieList.forEach((element) {
                  filterController.CategorySelectedServices.forEach(
                          (ownerJobType) {
                        if (ownerJobType == element.categoryName) {
                          ids.add(element.categoryId.toString());
                        }
                      });
                });
                setState(() {
                  categorys = ids.join(',');
                });
                filterController.selectedCategoryValuesToDisplay.value;
                homeController.nosubsarticleList.clear();
                homeController.pageNumber.value = 1;
                homeController.getNonSubscribeArticleList(context, homeController.pageNumber.value, 10,  searchController.text.toString(), categorys, mediatypes, "");
                print(
                    'object${filterController.CategorySelectedServices.value}');
              } else {
                setState(() {
                  categorys = '';
                });
                filterController.selectedCategoryValuesToDisplay.value;
                homeController.nosubsarticleList.clear();
                homeController.pageNumber.value = 1;
                homeController.getNonSubscribeArticleList(context, homeController.pageNumber.value, 10,  searchController.text.toString(), categorys, mediatypes, "");
                print(
                    'object${filterController.IntersetSelectedServices.value}');
              }
            },
          ),
        );
      },
    );
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
              ? SizedBox.shrink()
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

class videowidget extends StatefulWidget {
  final bool play;
  final String url;

  const videowidget({Key? key, required this.url, required this.play})
      : super(key: key);

  @override
  _videowidgetstate createstate() => _videowidgetstate();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class _videowidgetstate extends State<videowidget> {
  late VideoPlayerController videoplayercontroller;
  late Future<void> _initializevideoplayerfuture;

  @override
  void initState() {
    super.initState();
    videoplayercontroller = new VideoPlayerController.network(widget.url);

    _initializevideoplayerfuture = videoplayercontroller.initialize().then((_) {
      //       ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });
  } // this closing tag was missing

  @override
  void dispose() {
    videoplayercontroller.dispose();
    //    widget.videoplayercontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializevideoplayerfuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return new Container(
            child: Card(
              //  key: new pagestoragekey(widget.url),
              elevation: 5.0,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Chewie(
                      key: new PageStorageKey(widget.url),
                      controller: ChewieController(
                        videoPlayerController: videoplayercontroller,
                        aspectRatio: 3 / 2,
                        // prepare the video to be played and display the first frame
                        autoInitialize: true,
                        looping: false,
                        autoPlay: false,
                        // errors can occur for example when trying to play a video
                        // from a non-existent url
                        errorBuilder: (context, errormessage) {
                          return Center(
                            child: Text(
                              errormessage,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
