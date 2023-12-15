
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:luxury_council/models/aboutus_model.dart';

import '../api_config/api_services.dart';
import '../api_config/urls.dart';

class AboutUsController extends GetxController{
  RxBool aboutUsResponse = true.obs;
  Rx<AboutUsData?> aboutUs = AboutUsData().obs;

  void getAboutUsAPI(
      BuildContext context,
      ) {
    context.loaderOverlay.show();
    print("EVENT LIST URL ----> ${Urls.AboutUs}");

    GET_API(Urls.AboutUs, context)
        .then((response) {
      print("EVENT LIST response ----> $response");
      Map<String, dynamic> map = jsonDecode(response);
      if (map["status"] != true) {
        aboutUsResponse = false.obs;
      } else {
        AboutUsModel aboutUsModel = AboutUsModel.fromJson(jsonDecode(response));
        aboutUs.value = aboutUsModel.data;
       print(aboutUsResponse);
      }
      context.loaderOverlay.hide();
    });
  }

}