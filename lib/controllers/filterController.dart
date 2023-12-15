import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:luxury_council/api_config/api_services.dart';
import 'package:luxury_council/api_config/urls.dart';
import 'package:luxury_council/controllers/homeController.dart';
import 'package:luxury_council/models/categories/categorymodel.dart';
import 'package:luxury_council/models/categories/categoryrequest.dart';
import 'package:luxury_council/models/categories/categoryresponce.dart';
import 'package:luxury_council/models/interest/interestmodel.dart';
import 'package:luxury_council/models/interest/interestresponce.dart';
import 'package:luxury_council/models/mediatype/mediatypemodel.dart';
import 'package:luxury_council/models/mediatype/mediatyperesponce.dart';
import '../models/OwnerJobCategories.dart';
import '../models/interest/interestrequest.dart';

class FilterController extends GetxController {
  final HomeController homeController = Get.put(HomeController());
  RxList<CategorieModel> categorieList = <CategorieModel>[].obs;
  RxList<String> CategoryTextList = <String>[].obs;
  RxList<dynamic> CategorySelectedServices = <dynamic>[].obs;
  RxString selectedCategoryValuesToDisplay = "".obs;
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

  RxList<InterestModel> profileinterestList = <InterestModel>[].obs;
  RxList<String> profileIntersetTextList = <String>[].obs;
  RxList<dynamic> profileIntersetSelectedServices = <dynamic>[].obs;
  RxString profileselectedIntersetValuesToDisplay = "".obs;
  RxBool profileintersetresponce = true.obs;

  var categorys = ''.obs;
  var interests = ''.obs;
  var mediatypes = ''.obs;
  var profileinterests = ''.obs;

  List<Map<String,dynamic>> interestMap = [];

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
            homeController.CategorySelectedServices.value.add(element.jobCategoryName!);
            selectedCategoryValuesToDisplay.value += element.jobCategoryName! + ", ";
            homeController.selectedCategoryValuesToDisplay.value += element.jobCategoryName! + ", ";
          });
          selectedCategoryValuesToDisplay.value = selectedCategoryValuesToDisplay.value.replaceRange(selectedCategoryValuesToDisplay.value.length - 2, selectedCategoryValuesToDisplay.value.length, "",);
          homeController.selectedCategoryValuesToDisplay.value = homeController.selectedCategoryValuesToDisplay.value.replaceRange(homeController.selectedCategoryValuesToDisplay.value.length - 2, homeController.selectedCategoryValuesToDisplay.value.length,"",);
          homeController.updateScreen('home');
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

  getProfileIntersetList(
    BuildContext context,
    List<OwnerJobCategories>? ownerJobCategories,
    int page,
    int limit,
  ) {
    // context.loaderOverlay.show();
    print("PROFILE INTEREST LIST URL ----> ${Urls.INTEREST_LIST}");
    InterestRequest interestlistRequest = InterestRequest(
      page: page,
      limit: limit,
    );
    print("PROFILE INTEREST LIST URL ----> ${jsonEncode(interestlistRequest)}");
    POST_API(interestlistRequest, Urls.INTEREST_LIST, context).then((response) {
      print("PROFILE INTEREST LIST response ----> $response");
      IntersetResponce profileinterestlistResponse =
          IntersetResponce.fromJson(jsonDecode(response));
      Map<String, dynamic> map = jsonDecode(response);
      if (map["status"] != true) {
        profileintersetresponce = false.obs;
      } else {
        profileinterestList.clear();
        profileIntersetTextList.clear();
        profileIntersetSelectedServices.clear();
        // profileselectedIntersetValuesToDisplay.value = "";
        profileinterestList.value = profileinterestlistResponse.interestModel ?? [];
        print('profileinterestList.value >>> ${profileinterestList.value.length}');
        profileinterestList.value.forEach((element) {
          profileIntersetTextList.add(element.interestName ?? "");
        });
        var listSelected = profileselectedIntersetValuesToDisplay.value.split(', ');
        List<dynamic> list = [];
        profileIntersetTextList.forEach((element1) {
          listSelected.forEach((element) {
            if(element1==element){
              list.add(element1);
            }
          });
        });
        profileIntersetSelectedServices.value = list;
        if (ownerJobCategories != null) {
          ownerJobCategories.forEach((element) {
            profileIntersetSelectedServices.add(element.jobCategoryName!);
            profileselectedIntersetValuesToDisplay.value +=
                element.jobCategoryName! + ", ";
          });
          profileselectedIntersetValuesToDisplay.value =
              profileselectedIntersetValuesToDisplay.value.replaceRange(
            profileselectedIntersetValuesToDisplay.value.length - 2,
            profileselectedIntersetValuesToDisplay.value.length,
            "",
          );
        }
        // context.loaderOverlay.hide();

        // interestList.addAll((interestlistResponse.interestModel ?? []));
      }
      // context.loaderOverlay.hide();
    });
  }
}
