import 'dart:convert';
import 'dart:developer' as Log;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:luxury_council/api_config/api_services.dart';
import 'package:luxury_council/api_config/urls.dart';
import 'package:luxury_council/config/prefrance.dart';
import 'package:luxury_council/config/utils.dart';
import 'package:luxury_council/controllers/filterController.dart';
import '../colors.dart';

class RegisterController extends GetxController {
  final FilterController filterController = Get.put(FilterController());
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController companyontroller = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController phonenoController = TextEditingController();
  TextEditingController mailingaddressController = TextEditingController();
  TextEditingController assistantnameController = TextEditingController();
  TextEditingController assistantemailController = TextEditingController();
  TextEditingController assistantphonenoController = TextEditingController();
  TextEditingController birthDateCtr = TextEditingController();
  TextEditingController spouceNameCtr = TextEditingController();
  TextEditingController spoucebirthDateCtr = TextEditingController();
  var childrenname = [TextEditingController()].obs;
  var childrendate = [TextEditingController()].obs;
  var appuserstatusController = 1.obs;
  var subscriptionstartdateController = ''.obs;

  String contactCountryCode = 'US';
  String assistantCountryCode = 'US';

  RxBool onBtnClick = false.obs;

  /*getIdsInterest(){
    filterController.interestList.value.map((e) => e.interestName == )
  }*/

  updateScreen(String value) {
    update([value]);
  }

  void Register(
    BuildContext context,
      String interest
  ) async {
    onBtnClick.value = true;
    List<dynamic> children = [];
    for (int i = 0; i < childrenname.length; i++) {
      if(childrenname[i].text.isNotEmpty &&  childrendate[i].text.isNotEmpty ){
        children.add({
          "name": childrenname[i].text.toString(),
          "birthday":childrendate[i].text.toString()!=''?Utils.yyyymmdddateFormate(childrendate[i].text.toString(),):'',
        });
      }
    }
    print('contactCountryCode $contactCountryCode >> $assistantCountryCode');
    Object registerrequest = {
      "first_name": firstnameController.value.text,
      "last_name": lastnameController.value.text,
      "email": emailController.value.text,
      "password": passwordController.value.text,
      "company": companyontroller.value.text,
      "title": titleController.value.text,
      "country_code": contactCountryCode,
      "phone_no": phonenoController.value.text,
      "mailing_address": mailingaddressController.value.text,
      "assistant_name": assistantnameController.value.text,
      "assistant_email": assistantemailController.value.text,
      "assistant_country_code": assistantCountryCode,
      "assistant_phone_no": assistantphonenoController.value.text,
      "app_user_status": appuserstatusController.value,
      "subscription_start_date": subscriptionstartdateController.value,
      "birthday":birthDateCtr.value.text.toString()!= ''?Utils.yyyymmdddateFormate(birthDateCtr.value.text.toString()):'',
    "business_interests": interest,
      "spouse_name": spouceNameCtr.value.text.toString(),
      "spouse_birthday":spoucebirthDateCtr.value.text.toString()!= ''? Utils.yyyymmdddateFormate( spoucebirthDateCtr.value.text.toString(),):'',
      "children": children
    };
    print("register Body Request ---> ${jsonEncode(registerrequest)}");
    POST_API(registerrequest, Urls.REGISTER, context).then((response) {
      context.loaderOverlay.hide();
      //Navigator.pop(context);
      Log.log("Register response ---> $response");
      Map<String, dynamic> registerdetails = jsonDecode(response);
      if (registerdetails["status"] != true) {
        onBtnClick.value = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(registerdetails["message"]),
        ));
      } else {
        SetData("Email", emailController.text.toString());
        SetData("Password", passwordController.text.toString());
        SetData("first_name", firstnameController.text.toString());
        SetData("last_name", lastnameController.text.toString());
        SetData("company", companyontroller.text.toString());
        SetData("title", titleController.text.toString());
        SetData("phone_no", phonenoController.text.toString());
        SetData("mailing_address", mailingaddressController.text.toString());
        SetData("assistant_name", assistantnameController.text.toString());
        SetData("assistant_email", assistantemailController.text.toString());
        SetData(
            "assistant_phone_no", assistantphonenoController.text.toString());
        SetData("app_user_status", appuserstatusController.value.toString());
        SetData("subscription_start_date",
            subscriptionstartdateController.value.toString());
        SetData("birthday", birthDateCtr.text.toString());
        SetData("spousename", spouceNameCtr.text.toString());
        SetData("spouse_birthday", spoucebirthDateCtr.text.toString());
        SetData("children", children.toString());
        print("children${children.toString()}");
        onBtnClick.value = false;

        // firstnameController.clear();
        // lastnameController.clear();
        // emailController.clear();
        // passwordController.clear();
        // companyontroller.clear();
        // titleController.clear();
        // phonenoController.clear();
        // mailingaddressController.clear();
        // assistantemailController.clear();
        // assistantphonenoController.clear();
        // subscriptionidController.clear();
        // subscriptiontypeController.clear();
        // appuserstatusController.clear();
        // subscriptionstartdateController.clear();
        context.loaderOverlay.hide();
        Get.back();
        Get.offAndToNamed(
          "/Login",
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 1),
          content: Text(
            'Register Successfully',
            style: TextStyle(color: AppColor.white),
          ),
        ));
      }
    },
        onError: (error) {
      onBtnClick.value = false;
      Get.back();
      print("RegisterError ---> ${error}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
      context.loaderOverlay.hide();
    });
  }
}
