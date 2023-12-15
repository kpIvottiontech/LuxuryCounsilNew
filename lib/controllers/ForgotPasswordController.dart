
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:luxury_council/api_config/api_services.dart';
import 'package:luxury_council/colors.dart';
import '../api_config/urls.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController EmailController = TextEditingController();


  void forgotPassword(BuildContext context) {
    POST_API({
      "email": EmailController.text.toString(),
    }, Urls.ForgotPassword, context)
        .then((response) {
      Map<String, dynamic> forgotResponse = jsonDecode(response);

      if (forgotResponse['status'] == true) {
        context.loaderOverlay.hide();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(forgotResponse['message'])));
        Get.offAndToNamed("/Login");
      } else {
        context.loaderOverlay.hide();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(forgotResponse['message'])));
      }
    }, onError: (e) {
      context.loaderOverlay.hide();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
  }
}

