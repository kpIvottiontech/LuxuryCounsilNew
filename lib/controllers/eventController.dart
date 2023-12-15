import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:luxury_council/api_config/api_services.dart';
import 'package:luxury_council/api_config/urls.dart';
import 'package:luxury_council/models/articledetailslist/articledetailslistrequest.dart';
import 'package:luxury_council/models/articledetailslist/articledetailslistresponce.dart';
import 'package:luxury_council/models/articlelist/articlelistrequest.dart';
import 'package:luxury_council/models/articlelist/articlelistresponce.dart';
import 'package:luxury_council/models/categories/categorymodel.dart';
import 'package:luxury_council/models/categories/categoryrequest.dart';
import 'package:luxury_council/models/categories/categoryresponce.dart';
import 'package:luxury_council/models/eventdetailslist/eventdetailslistrequest.dart';
import 'package:luxury_council/models/eventlist/eventlistmodel.dart';
import 'package:luxury_council/models/eventlist/eventlistresponce.dart';
import 'package:luxury_council/models/nonsubscriberartilcle/nonsubscriberesponce.dart';
import 'package:luxury_council/models/nonsubscriberartilcle/nonsubscribermodel.dart';

import '../colors.dart';
import '../models/OwnerJobCategories.dart';
import '../models/articledetailslist/articledetailslistmodel.dart';
import '../models/articlelist/articlelistmodel.dart';
import '../strings.dart';

class EventController extends GetxController {
  RxList<EventListModel> eventList = <EventListModel>[].obs;
  RxBool eventlistresponce = true.obs;
  RxBool eventdetailslistresponce = true.obs;
  var event_id = 0.obs;
  var event_name = ''.obs;
  var event_date = ''.obs;
  var event_detail = ''.obs;
  var hash_tags = ''.obs;
  var event_status = 0.obs;
  
  

  void getEventList(
    BuildContext context,
     int page,
    int limit,
  ) {
    context.loaderOverlay.show();
    print("EVENT LIST URL ----> ${Urls.EVENT_LIST}");
    
    POST_API({"page": page,"limit": limit,}, Urls.EVENT_LIST, context)
        .then((response) {
      print("EVENT LIST response ----> $response");
      Map<String, dynamic> map = jsonDecode(response);
      if (map["data"].isEmpty) {
        context.loaderOverlay.hide();
        eventList.clear();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            noEventFound,
            style: TextStyle(color: AppColor.white),
          ),
        ));
      }
      else{
        if (map["status"] != true) {
          eventlistresponce = false.obs;
        }
        else {
          EventListResponce eventlistResponse =
          EventListResponce.fromJson(jsonDecode(response));
          eventlistresponce.value = true;
         // eventList.clear();
          eventList.addAll((eventlistResponse.eventlistModel ?? []));
        }
      }

      context.loaderOverlay.hide();
    });
  }

  void getArticleDetailsList(
    BuildContext context,
    int eventid,
  ) {
    context.loaderOverlay.show();
    print("EVENT DETAILS LIST URL ----> ${Urls.EVENT_DETAILS_LIST}");
    EventDetailsListRequest eventdetailslistRequest =
        EventDetailsListRequest(eventid: eventid);
    print(
        "EVENT DETAILS LIST URL ----> ${jsonEncode(eventdetailslistRequest)}");
    POST_API(eventdetailslistRequest, Urls.EVENT_DETAILS_LIST, context)
        .then((response) {
      print("EVENT DETAILS LIST response ----> $response");
      Map<String, dynamic> map = jsonDecode(response);
      if (map["status"] != true) {
        eventdetailslistresponce = false.obs;
      } else {
        event_id.value = map['data']['event_id'];
        event_name.value = map['data']['event_name'];
        event_date.value = map['data']['event_date'];
        event_detail.value = map['data']['event_detail'];
        hash_tags.value = map['data']['hash_tags'];
        event_status.value = map['data']['event_status'];

        

        print("===========${map['data']['event_id']}");
      }
      context.loaderOverlay.hide();
    },onError: (error) {
      print("Error ---> ${error}");
      context.loaderOverlay.hide();
    });
  }

  
}
