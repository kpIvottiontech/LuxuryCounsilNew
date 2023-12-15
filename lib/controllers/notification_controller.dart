
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:luxury_council/config/prefrance.dart';
import 'package:luxury_council/controllers/homeController.dart';
import 'package:luxury_council/models/articlelist/articlelistmodel.dart';
import 'package:luxury_council/models/notification_list/notification_list_response.dart';
import 'package:luxury_council/models/subscription_model.dart';

import '../api_config/api_services.dart';
import '../api_config/urls.dart';

class NotificationController extends GetxController{
  final HomeController homeController = Get.put(HomeController());
  RxBool notificationResponse = true.obs;
  StreamController<List<Artical>> notificationStreamController = StreamController<List<Artical>>.broadcast();
  Stream<List<Artical>> get notificationStream => notificationStreamController.stream;
  RxList<Artical> articleData = <Artical>[].obs;
  RxInt notificationCount = 0.obs;

  onInit() {
    super.onInit();
  }



  updateScreen(String value) {
    update([value]);
  }

  getNotificationListing(
      BuildContext context) async {
    context.loaderOverlay.show();
    print("EVENT LIST URL ----> ${Urls.NotificationList}");
    await GET_API(Urls.NotificationList, context)
        .then((response) {
      print("EVENT LIST response ----> $response");
      if (response != null) {
        Map<String, dynamic> map = jsonDecode(response);
        if (map["status"] != true) {
          notificationResponse = false.obs;
          context.loaderOverlay.hide();
        }
        else {
          print('check noti length>>@@@@ ${articleData.length}');
          if((map["status"] == true) && (map["data"] != null) && (map["message"] != "Not Found")){
            print('here>> ${map["data"]}');
            NotificationListResponse responseData = NotificationListResponse.fromJson(jsonDecode(response));
            articleData.clear();
            for (var item in responseData.data!) {
              articleData.add(item.artical!);
              print('notificationResponse>>>> ${articleData.first.articleName}');
            }
            notificationStreamController.sink.add(articleData);
            updateNotificationCount(articleData.length,'no');
            SetIntData("notiCount",articleData.length ?? 0);
            updateScreen('notification');
          }
          else{
            notificationCount.value = 0;
            print('no data found');
            updateScreen('notification');
          }
          context.loaderOverlay.hide();
        }
      }
      else{
        context.loaderOverlay.hide();
      }
    });
  }

  Future<void> updateNotificationCount(int count,String preference) async {
    if (preference == 'no') {
      notificationCount.value = count;
      updateScreen('home');
    } else {
      notificationCount.value = await GetIntData("notiCount") ?? 0;
    }
  }

   deleteNotification(
      BuildContext context,
 String articleId,) {
    POST_API({
      "article_id": articleId.toString()
     // "article_id":"['834']"
    }, Urls.DeleteNotification, context)
        .then((response) {
      print('DeleteNotification response ----> $response');
      Map<String, dynamic> map = jsonDecode(response);
      print(map['message']);
    });
  }

}