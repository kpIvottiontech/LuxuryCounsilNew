
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:luxury_council/models/subscription_model.dart';

import '../api_config/api_services.dart';
import '../api_config/urls.dart';

class SubscriptionController extends GetxController{
  RxBool subscriptionResponse = true.obs;
  RxList<SubscriptionData> subscriptionData = <SubscriptionData>[].obs;

  void getSubscriptionListing(
      BuildContext context,
      ) {
    context.loaderOverlay.show();
    print("EVENT LIST URL ----> ${Urls.SubscriptionList}");
 
    GET_API(Urls.SubscriptionList, context)
        .then((response) {
      print("EVENT LIST response ----> $response");
      Map<String, dynamic> map = jsonDecode(response);
      if (map["status"] != true) {
        subscriptionResponse = false.obs;
      } else {
        SubscriptionModel responseData = SubscriptionModel.fromJson(jsonDecode(response));
        subscriptionData.clear();
        subscriptionData.addAll(responseData.data ?? []);
        print(subscriptionResponse);
      }
      context.loaderOverlay.hide();
    });
  }

}