
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:luxury_council/constance/global_data.dart';
import 'package:luxury_council/controllers/homeController.dart';
import 'package:luxury_council/strings.dart';

import '../api_config/api_services.dart';
import '../api_config/urls.dart';
import '../colors.dart';
import '../models/spotlight_listing_model.dart';

class SpotlightListingController extends GetxController{
  HomeController homeController = Get.put(HomeController());
  RxBool spotlightListResponse = true.obs;
  RxList<SpotlightData> spotlightListing= <SpotlightData>[].obs;
  RxList<SpotlightData> spotlightListingData = <SpotlightData>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  RxInt randomNumber = 0.obs;

  void getSpotlightListing(BuildContext context, int page) {
    if(page==1){
      context.loaderOverlay.show();
    }
    POST_API({
      "page": page,
      "limit": 20,
    }, Urls.SpotlightListing, context)
        .then((response) {
      Map<String, dynamic> spotlightResponse = jsonDecode(response);

      if (spotlightResponse["data"].isEmpty) {
        context.loaderOverlay.hide();
        spotlightListing.clear();
        isLoading = false.obs;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            noSpotlightFound,
            style: TextStyle(color: AppColor.white),
          ),
        ));
      } else { 
        if (spotlightResponse['status'] != true) {
          spotlightListResponse= false.obs;
        } else {
          if(page==1){
            spotlightListing.clear();
          }
          SpotlightListingModel spotlightListingModel = SpotlightListingModel.fromJson(jsonDecode(response));
          spotlightListing.addAll(spotlightListingModel.data?.items ?? []);
          isLastPage = (page >= spotlightListingModel.data!.totalPage!).obs;
        }
        isLoading = false.obs;
        context.loaderOverlay.hide();
      }

    }, onError: (e) {
      context.loaderOverlay.hide();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
  }

  void getSpotlightListingWithOutPagination(BuildContext context,) {
      context.loaderOverlay.show();
    POST_API({
      "page": '',
      "limit": '',
    }, Urls.SpotlightListing, context)
        .then((response) {
      Map<String, dynamic> spotlightResponse = jsonDecode(response);

      if (spotlightResponse["data"].isEmpty) {
        context.loaderOverlay.hide();
        spotlightListingData.clear();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            noSpotlightFound,
            style: TextStyle(color: AppColor.white),
          ),
        ));
      } else {
        if (spotlightResponse['status'] != true) {
          spotlightListResponse= false.obs;
        } else {
          SpotlightListingModel spotlightListingModel = SpotlightListingModel.fromJson(jsonDecode(response));
          spotlightListingData.value.addAll(spotlightListingModel.data?.items ?? []);

          GlobalData().spotlightListing = spotlightListingData;
          Random random = new Random();
          randomNumber = random.nextInt(spotlightListingData.length).obs;
          homeController.updateScreen('home');
        }
        context.loaderOverlay.hide();
      }

    }, onError: (e) {
      context.loaderOverlay.hide();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
  }
}