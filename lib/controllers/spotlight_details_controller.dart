

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../api_config/api_services.dart';
import '../api_config/urls.dart';
import '../models/spotlight_listing_model.dart';

class SpotlightDetailsController extends GetxController{
  RxBool spotlightDetailsResponse = true.obs;
  String name = '';
  Rx<SpotlightData?> spotlightData = SpotlightData().obs;

  getSpotlightDetails(
      BuildContext context,
      int id
      ) async {
    context.loaderOverlay.show(); 
   await POST_API(
      {
        'spotlight_member_id':id
      }
    ,Urls.SpotlightDetails, context)
        .then((response) {
      print("EVENT LIST response ----> $response");
      Map<String, dynamic> map = jsonDecode(response);
      if (map["status"] != true) {
        spotlightDetailsResponse = false.obs;
      } else {
        SpotlightData spotlightModel = SpotlightData.fromJson(map["data"]);
        spotlightData.value = spotlightModel;
        name = spotlightModel.spotlightMemberContactName ?? '';
        print(spotlightModel);
        updateScreen('spotlight');
      }
      context.loaderOverlay.hide();
    });
  }
  updateScreen(String value) {
    update([value]);
  }

  void sendSpotlightMail(BuildContext context, String mail, String content) {
    context.loaderOverlay.show();
    POST_API({
      "email": mail,
      "content": content,
      //"LoginProvider": ""
    }, Urls.SendSpotlightMail, context)
        .then((response) {
      Map<String, dynamic> spotlightResponse = jsonDecode(response);

      if (spotlightResponse['status'] != true) {
        context.loaderOverlay.hide();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(spotlightResponse['message'])));
      } else {
        context.loaderOverlay.hide();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(spotlightResponse['message'])));
        Get.back();
      }
    }, onError: (e) {
      context.loaderOverlay.hide();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
  }
}