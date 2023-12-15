

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:luxury_council/strings.dart';

import '../api_config/api_services.dart';
import '../api_config/urls.dart';
import '../colors.dart';
import '../constance/global_data.dart';
import '../models/chat/chat_listing_model.dart';

class SearchChatController extends GetxController{
  RxBool chatListingResponse = true.obs;
  RxList<ChatItems> searchChatListing= <ChatItems>[].obs;
  RxBool isLoadingSearch = false.obs;
  RxBool isLastPageSearch = false.obs;

  void getUserChatListWithSearching(BuildContext context, int page, int subscriptionId,String search) {

    POST_API({
      "page": page,
      "limit": 20,
      "subscription_id": GlobalData().subscriptionId,
      "search_text" : search
    }, Urls.userChatListing, context)
        .then((response) {
      Map<String, dynamic> chatResponse = jsonDecode(response);

      if (chatResponse["data"].isEmpty) {
        context.loaderOverlay.hide();
        searchChatListing.clear();
        isLoadingSearch = false.obs;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            noChatFound,
            style: TextStyle(color: AppColor.white),
          ),
        ));
      } else {
        if (chatResponse['status'] != true) {
          chatListingResponse= false.obs;
        } else {
          ChatListingModel chatListingModel = ChatListingModel.fromJson(jsonDecode(response));
          if(page ==1){
            searchChatListing.clear();
          }
          searchChatListing.addAll(chatListingModel.data?.items ?? []);
          isLastPageSearch = (page >= chatListingModel.data!.totalPage!).obs;
        }
        isLoadingSearch = false.obs;
        context.loaderOverlay.hide();
      }

    }, onError: (e) {
      context.loaderOverlay.hide();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
  }
}