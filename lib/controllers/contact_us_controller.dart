
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:luxury_council/api_config/api_services.dart';
import '../api_config/urls.dart';

class ContactUsController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  RxString countryCode = '+1'.obs;

  void contactUs(BuildContext context) {
    print('>> ${countryCode.value}${phoneNumberController.text.toString()}');
    POST_API({
      "name": nameController.text.toString(),
      "email": emailController.text.toString(),
      "phone_number": "${countryCode.value} ${phoneNumberController.text.toString()}",
      "message": messageController.text.toString(),
    }, Urls.ContactUs, context)
        .then((response) {
      Map<String, dynamic> contactUsResponse = jsonDecode(response);

      if (contactUsResponse['status'] != true) {
        context.loaderOverlay.hide();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Please try again after some time')));
      } else {

        context.loaderOverlay.hide();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(contactUsResponse['message'])));
        Get.toNamed("/HomeWithSignUp");

        emailController.clear();
        nameController.clear();
        phoneNumberController.clear();
        messageController.clear();
      }
    }, onError: (e) {
      context.loaderOverlay.hide();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
  }
}
