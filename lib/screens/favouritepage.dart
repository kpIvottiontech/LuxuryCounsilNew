import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_council/api_config/api_services.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/controllers/FavouriteController.dart';
import 'package:luxury_council/controllers/editprofileController.dart';
import 'package:luxury_council/controllers/filterController.dart';
import 'package:luxury_council/controllers/homeController.dart';
import 'package:luxury_council/widgets/appbars.dart';
import 'package:luxury_council/widgets/drawer.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../constance/global_data.dart';
import '../strings.dart';
import 'bottom_view_widget.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  final FavouriteController favouriteController = Get.put(FavouriteController());
  final FilterController filterController = Get.put(FilterController());
  final EditProfileController editProfileController =
      Get.put(EditProfileController());
  TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  int _selectedIndex = -1;
  late ScrollController _scrollController;
  int _pageNumber = 0;
  int limit = 10;
  String categorys = '';
  String interests = '';
  String mediatypes = '';
  int randomNumber = 0;
int subscriptionid = GlobalData().subscriptionId;
  @override
  void initState() {
    Random random = new Random();
    randomNumber = random.nextInt(GlobalData().spotlightListing.length);
    _callAPI();
    favouriteController.getCategoriesList(context, null, 0, 100);
    favouriteController.getIntersetList(context, null, 0, 100);
    favouriteController.getMediaTypeList(
      context,
      null,
    );
    checkFirst();
    // homeController.Favourite(context);
    _scrollController = ScrollController();

    super.initState();
  }
  checkFirst() async {
    await filterController.getProfileIntersetList(context, null, 0, 100);
    await editProfileController.getprofile(context);
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
            _scrollController.position.maxScrollExtent) {
          print('total page>total_page>${favouriteController.total_page.value}>> ${favouriteController.pageNumber.value}');
          if (favouriteController.favListResponse.isTrue) {

            print('object = ' + favouriteController.pageNumber.value.toString());
            favouriteController.favListResponse.value = false;
            print('check page>>${favouriteController.pageNumber.value} >>> ${favouriteController.articlelistresponce.value}');
            if((favouriteController.total_page.value) > favouriteController.pageNumber.value) {
              setState(() {
                favouriteController.pageNumber.value = favouriteController.pageNumber.value + 1;
              });
              print('check page>>${favouriteController.pageNumber
                  .value} >>> ${favouriteController.total_page.value}');
              await   favouriteController.getFavouriteList(
                context,
                favouriteController.pageNumber.value,
                limit,
                searchController.text,
                categorys,
                mediatypes,
                interests,
              );
            }
          }

        }
      }
    });

    return Scaffold(
      backgroundColor: AppColor.loginappbar,
      key: _key,
      appBar: AppBarDetails(appBar: AppBar(), text: 'FAVORITE LIST', isNotSubscription: subscriptionid==0||subscriptionid==1||subscriptionid==2||subscriptionid==6,screenName: '/FavouritePage'),
      body: SafeArea(
          child: Container(
       // margin: EdgeInsets.symmetric(horizontal: 15),
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
                            hintStyle: TextStyle(color: Colors.white, fontSize: 14),
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
                            favouriteController.favouriteList.clear();
                            favouriteController.pageNumber.value = 1;
                            favouriteController.getFavouriteList(
                              context,
                              favouriteController.pageNumber.value,
                              10,
                              searchController.text.toString(),
                              categorys,
                              mediatypes,
                              interests,
                            );
                          } else {
                            favouriteController.favouriteList.clear();
                            favouriteController.pageNumber.value = 1;
                            favouriteController.getFavouriteList(
                              context,
                              favouriteController.pageNumber.value,
                              10,
                              searchController.text.toString(),
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
                  () => favouriteController.categorieList.isNotEmpty
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
                                border:
                                    Border.all(color: AppColor.primarycolor)),
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(
                                  () => Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: Text(
                                        favouriteController
                                                .selectedCategoryValuesToDisplay
                                                .value
                                                .isEmpty
                                            ? "Category"
                                            : favouriteController
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
                  () => favouriteController.interestList.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _showInterestSelect(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            height: 30,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: AppColor.primarycolor)),
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(
                                  () => Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: Text(
                                        favouriteController
                                                .selectedIntersetValuesToDisplay
                                                .value
                                                .isEmpty
                                            ? "Interest"
                                            : favouriteController
                                                .selectedIntersetValuesToDisplay
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
                      : Center(child: Text(noInterestFound)),
                ),
                Obx(
                  () => favouriteController.mediatList.isNotEmpty
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
                                border:
                                    Border.all(color: AppColor.primarycolor)),
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(
                                  () => Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      child: Text(
                                        favouriteController
                                                .selectedMediaValuesToDisplay
                                                .value
                                                .isEmpty
                                            ? "Media"
                                            : favouriteController
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

                    Expanded(
                      child: RefreshIndicator(
                        color: AppColor.primarycolor,
                        onRefresh: () {
                          return Future.delayed(
                              Duration(
                                seconds: 1,
                              ), () {
                            favouriteController.articleList.clear();
                            favouriteController.pageNumber.value = 1;
                            favouriteController.getArticleList(
                              context,
                              favouriteController.pageNumber.value,
                              10,
                              favouriteController.searchController.text.toString(),
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
                                    () => favouriteController.favouriteList.isNotEmpty
                                    ? Padding(
                                  padding: const EdgeInsets.only(top: 10.0,bottom: 20),
                                  child: ListView.separated(
                                    padding: EdgeInsets.only(top: 10),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: favouriteController.favouriteList.length,
                                    itemBuilder: (context, index) {
                                      return favouriteController
                                          .favouriteList[index].is_favorite ==
                                          1
                                          ? GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                              "/ArticleVideoAudioDetails",
                                              parameters: {
                                                "index": index.toString(),
                                                "articleId": favouriteController.favouriteList[index].articleId.toString(),
                                              });
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width,
                                          decoration: BoxDecoration(
                                            color: AppColor.black,
                                          ),
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  flex:2,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                          "${favouriteController.favouriteList[index].articleName}",
                                                          style: TextStyle(
                                                              color: AppColor
                                                                  .white,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              fontSize: 14),
                                                        ),
                                                      ),
                                                      // HtmlWidget(
                                                      //     //to show HTML as widget.
                                                      //     htmlcode!,textStyle: TextStyle(color: AppColor.white),
                                                      //     ),
                                                      Container(
                                                        height: 60,
                                                        child: Text(
                                                          "${favouriteController.favouriteList[index].articalShortDesc}",
                                                          style: TextStyle(
                                                              color: AppColor
                                                                  .textlight,
                                                              fontSize: 14),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 3,
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                          onTap: () {
                                                            showDialog(
                                                                barrierDismissible:
                                                                false,
                                                                context:
                                                                context,
                                                                builder:
                                                                    (dialogContex) {
                                                                  return AlertDialog(
                                                                    content:
                                                                    Column(
                                                                      mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                      children: [

                                                                        Text(
                                                                          "Are you sure you want to remove favorite article?",
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              color: AppColor.black),
                                                                          textAlign:
                                                                          TextAlign.center,
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                          20,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment.spaceAround,
                                                                          children: [
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: Container(
                                                                                height: 30,
                                                                                width: 80,
                                                                                decoration: BoxDecoration(color: AppColor.primarycolor, borderRadius: BorderRadius.circular(3)),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    'NO',
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                Get.back();
                                                                                favouriteController.Favourite(context, int.parse(favouriteController.favouriteList[index].articleId.toString()), int.parse(loginController.appuserid.toString()), 0, index, isFavScreen: true);
                                                                              },
                                                                              child: Container(
                                                                                height: 30,
                                                                                width: 80,
                                                                                decoration: BoxDecoration(color: AppColor.primarycolor, borderRadius: BorderRadius.circular(3)),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    'YES',
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  );
                                                                });
                                                            // if (homeController
                                                            //         .favouriteList[
                                                            //             index]
                                                            //         .is_favorite ==
                                                            //     0) {
                                                            //   // homeController
                                                            //   // .favouriteList[index]
                                                            //   // .is_favorite =1;
                                                            //   homeController.Favourite(
                                                            //       context,
                                                            //       int.parse(homeController
                                                            //           .favouriteList[
                                                            //               index]
                                                            //           .articleId
                                                            //           .toString()),
                                                            //       int.parse(loginController
                                                            //           .appuserid
                                                            //           .toString()),
                                                            //       1,
                                                            //       index);
                                                            // } else if (homeController
                                                            //         .favouriteList[
                                                            //             index]
                                                            //         .is_favorite ==
                                                            //     1) {
                                                            //   //   homeController
                                                            //   // .favouriteList[index]
                                                            //   // .is_favorite = 0;
                                                            //   homeController.Favourite(
                                                            //       context,
                                                            //       int.parse(homeController
                                                            //           .favouriteList[
                                                            //               index]
                                                            //           .articleId
                                                            //           .toString()),
                                                            //       int.parse(loginController
                                                            //           .appuserid
                                                            //           .toString()),
                                                            //       0,
                                                            //       index);
                                                            // }
                                                          },
                                                          child: Image.asset(
                                                            'assets/heartselect.png',
                                                            scale: 2.9,
                                                          )
                                                      )
                                                    ],
                                                  ),
                                                ),

                                                if (favouriteController
                                                    .favouriteList[
                                                index]
                                                    .mediaSelection ==
                                                    "Article"||favouriteController
                                                    .favouriteList[
                                                index]
                                                    .mediaSelection ==
                                                    "Image") ...[
                                                  if (favouriteController
                                                      .favouriteList[
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
                                                                if (favouriteController
                                                                    .favouriteList[index].mediaSelection == "Article"||favouriteController
                                                                    .favouriteList[
                                                                index]
                                                                    .mediaSelection ==
                                                                "Image")
                                                                  if (favouriteController
                                                                      .favouriteList[index].thumbnailImage!.isNotEmpty)
                                                                    Center(
                                                                      child: Image.network(
                                                                        favouriteController
                                                                            .favouriteList[index].thumbnailImage != null || favouriteController
                                                                            .favouriteList[index].image![0].imageurl == null ? "${favouriteController
                                                                            .favouriteList[index].thumbnailImage}" : "${favouriteController
                                                                            .favouriteList[index].image![0].imageurl}",
                                                                        fit: BoxFit.cover,
                                                                        height: 90,
                                                                        width: 90,
                                                                      ),
                                                                    ),
                                                                if (favouriteController
                                                                    .favouriteList[index].mediaSelection == "Video")
                                                                  favouriteController
                                                                      .favouriteList[index].thumbnailImage != null
                                                                      ? Image.network(
                                                                    "${favouriteController
                                                                        .favouriteList[index].thumbnailImage}",
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
                                                                if (favouriteController
                                                                    .favouriteList[index].mediaSelection == "Audio")
                                                                  favouriteController
                                                                      .favouriteList[index].thumbnailImage != null
                                                                      ? Image.network(
                                                                    "${favouriteController
                                                                        .favouriteList[index].thumbnailImage}",
                                                                  )
                                                                      : Center(
                                                                    child: Image.asset(
                                                                      "assets/audio.png",
                                                                      scale: 2.9,
                                                                    ),
                                                                  ),
                                                                if (favouriteController
                                                                    .favouriteList[index].mediaSelection == "Resource")
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
                                                              if (favouriteController
                                                                  .favouriteList[index].mediaSelection ==
                                                                  "Article"||favouriteController
                                                                  .favouriteList[
                                                              index]
                                                                  .mediaSelection ==
                                                              "Image")
                                                                if (favouriteController
                                                                    .favouriteList[index].image!.isNotEmpty || favouriteController
                                                                    .favouriteList[index].thumbnailImage!.isNotEmpty)
                                                                  Center(
                                                                    child: Image.network(
                                                                      favouriteController
                                                                          .favouriteList[index].thumbnailImage != null || favouriteController
                                                                          .favouriteList[index].image![0].imageurl == null ? "${favouriteController
                                                                          .favouriteList[index].thumbnailImage}" : "${favouriteController
                                                                          .favouriteList[index].image![0].imageurl}",
                                                                      fit: BoxFit.cover,
                                                                      height: 90,
                                                                      width: 90,
                                                                    ),
                                                                  ),
                                                              if (favouriteController
                                                                  .favouriteList[index].mediaSelection == "Video" &&
                                                                  favouriteController
                                                                      .favouriteList[index].thumbnailImage != null)
                                                                favouriteController
                                                                    .favouriteList[index].thumbnailImage != null
                                                                    ? Stack(
                                                                  alignment: Alignment.center,
                                                                  children: [
                                                                    Image.network(
                                                                      "${favouriteController
                                                                          .favouriteList[index].thumbnailImage}",
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

                                                              if (favouriteController
                                                                  .favouriteList[index].mediaSelection == "Audio" &&
                                                                  favouriteController
                                                                      .favouriteList[index].thumbnailImage != null)
                                                                favouriteController
                                                                    .favouriteList[index].thumbnailImage != null
                                                                    ? Stack(
                                                                  alignment: Alignment.center,
                                                                  children: [
                                                                    Image.network(
                                                                      "${favouriteController
                                                                          .favouriteList[index].thumbnailImage}",
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
                                                              if (favouriteController
                                                                  .favouriteList[index].mediaSelection == "Resource" &&
                                                                  favouriteController
                                                                      .favouriteList[index].thumbnailImage != null)
                                                                favouriteController
                                                                    .favouriteList[index].thumbnailImage != null
                                                                    ? Stack(
                                                                  alignment: Alignment.center,
                                                                  children: [
                                                                    Image.network(
                                                                      "${favouriteController
                                                                          .favouriteList[index].thumbnailImage}",
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

                                               /* favouriteController
                                                    .favouriteList[index]
                                                    .image!
                                                    .isNotEmpty && favouriteController
                                                    .favouriteList[index]
                                                    .image! != ''
                                                    ?Flexible(
                                                  flex:1,
                                                  child: Container(
                                                    height: 90,
                                                    width: 90,
                                                    color: AppColor.grey,
                                                    // decoration: BoxDecoration(
                                                    //     border: Border.all(color: AppColor.grey)),
                                                    child: Stack(
                                                      children: [
                                                        if (favouriteController
                                                            .favouriteList[
                                                        index]
                                                            .mediaSelection ==
                                                            "Article")
                                                          Center(
                                                            child: Image
                                                                .network(
                                                              "${favouriteController.favouriteList[index].image![0].imageurl}",
                                                              fit: BoxFit
                                                                  .cover,
                                                              height: 90,
                                                              width: 90,
                                                            ),
                                                          ),
                                                        if (favouriteController
                                                            .favouriteList[
                                                        index]
                                                            .mediaSelection ==
                                                            "Video")
                                                          Center(
                                                            child: Icon(
                                                              Icons
                                                                  .video_settings,
                                                              color: AppColor
                                                                  .primarycolor,
                                                              size: 30,
                                                            ),
                                                          ),
                                                        if (favouriteController
                                                            .favouriteList[
                                                        index]
                                                            .mediaSelection ==
                                                            "Audio")
                                                          Center(
                                                            child: Image
                                                                .asset(
                                                              "assets/audio.png",
                                                              scale: 2.9,
                                                            ),
                                                          ),
                                                        if (favouriteController
                                                            .favouriteList[
                                                        index]
                                                            .mediaSelection ==
                                                            "Resource")
                                                          Center(
                                                            child: Image
                                                                .asset(
                                                              "assets/docs.png",
                                                              scale: 20,
                                                              color: AppColor
                                                                  .primarycolor,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ):
                                                Container()*/

                                               /* if (favouriteController
                                                    .favouriteList[index]
                                                    .mediaSelection
                                                    .toString() ==
                                                    'Video')
                                                  ...[]
                                                else if ("" == "")
                                                  ...[],
                                                if (favouriteController
                                                    .favouriteList[index]
                                                    .image!
                                                    .isNotEmpty)
                                                  Flexible(
                                                    flex:1,
                                                    child: Container(
                                                      height: 90,
                                                      width: 90,
                                                      color: AppColor.grey,
                                                      // decoration: BoxDecoration(
                                                      //     border: Border.all(color: AppColor.grey)),
                                                      child: Stack(
                                                        children: [
                                                          if (favouriteController
                                                              .favouriteList[
                                                          index]
                                                              .mediaSelection ==
                                                              "Article")
                                                            Center(
                                                              child: Image
                                                                  .network(
                                                                "${favouriteController.favouriteList[index].image![0].imageurl}",
                                                                fit: BoxFit
                                                                    .cover,
                                                                height: 90,
                                                                width: 90,
                                                              ),
                                                            ),
                                                          if (favouriteController
                                                              .favouriteList[
                                                          index]
                                                              .mediaSelection ==
                                                              "Video")
                                                            Center(
                                                              child: Icon(
                                                                Icons
                                                                    .video_settings,
                                                                color: AppColor
                                                                    .primarycolor,
                                                                size: 30,
                                                              ),
                                                            ),
                                                          if (favouriteController
                                                              .favouriteList[
                                                          index]
                                                              .mediaSelection ==
                                                              "Audio")
                                                            Center(
                                                              child: Image
                                                                  .asset(
                                                                "assets/audio.png",
                                                                scale: 2.9,
                                                              ),
                                                            ),
                                                          if (favouriteController
                                                              .favouriteList[
                                                          index]
                                                              .mediaSelection ==
                                                              "Resource")
                                                            Center(
                                                              child: Image
                                                                  .asset(
                                                                "assets/docs.png",
                                                                scale: 20,
                                                                color: AppColor
                                                                    .primarycolor,
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),*/
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                          : SizedBox();
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        height: 8,
                                      );
                                    },
                                  ),
                                )
                                    : Center(child: Text(noFavouriteFound)),
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
            /* GlobalData().spotlightListing.isNotEmpty ?
            BottomViewWidget(data : GlobalData().spotlightListing[randomNumber]):
            Container()*/
          ],
        ),
      )),
    );
  }
  // Future<void> FilterDialog(BuildContext context) {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context1) {
  //       return StatefulBuilder(// You need this, notice the parameters below:
  //           builder: (BuildContext context, StateSetter setState) {
  //         return AlertDialog(
  //           // title: Text('Filter',style: TextStyle(color: AppColor.black),),
  //           actions: <Widget>[
  //             Container(
  //               margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
  //               child: Column(
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       Container(
  //                           margin: EdgeInsets.only(right: 80),
  //                           child: Text(
  //                             'Filter',
  //                             style: TextStyle(
  //                                 color: AppColor.black, fontSize: 20),
  //                           )),
  //                       GestureDetector(
  //                           onTap: () {
  //                             Get.back();
  //                           },
  //                           child: Icon(Icons.close))
  //                     ],
  //                   ),
  //                   SizedBox(
  //                     height: 15,
  //                   ),
  //                   GestureDetector(
  //                     onTap: () => _showCategorySelect(context),
  //                     child: Container(
  //                       height: 38,
  //                       width: Get.width,
  //                       alignment: Alignment.centerLeft,
  //                       padding: EdgeInsets.all(5),
  //                       decoration: BoxDecoration(
  //                           color: AppColor.grey.withOpacity(0.1),
  //                           borderRadius: BorderRadius.circular(10),
  //                           border: Border.all(color: Color(0xFF757575))),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Obx(
  //                             () => Expanded(
  //                               child: Text(
  //                                 favouriteController
  //                                         .selectedJobCategoryValuesToDisplay
  //                                         .value
  //                                         .isEmpty
  //                                     ? "Select category"
  //                                     : favouriteController
  //                                         .selectedJobCategoryValuesToDisplay
  //                                         .value,
  //                                 softWrap: true,
  //                                 overflow: TextOverflow.ellipsis,
  //                               ),
  //                             ),
  //                           ),
  //                           Icon(Icons.keyboard_arrow_down, color: Colors.black)
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 15,
  //                   ),

  //                 ],
  //               ),
  //             ),
  //           ],
  //         );
  //       });
  //     },
  //   );
  // }
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
            items: favouriteController.CategoryTextList.map(
                (element) => MultiSelectItem(element, element)).toList(),
            initialValue: favouriteController.CategorySelectedServices.value,
            onConfirm: (values) {
              favouriteController.CategorySelectedServices.value = values;
              favouriteController.selectedCategoryValuesToDisplay.value = "";
              values.forEach((element) {
                print("selected category : $element");
                favouriteController.selectedCategoryValuesToDisplay.value +=
                    element + ", ";
              });
              print('object${favouriteController.CategorySelectedServices.value}');

              if (favouriteController
                  .selectedCategoryValuesToDisplay.value.isNotEmpty) {
                favouriteController.selectedCategoryValuesToDisplay.value =
                    favouriteController.selectedCategoryValuesToDisplay.value
                        .replaceRange(
                  favouriteController
                          .selectedCategoryValuesToDisplay.value.length -
                      2,
                  favouriteController.selectedCategoryValuesToDisplay.value.length,
                  "",
                );

                List<String> ids = [];
                favouriteController.categorieList.forEach((element) {
                  favouriteController.CategorySelectedServices.forEach(
                      (ownerJobType) {
                    if (ownerJobType == element.categoryName) {
                      ids.add(element.categoryId.toString());
                    }
                  });
                });
                setState(() {
                  categorys = ids.join(',');
                });
                favouriteController.selectedCategoryValuesToDisplay.value;
                favouriteController.favouriteList.clear();
                favouriteController.pageNumber.value = 1;
                favouriteController.getFavouriteList(
                  context,
                  favouriteController.pageNumber.value,
                  10,
                  searchController.text.toString(),
                  categorys,
                  mediatypes,
                  interests,
                );
                print(
                    'object${favouriteController.CategorySelectedServices.value}');
              } else {
                setState(() {
                  categorys = '';
                });
                favouriteController.selectedCategoryValuesToDisplay.value;
                favouriteController.favouriteList.clear();
                favouriteController.pageNumber.value = 1;
                favouriteController.getFavouriteList(
                  context,
                  favouriteController.pageNumber.value,
                  10,
                  searchController.text.toString(),
                  categorys,
                  mediatypes,
                  interests,
                );
                print(
                    'object${favouriteController.IntersetSelectedServices.value}');
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
            items: favouriteController.IntersetTextList.map(
                (element) => MultiSelectItem(element, element)).toList(),
            initialValue: favouriteController.IntersetSelectedServices.value,
            onConfirm: (values) {
              favouriteController.IntersetSelectedServices.value = values;
              favouriteController.selectedIntersetValuesToDisplay.value = "";
              values.forEach((element) {
                print("selected interest : $element");
                favouriteController.selectedIntersetValuesToDisplay.value +=
                    element + ", ";
              });
              print('object${favouriteController.IntersetSelectedServices.value}');
              // favouriteController.selectedIntersetValuesToDisplay.value =
              //     favouriteController.selectedIntersetValuesToDisplay.value
              //         .replaceRange(
              //   favouriteController.selectedIntersetValuesToDisplay.value.length -
              //       2,
              //   favouriteController.selectedIntersetValuesToDisplay.value.length,
              //   "",
              // );
              if (favouriteController
                  .selectedIntersetValuesToDisplay.value.isNotEmpty) {
                favouriteController.selectedIntersetValuesToDisplay.value =
                    favouriteController.selectedIntersetValuesToDisplay.value
                        .replaceRange(
                  favouriteController
                          .selectedIntersetValuesToDisplay.value.length -
                      2,
                  favouriteController.selectedIntersetValuesToDisplay.value.length,
                  "",
                );

                List<String> ids = [];
                favouriteController.interestList.forEach((element) {
                  favouriteController.IntersetSelectedServices.forEach(
                      (ownerJobType) {
                    if (ownerJobType == element.interestName) {
                      ids.add(element.interestId.toString());
                    }
                  });
                });
                setState(() {
                  interests = ids.join(',');
                });
                favouriteController.selectedIntersetValuesToDisplay.value;
                favouriteController.favouriteList.clear();
                favouriteController.pageNumber.value = 1;
                favouriteController.getFavouriteList(
                  context,
                  favouriteController.pageNumber.value,
                  10,
                  searchController.text.toString(),
                  categorys,
                  mediatypes,
                  interests,
                );
                print(
                    'object${favouriteController.IntersetSelectedServices.value}');
              } else {
                setState(() {
                  interests = '';
                });
                favouriteController.selectedIntersetValuesToDisplay.value;
                favouriteController.favouriteList.clear();
                favouriteController.pageNumber.value = 1;
                favouriteController.getFavouriteList(
                  context,
                  favouriteController.pageNumber.value,
                  10,
                  searchController.text.toString(),
                  categorys,
                  mediatypes,
                  interests,
                );
                print(
                    'object${favouriteController.IntersetSelectedServices.value}');
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
            items: favouriteController.MediaTextList.map(
                (element) => MultiSelectItem(element, element)).toList(),
            initialValue: favouriteController.MediaSelectedServices.value,
            onConfirm: (values) {
              favouriteController.MediaSelectedServices.value = values;
              favouriteController.selectedMediaValuesToDisplay.value = "";
              values.forEach((element) {
                print("selected media type : $element");
                favouriteController.selectedMediaValuesToDisplay.value +=
                    element + ", ";
              });
              print('object${favouriteController.MediaSelectedServices.value}');
              if (favouriteController
                  .selectedMediaValuesToDisplay.value.isNotEmpty) {
                favouriteController.selectedMediaValuesToDisplay.value =
                    favouriteController.selectedMediaValuesToDisplay.value
                        .replaceRange(
                  favouriteController.selectedMediaValuesToDisplay.value.length -
                      2,
                  favouriteController.selectedMediaValuesToDisplay.value.length,
                  "",
                );

                List<String> ids = [];
                favouriteController.mediatList.forEach((element) {
                  favouriteController.MediaSelectedServices.forEach(
                      (ownerJobType) {
                    if (ownerJobType == element.mediaName) {
                      ids.add(element.mediaId.toString());
                    }
                  });
                });
                setState(() {
                  mediatypes = ids.join(',');
                });
                favouriteController.selectedMediaValuesToDisplay.value;
                favouriteController.favouriteList.clear();
                favouriteController.pageNumber.value = 1;
                favouriteController.getFavouriteList(
                  context,
                  favouriteController.pageNumber.value,
                  10,
                  searchController.text.toString(),
                  categorys,
                  mediatypes,
                  interests,
                );
                print('object${favouriteController.MediaSelectedServices.value}');
              } else {
                setState(() {
                  mediatypes = '';
                });
                favouriteController.selectedMediaValuesToDisplay.value;
                favouriteController.favouriteList.clear();
                favouriteController.pageNumber.value = 1;
                favouriteController.getFavouriteList(
                  context,
                  favouriteController.pageNumber.value,
                  10,
                  searchController.text.toString(),
                  categorys,
                  mediatypes,
                  interests,
                );
                print('object${favouriteController.MediaSelectedServices.value}');
              }
            },
          ),
        );
      },
    );
  }

  void _callAPI() {
    favouriteController.favouriteList.clear();
    favouriteController.pageNumber.value = 1;
    favouriteController.getFavouriteList(
      context,
      favouriteController.pageNumber.value,
      10,
      searchController.text.toString(),
      categorys,
      mediatypes,
      interests,
    );
  }
}
