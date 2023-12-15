import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:luxury_council/api_config/api_services.dart';
import 'package:luxury_council/api_config/urls.dart';
import 'package:luxury_council/constance/global_data.dart';

import '../config/prefrance.dart';

class PaymentController extends GetxController {
  var cardNumber = ''.obs;
  var expiryDate = ''.obs;
  var cvvCode = ''.obs;
  var amount = ''.obs;
  var subscription_id = 0.obs;
  var subscription_type = 0.obs;
  var transactionid = ''.obs;
  var datetime = ''.obs;

   RxInt idds = 0.obs;
  RxInt mytype = 0.obs;


  void getPayment(
    BuildContext context,
    String card_number,
    String exp_date,
    String code,
    String amount,
    int subscription_id,
    int subscription_type,
  ) {
    // notifyDataBox = Hive.box('notifyData');
    context.loaderOverlay.show();
    print("PAYMENT URL ----> ${Urls.PAYMENT}");
    print('subscription_type ----> $subscription_type');
    POST_API({
      "card_number": card_number,
      "exp_date": exp_date,
      "code": code,
      "amount": amount,
      "subscription_id": idds.value,
      "subscription_type": subscription_type
    }, Urls.PAYMENT, context)
        .then((response) async {
      print("PAYMENT response ----> $response");
      Map<String, dynamic> map = jsonDecode(response);
      if (map["status"] != true) {
        context.loaderOverlay.hide();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(map['message'])));
      } else {
        if(map["data"]["transaction_id"] == null){
          var rnd = Random();
          var next = rnd.nextDouble() * 1000000;
          while (next < 100000) {
            next *= 10;
          }
          transactionid.value = next.toString();
        }
        else{
          transactionid.value = map["data"]["transaction_id"] ?? '';
        }

        datetime.value = map["data"]["created_at"] ?? '';
        GlobalData().subscriptionId =idds.value;
        SetIntData("subscription_id", idds.value);
        SetIntData(
            "subscription_type",subscription_type);
        print('created_at----------${datetime}');
         print('subsid----------${idds.value}');
       // notifyDataBox.clear();
        Get.toNamed("/Payment");
      }
      context.loaderOverlay.hide();
    }, onError: (error) {
      print("Error ---> ${error}");
      context.loaderOverlay.hide();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    });
  }
}
