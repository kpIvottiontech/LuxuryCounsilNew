

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:luxury_council/models/recent_chat_model.dart';
import 'package:luxury_council/strings.dart';

import '../api_config/api_services.dart';
import '../api_config/urls.dart';
import '../colors.dart';
import '../models/chat/chat_listing_model.dart';

class ChatController extends GetxController{
  RxBool chatListingResponse = true.obs;
  RxList<ChatItems> chatListing = <ChatItems>[].obs;
  RxList<RecentChatData> recentChat = <RecentChatData>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;

  RxInt counts = 0.obs;
  RxInt checkChatId = 0.obs;

  getUserChatList(BuildContext context, int page, int subscriptionId ) async {
    if(page==1){
      context.loaderOverlay.show();
    }
   await POST_API({
      "page": page,
      "limit": 20,
      "subscription_id": subscriptionId,
    }, Urls.userChatListing, context)
        .then((response) {
      Map<String, dynamic> chatResponse = jsonDecode(response);

      if (chatResponse["data"].isEmpty) {
        context.loaderOverlay.hide();
        chatListing.clear();
        isLoading = false.obs;
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
            chatListing.clear();
          }
          for(int i=0;i<chatListingModel.data!.items!.length;i++){
            chatListing.add(chatListingModel.data!.items![i]);
          }
          isLastPage = (page >= chatListingModel.data!.totalPage!).obs;
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

   getRecentChat(BuildContext context,String userId) async {
   await POST_API({
      "app_user_id": userId,
    }, Urls.recentChat, context)
        .then((response) {
      Map<String, dynamic> chatResponse = jsonDecode(response);
      if (chatResponse["data"].isEmpty) {
       /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'No url found',
            style: TextStyle(color: AppColor.white),
          ),
        ));*/
      } else {
        if (chatResponse['status'] != true) {
         // chatListingResponse= false.obs;
        } else {
          RecentChatModel recentChatModel = RecentChatModel.fromJson(jsonDecode(response));
          recentChat.clear();
          for(int i=0;i<recentChatModel.data!.length;i++){
            recentChat.add(recentChatModel.data![i]);
            print('========================${recentChat.length}>> ${recentChat[i].appUserId}');
          }
          updateScreen('chat');
        }
      }

    }, onError: (e) {
          print('========================${e.toString()}');
      /*ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));*/
    });
  }

  updateScreen(String value) {
    update([value]);
  }
}