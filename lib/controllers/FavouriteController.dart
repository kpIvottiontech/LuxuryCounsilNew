import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:luxury_council/api_config/api_services.dart';
import 'package:luxury_council/api_config/urls.dart';
import 'package:luxury_council/config/colors.dart';
import 'package:luxury_council/config/prefrance.dart';
import 'package:luxury_council/constance/global_data.dart';
import 'package:luxury_council/models/OwnerJobCategories.dart';
import 'package:luxury_council/models/articledetailslist/articledetailslistrequest.dart';
import 'package:luxury_council/models/articlelist/articlelistrequest.dart';
import 'package:luxury_council/models/articlelist/articlelistresponce.dart';
import 'package:luxury_council/models/categories/categorymodel.dart';
import 'package:luxury_council/models/categories/categoryrequest.dart';
import 'package:luxury_council/models/categories/categoryresponce.dart';
import 'package:luxury_council/models/interest/interestmodel.dart';
import 'package:luxury_council/models/interest/interestrequest.dart';
import 'package:luxury_council/models/interest/interestresponce.dart';
import 'package:luxury_council/models/mediatype/mediatypemodel.dart';
import 'package:luxury_council/models/mediatype/mediatyperesponce.dart';
import 'package:luxury_council/models/nonsubscriberartilcle/nonsubscriberesponce.dart';
import 'package:luxury_council/models/nonsubscriberartilcle/nonsubscribermodel.dart';
import 'package:luxury_council/strings.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:chewie/chewie.dart';
import '../constance/firestore_constants.dart';
import '../models/articlelist/articlelistmodel.dart';
import '../screens/custom_alert.dart';
import '../social_login.dart';

class FavouriteController extends GetxController {
  RxList<ArticleListModel> articleList = <ArticleListModel>[].obs;
  RxList<ArticleListModel> favouriteList = <ArticleListModel>[].obs;
/*  RxList<Video> nosubsvideoList = <Video>[].obs;
  RxList<Article> nosubsarticleList = <Article>[].obs;*/
  RxList<dynamic> CategorySelectedServices = <dynamic>[].obs;
  RxString selectedCategoryValuesToDisplay = "".obs;
  RxBool articlelistresponce = true.obs;
  RxBool favListResponse = true.obs;
  RxBool noarticlelistresponce = false.obs;
  RxBool novideolistresponce = true.obs;
  RxBool articledetailslistresponce = true.obs;
  TextEditingController searchController = TextEditingController();

  var article_id = 0.obs;
  var fav = 0.obs;
  var article_name = ''.obs;
  RxInt pageNumber = 1.obs;
  //var image = .obs;
  RxList<String> image = <String>[].obs;
  RxList<String> thumbnail_image = <String>[].obs;
  var media_selection = ''.obs;
  var artical_short_desc = ''.obs;
  var youtube_url = ''.obs;
  var audio = ''.obs;
  var resource = ''.obs;
  var publisher = ''.obs;
  var publish_date = ''.obs;
  var artical_long_desc = ''.obs;
  var appuseriddetails = 0.obs;
  var articleid1 = 0.obs;
  var appuserid1 = 0.obs;
  var favourites1 = 1.obs;
  var total_page = 0.obs;
  RxList<String> CategoryTextList = <String>[].obs;
  RxList<CategorieModel> categorieList = <CategorieModel>[].obs;
  final RxMap data = Map<String, dynamic>().obs;
  late YoutubePlayerController youtubeController;
  late VideoPlayerController videoController;
  late ChewieController chewieController;
  late Future<void> initializeVideoPlayerFuture;
  RxBool categorieresponce = true.obs;

  RxList<InterestModel> interestList = <InterestModel>[].obs;
  RxList<String> IntersetTextList = <String>[].obs;
  RxList<String> IntersetTextListID = <String>[].obs;
  RxList<dynamic> IntersetSelectedServices = <dynamic>[].obs;
  RxList<dynamic> IntersetSelectedServicesId = <dynamic>[].obs;
  RxString selectedIntersetValuesToDisplay = "".obs;
  RxBool intersetresponce = true.obs;

  RxList<MediaTypeModel> mediatList = <MediaTypeModel>[].obs;
  RxList<String> MediaTextList = <String>[].obs;
  RxList<dynamic> MediaSelectedServices = <dynamic>[].obs;
  RxString selectedMediaValuesToDisplay = "".obs;
  RxBool mediaresponce = true.obs;
  var menuAndServiceList = [].obs;

  @override
  void onInit() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // TODO: implement onInit
    super.onInit();

  }

  updateScreen(String value) {
    update([value]);
  }

  Future<void> getArticleList(
    BuildContext context,
    int page,
    int limit,
    String searchtext,
    String searchcategory,
    String searchmedia,
    String searchinterest,
  ) async {
    context.loaderOverlay.show();
    print("ARTICLE LIST URL ----> ${Urls.SUBSCRIBE_USER_ARTICLE_LIST}");
    ArticleListRequest articlelistRequest = ArticleListRequest(
        page: page,
        limit: limit,
        searchCategory: searchcategory,
        searchInterest: searchinterest,
        searchMedia: searchmedia,
        searchText: searchtext);
    print('page ----> $page');
    print("ARTICLE LIST URL ----> ${jsonEncode(articlelistRequest)}");
  await  POST_API(articlelistRequest, Urls.SUBSCRIBE_USER_ARTICLE_LIST, context)
        .then((response) {
      print("ARTICLE LIST response ----> $response");
      Map<String, dynamic> map = jsonDecode(response);
      if (map["data"].isEmpty) {
        context.loaderOverlay.hide();
       // articleList.clear();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            noArticleFound,
            style: TextStyle(color: AppColor.white),
          ),
        ));
        articlelistresponce = false.obs;
      } else {
        if (map["status"] != true) {
          articlelistresponce = false.obs;
        }
        else {
          if (map['app_user_status'] == 0) {
            CustomAlert.showAlert(context, 'Your account has been inactivated.',
                title: 'Luxury Council', btnFirst: 'Ok', handler: (int index) {
              if (index == 0) {
                // Get.offAllNamed('/HomeWithoutSignUp');
                RemoveData('facebook_id');
                SocialLogin().facebookLogin?.logOut();
                RemoveData('google_id');
                SocialLogin().googleSignIn.signOut();
                SocialLogin().logoutUser = true;
                SocialLogin().user = null;
                RemoveData('linkedin_id');
                RemoveData("Email");
                RemoveData("Password");
                FirebaseFirestore.instance
                    .collection(FirestoreConstants.pathUserCollection)
                    .doc(GlobalData().userId.toString())
                    .update({FirestoreConstants.isOnline: 0});
                Get.offAllNamed("/Login");
              }
            });
          }
          else if (map['subscription_expired'] == 1) {
            SetIntData("subscription_id", 0);
            CustomAlert.showAlert(
                context, 'Your subscription has been expired.',
                title: 'Luxury Council', btnFirst: 'Ok', handler: (int index) {
              if (index == 0) {
                Get.offAllNamed('/HomeWithoutSignUp');
              }
            });
          }
          else {
            Articlelistresponce articlelistResponce =
            Articlelistresponce.fromJson(jsonDecode(response));
            articlelistresponce = true.obs;
            total_page.value = articlelistResponce.totalPage?.toInt() ?? 0;
            print('total_page ----> ${total_page.value}');
            articleList.addAll((articlelistResponce.data ?? []));
          }
        }
        context.loaderOverlay.hide();
      }
    }, onError: (error) {
      print("Error ---> ${error}");
      context.loaderOverlay.hide();
    });
  }

  void getCategoriesList(
      BuildContext context,
      List<OwnerJobCategories>? ownerJobCategories,
      int page,
      int limit,
      ) {
    // context.loaderOverlay.show();
    print("CATEGORIES LIST URL ----> ${Urls.CATEGORIES_LIST}");
    CategorieRequest categorielistRequest = CategorieRequest(
      page: page,
      limit: limit,
    );
    print("CATEGORIES LIST URL ----> ${jsonEncode(categorielistRequest)}");
    POST_API(categorielistRequest, Urls.CATEGORIES_LIST, context)
        .then((response) {
      print("CATEGORIES LIST response ----> $response");
      CategorieResponce categorielistResponse =
      CategorieResponce.fromJson(jsonDecode(response));
      Map<String, dynamic> map = jsonDecode(response);
      if (map["status"] != true) {
        categorieresponce = false.obs;
      } else {
        categorieList.clear();
        CategoryTextList.clear();
        CategorySelectedServices.clear();
        selectedCategoryValuesToDisplay.value = "";
        categorieList.value = categorielistResponse.categoryModel ?? [];
        categorieList.forEach((element) {
          CategoryTextList.add(element.categoryName ?? "");
        });
        if (ownerJobCategories != null) {
          ownerJobCategories.forEach((element) {
            CategorySelectedServices.add(element.jobCategoryName!);
            selectedCategoryValuesToDisplay.value += element.jobCategoryName! + ", ";
          });
          selectedCategoryValuesToDisplay.value = selectedCategoryValuesToDisplay.value.replaceRange(selectedCategoryValuesToDisplay.value.length - 2, selectedCategoryValuesToDisplay.value.length, "",);
          updateScreen('home');
        }
        // context.loaderOverlay.hide();

        // categorieList.addAll((categorielistResponse.categoryModel ?? []));
      }
      // context.loaderOverlay.hide();
    });
  }

  void getIntersetList(
      BuildContext context,
      List<OwnerJobCategories>? ownerJobCategories,
      int page,
      int limit,
      ) {
    // context.loaderOverlay.show();
    print("INTEREST LIST URL ----> ${Urls.INTEREST_LIST}");
    InterestRequest interestlistRequest = InterestRequest(
      page: page,
      limit: limit,
    );
    print("INTEREST LIST URL ----> ${jsonEncode(interestlistRequest)}");
    POST_API(interestlistRequest, Urls.INTEREST_LIST, context).then((response) {
      print("INTEREST LIST response ----> $response");
      IntersetResponce interestlistResponse =
      IntersetResponce.fromJson(jsonDecode(response));
      Map<String, dynamic> map = jsonDecode(response);
      if (map["status"] != true) {
        intersetresponce = false.obs;
      } else {
        interestList.clear();
        IntersetTextList.clear();
        IntersetSelectedServices.clear();
        selectedIntersetValuesToDisplay.value = "";
        interestList.value = interestlistResponse.interestModel ?? [];
        interestList.forEach((element) {
          print('element id>>> ${element.interestId}');
          /*   Map<String, dynamic> mapToAdd = {
            'id': element.interestId,
            'name': element.interestName,
            // Add other keys/values if needed
          };
          interestMap.add(mapToAdd);*/
          IntersetTextList.add(element.interestName ?? "");
          // IntersetTextListID.add(element.interestId.toString() ?? "");
        });
        // print('element id   @@@@   >>> ${interestMap[1]['id']}, ${interestMap[1]['name']}');
        if (ownerJobCategories != null) {
          ownerJobCategories.forEach((element) {
            print('dnfdsnfdfndn');
            // IntersetSelectedServices.add(element.jobCategoryName!);
            //  print('selected interest : ${element.}');
            IntersetSelectedServices.add(element.jobCategoryName!);
            selectedIntersetValuesToDisplay.value +=
                element.jobCategoryName! + ", ";
          });
          selectedIntersetValuesToDisplay.value =
              selectedIntersetValuesToDisplay.value.replaceRange(
                selectedIntersetValuesToDisplay.value.length - 2,
                selectedIntersetValuesToDisplay.value.length,
                "",
              );
        }
        // context.loaderOverlay.hide();

        // interestList.addAll((interestlistResponse.interestModel ?? []));
      }
      // context.loaderOverlay.hide();
    });
  }

  void getMediaTypeList(
      BuildContext context,
      List<OwnerJobCategories>? ownerJobCategories,
      // int page,
      // int limit,
      ) {
    // context.loaderOverlay.show();
    print("MEDIA TYPE LIST URL ----> ${Urls.MEDIA_LIST}");
    // InterestRequest interestlistRequest = InterestRequest(
    //   page: page,
    //   limit: limit,
    // );
    // print("MEDIA TYPE LIST URL ----> ${jsonEncode(interestlistRequest)}");
    GET_API(Urls.MEDIA_LIST, context).then((response) {
      print("MEDIA TYPE LIST response ----> $response");
      MediaListResponce medialistResponse =
      MediaListResponce.fromJson(jsonDecode(response));
      Map<String, dynamic> map = jsonDecode(response);
      if (map["status"] != true) {
        mediaresponce = false.obs;
      } else {
        mediatList.clear();
        MediaTextList.clear();
        MediaSelectedServices.clear();
        selectedMediaValuesToDisplay.value = "";
        mediatList.value = medialistResponse.mediatypeModel ?? [];
        mediatList.forEach((element) {
          MediaTextList.add(element.mediaName ?? "");
        });
        if (ownerJobCategories != null) {
          ownerJobCategories.forEach((element) {
            MediaSelectedServices.add(element.jobCategoryName!);
            selectedMediaValuesToDisplay.value +=
                element.jobCategoryName! + ", ";
          });
          selectedMediaValuesToDisplay.value =
              selectedMediaValuesToDisplay.value.replaceRange(
                selectedMediaValuesToDisplay.value.length - 2,
                selectedMediaValuesToDisplay.value.length,
                "",
              );
        }
        // context.loaderOverlay.hide();

        // mediatList.addAll((medialistResponse.mediatypeModel ?? []));
      }
      // context.loaderOverlay.hide();
    });
  }

  getFavouriteList(
    BuildContext context,
    int page,
    int limit,
    String searchtext,
    String searchcategory,
    String searchmedia,
    String searchinterest,
  ) {
    context.loaderOverlay.show();
    ArticleListRequest request = ArticleListRequest(
        page: page,
        limit: limit,
        searchCategory: searchcategory,
        searchInterest: searchinterest,
        searchMedia: searchmedia,
        searchText: searchtext);
    print("ARTICLE LIST URL ----> ${jsonEncode(request)}");
    POST_API(request, Urls.FavouriteList, context).then((response) {
      print("ARTICLE LIST response ----> $response");
      Map<String, dynamic> map = jsonDecode(response);
      if (map["data"].isEmpty) {
        context.loaderOverlay.hide();
       // favouriteList.clear();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            noArticleFound,
            style: TextStyle(color: AppColor.white),
          ),
        ));
        favListResponse = false.obs;
      }
      else {
        if (map["status"] != true) {
          favListResponse = false.obs;
        }
        else {
          if (map['app_user_status'] == 0) {
            CustomAlert.showAlert(context, 'Your account has been inactivated.',
                title: 'Luxury Council', btnFirst: 'Ok', handler: (int index) {
              if (index == 0) {
                // Get.offAllNamed('/HomeWithoutSignUp');
                RemoveData('facebook_id');
                SocialLogin().facebookLogin?.logOut();
                RemoveData('google_id');
                SocialLogin().googleSignIn.signOut();
                SocialLogin().logoutUser = true;
                SocialLogin().user = null;
                RemoveData('linkedin_id');
                RemoveData("Email");
                RemoveData("Password");
                FirebaseFirestore.instance
                    .collection(FirestoreConstants.pathUserCollection)
                    .doc(GlobalData().userId.toString())
                    .update({FirestoreConstants.isOnline: 0});
                Get.offAllNamed("/Login");
              }
            });
          }
          else if (map['subscription_expired'] == 1) {
            SetIntData("subscription_id", 0);
            CustomAlert.showAlert(
                context, 'Your subscription has been expired.',
                title: 'Luxury Council', btnFirst: 'Ok', handler: (int index) {
              if (index == 0) {
                Get.offAllNamed('/HomeWithoutSignUp');
              }
            });
          }
          else {
            Articlelistresponce articlelistResponse =
            Articlelistresponce.fromJson(jsonDecode(response));
            favListResponse.value = true;
            total_page.value = articlelistResponse.totalPage?.toInt() ?? 0;
            //favouriteList.clear();
            favouriteList.addAll((articlelistResponse.data ?? []));
          }
        }
        context.loaderOverlay.hide();
      }
    }, onError: (error) {
      print("Error ---> ${error}");
      context.loaderOverlay.hide();
    });
  }

/*  void getNonSubscribeArticleList(
    BuildContext context,
    int page,
    int limit,
    String searchtext,
    String searchcategory,
    String searchmedia,
    String searchinterest,
  ) {
    // noarticlelistresponce = false.obs;
    context.loaderOverlay.show();
    print(
        "NON SUBSCRIBE ARTICLE LIST URL ----> ${Urls.NON_SUBSCRIBE_USER_ARTICLE_LIST}");
    ArticleListRequest articlelistRequest = ArticleListRequest(
        page: page,
        limit: limit,
        searchCategory: searchcategory,
        searchInterest: searchinterest,
        searchMedia: searchmedia,
        searchText: searchtext);
    print(
        "NON SUBSCRIBE ARTICLE LIST URL ----> ${jsonEncode(articlelistRequest)}");
    POST_API(articlelistRequest, Urls.NON_SUBSCRIBE_USER_ARTICLE_LIST, context)
        .then((response) {
      print("NON SUBSCRIBE ARTICLE LIST response ----> $response");

      Map<String, dynamic> map = jsonDecode(response);

      if (map["status"] != true) {
        noarticlelistresponce = false.obs;
        // novideolistresponce = false.obs;
      } else {
        if (map['app_user_status'] == 0) {
          CustomAlert.showAlert(context, 'Your account has been inactivated.',
              title: 'Luxury Council', btnFirst: 'Ok', handler: (int index) {
            if (index == 0) {
              // Get.offAllNamed('/HomeWithoutSignUp');
              RemoveData('facebook_id');
              SocialLogin().facebookLogin?.logOut();
              RemoveData('google_id');
              SocialLogin().googleSignIn.signOut();
              SocialLogin().logoutUser = true;
              SocialLogin().user = null;
              RemoveData('linkedin_id');
              RemoveData("Email");
              RemoveData("Password");
              FirebaseFirestore.instance
                  .collection(FirestoreConstants.pathUserCollection)
                  .doc(GlobalData().userId.toString())
                  .update({FirestoreConstants.isOnline: 0});
              Get.offAllNamed("/Login");
            }
          });
        } else if (map['app_user_status'] == 1 &&
            GlobalData().subscriptionId != 0) {
          Get.offAllNamed('/HomeWithSignUp');
        } else {
          // print("sss :${noarticlelistresponce.isTrue}");
          NonSubscriberArticleResponce nonsubscribeResponse =
              NonSubscriberArticleResponce.fromJson(jsonDecode(response));
         // print(" nonsubscribeResponse ----> ${nonsubscribeResponse.nonSubscribeModel!.article!.first.articleName}");
          nosubsvideoList.clear();
          nosubsvideoList
              .addAll((nonsubscribeResponse.nonSubscribeModel!.video ?? []));
         // getVideoPlaywithoutLogin({String? url});
         // nosubsarticleList.clear();
          nosubsarticleList
              .addAll(nonsubscribeResponse.nonSubscribeModel!.article ?? []);
          noarticlelistresponce = true.obs;
        }
      }
      context.loaderOverlay.hide();
    }, onError: (error) {
      print("Error ---> ${error}");
      context.loaderOverlay.hide();
    });
  }*/


   getArticleDetailsList(
    BuildContext context,
    int articleid,
  ) {
    context.loaderOverlay.show();
    print("ARTICLE DETAILS LIST URL ----> ${Urls.ARTICLE_DETAILS_LIST}");
    ArticleDetailsListRequest articledetailslistRequest =
        ArticleDetailsListRequest(articleid: articleid);
    print(
        "ARTICLE DETAILS LIST URL ----> ${jsonEncode(articledetailslistRequest)}");
    POST_API(articledetailslistRequest, Urls.ARTICLE_DETAILS_LIST, context)
        .then((response) async {
      print("ARTICLE DETAILS LIST response ----> $response");
      Map<String, dynamic> map = jsonDecode(response);
      data.value = map;

      if (map["status"] != true) {
        articledetailslistresponce = false.obs;
      } else {
        article_id.value = map['data']['article_id'];
        article_name.value = map['data']['article_name'];
        media_selection.value = map['data']['media_selection'];
        artical_short_desc.value = map['data']['artical_short_desc'];
        fav.value = map['data']['is_favorite'];
        appuseriddetails.value = await GetIntData("app_user_id");
        thumbnail_image.add(map['data']['thumbnail_image']);

        // image.value = map['data']['image'];
        image.clear();
        for (var list = 0; list < map['data']['image'].length; list++) {
          image.add(map['data']['image'][list]['imageurl']);
        }
        if (map['data']['media_selection'] == 'Resource') {
          youtube_url.value = '';
          audio.value = '';
          resource.value =
              map['data']['resource'] == null ? '' : map['data']['resource'];
        } else if (map['data']['media_selection'] == 'Video') {
          youtube_url.value = map['data']['youtube_url'] == null
              ? ''
              : map['data']['youtube_url'];

          audio.value = '';
          resource.value = '';
          if (youtube_url.value.startsWith('www.youtube.com/')) {
            youtube_url.value = 'https://${youtube_url.value}';
          }
          // youtube_url.value='https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';
          if (youtube_url.value.startsWith('https://www.youtube.com/')) {
            String videoId = YoutubePlayer.convertUrlToId(youtube_url.value)!;
            youtubeController = YoutubePlayerController(
              initialVideoId: videoId,
              flags: YoutubePlayerFlags(
                // hideControls: true,
                showLiveFullscreenButton: false,
                enableCaption: false,
                autoPlay: true,
                mute: false,
              ),
            );
          } else if (_checkEnd()) {
           /* chewieController =
            ChewieController(
              videoPlayerController:
              VideoPlayerController.network(
                  youtube_url.value,
                  videoPlayerOptions: VideoPlayerOptions(
                      allowBackgroundPlayback: false,
                      mixWithOthers: true)),
              aspectRatio: 16 / 9,
              allowMuting: true,
              progressIndicatorDelay: null,
            );*/
          }
        } else if (map['data']['media_selection'] == 'Audio') {
          youtube_url.value = '';
          audio.value =
              map['data']['audio'] == null ? '' : map['data']['audio'];
          resource.value = '';
        } else {
          youtube_url.value = '';
          audio.value = '';
          resource.value = '';
        }
        publisher.value = map['data']['publisher'];
        publish_date.value = map['data']['publish_date'];
        artical_long_desc.value = map['data']['artical_long_desc'];
        print("article_id ${article_id.value}");
        print("fav ${fav.value}");
        print("youtube_url ${map['data']['youtube_url']}");
        print("=audio=== ${map['data']['audio']}");
        print("==resource====== ${map['data']['resource']}");
        print("==resource====== ${resource}");
        print("==long====== ${artical_long_desc.value}");
        // print("===========${map['data']['article_id']}");
        // print("===========${image.length}");
      }
      context.loaderOverlay.hide();
    });
  }


  Future<void> Favourite(BuildContext context, int articleid, int appuserid,
      int favourites, int position,
      {bool? isFavScreen}) async {
    int appuserids = await GetIntData("app_user_id");
    print("appuserid ${appuserids}");
    context.loaderOverlay.show();
    POST_API({
      "article_id": articleid,
      "app_user_id": appuserids,
      "is_favorite": favourites,
    }, Urls.Favourite, context)
        .then((response) {
      print("FAVOURITE response ----> $response");
      Map<String, dynamic> map = jsonDecode(response);

      if (map["status"] != true) {
        context.loaderOverlay.hide();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(map['message'])));
      } else {
        //print("articleid ${article_id.value}");
        if (isFavScreen ?? false) {
          favouriteList.removeAt(position);
          articleList.refresh();
        } else {
          if (favourites == 1) {
            articleList[position].is_favorite = 1;
            print("FAVOURITE response ----> 1");
          } else {
            articleList[position].is_favorite = 0;
            print("FAVOURITE response ----> 0");
          }
          articleList.refresh();
        }

        //articleList[position] == 1;
      }
      context.loaderOverlay.hide();
    });
  }

  Future<void> Favourite1(
      BuildContext context,
      int articleid,
      // int appuserid,
      int favourites,
      int position) async {
    int appuserids = await GetIntData("app_user_id");
    // context.loaderOverlay.show();
    POST_API({
      "article_id": article_id.value,
      "app_user_id": appuserids,
      "is_favorite": favourites,
    }, Urls.Favourite, context)
        .then((response) {
      print("FAVOURITE response ----> $response");
      Map<String, dynamic> map = jsonDecode(response);

      if (map["status"] != true) {
        context.loaderOverlay.hide();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(map['message'])));
      } else {
        //print("articleid ${article_id.value}");
        /* if (favourites == 1) {
          fav.value = 1;
          print("FAVOURITE response ----> 0");
        } else {
          fav.value = 0;
          print("FAVOURITE response ---->1");
        }*/
        if (position > 1) {
          if (favourites == 1) {
            articleList[position].is_favorite = 1;
            print("FAVOURITE response ----> 1");
          } else {
            articleList[position].is_favorite = 0;
            print("FAVOURITE response ----> 0");
          }
        }

        articleList.refresh();
        //articleList[position] == 1;
      }
      context.loaderOverlay.hide();
    });
  }

  void manageDeviceToken(
    BuildContext context,
    String deviceToken,
      {String? isdelete}
  ) {
    POST_API({
      "device_type": Platform.isIOS ? '2' : '1',
      "device_token": deviceToken,
      "is_delete": isdelete??'0'
    }, Urls.manage_device_token, context)
        .then((response) {
      Map<String, dynamic> map = jsonDecode(response);
      print('manageDeviceToken response ----> $response');
      print(map['message']);
    });
  }

  bool _checkEnd() {
    List end = ['mp4', 'wav', 'amr', 'ac4', 'ac3', 'mp3', 'avi'];
    bool isEnd = false;
    end.forEach((element) {
      if (youtube_url.value.endsWith(element)) {
        isEnd = true;
      }
    });

    return isEnd;
  }
}
