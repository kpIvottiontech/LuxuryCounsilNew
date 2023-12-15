import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:luxury_council/config/prefrance.dart';
import 'package:luxury_council/controllers/loginController.dart';

LoginController loginController = Get.put(LoginController());
dynamic POST_API(Object object, String baseurl, BuildContext context) async {
  if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
    context.loaderOverlay.hide();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Please check your internet connectivity."),
    ));
  } else {
    try {
      // print(jsonEncode(object));
      String accessToken = await GetData("ApiToken") ?? "";

      var url = Uri.parse(baseurl);
      print("token = Bearer $accessToken");
      print("url -->  $url");
      print("body --> ${jsonEncode(object)}");
      var res = await http.post(url, body: jsonEncode(object), headers: {
        "Authorization": "Bearer $accessToken",
        HttpHeaders.contentTypeHeader: "application/json"
      }).catchError((onError) {
        context.loaderOverlay.hide();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(onError.toString()),
        ));
      }).timeout(Duration(seconds: 500));
      // print(res.statusCode);
      print(res.body);
      return await handleresult(res);
    } on TimeoutException catch (_) {
      print('Please try again after some time');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please try again after some time"),
      ));
    }
  }
}

dynamic GET_API(String baseurl, BuildContext context) async {
  final connectivityResult = await (Connectivity().checkConnectivity());
//<<<<<<< HEAD
  if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
    print("NEt");
    context.loaderOverlay.hide();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Please check your internet connectivity."),
    ));
  } else {
    try {
      String accessToken = await GetData("ApiToken") ?? "";
      print("token = Bearer $accessToken");
      var url = Uri.parse(baseurl);
      print("url $url");
      var res = await http.get(url, headers: {
        // Base_Url.HEADER_TOKEN_KEY: logincontrollar.token.toString(),
        "Authorization": "Bearer $accessToken",
        HttpHeaders.contentTypeHeader: "application/json"
      }).catchError((onError) {
        context.loaderOverlay.hide();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(onError.toString()),
        ));
      }).timeout(Duration(seconds: 10));
      print(res.statusCode);
      return handleresult(res);
    } on TimeoutException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please try again after some time"),
      ));
    }
  }
}

dynamic handleresult(res) {
  if (res.statusCode == 201 || res.statusCode == 200) {
    print("Bussinesss");
    return res.body;
  } else {
    throw ('Something Went Wrong Status code: ${res.statusCode}');
  }
}

dynamic LOGIN_POST_API(
    Object object, String baseurl, BuildContext context) async {
  if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
    context.loaderOverlay.hide();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Please check your internet connectivity."),
    ));
  } else {
    try {
      // print(jsonEncode(object));
      String accessToken = await GetData("ApiToken") ?? "";

      var url = Uri.parse(baseurl);
      print("token = Bearer $accessToken");
      print("url -->  $url");
      print("body --> ${jsonEncode(object)}");
      var res = await http.post(url, body: jsonEncode(object), headers: {
        "Authorization": "Bearer $accessToken",
        HttpHeaders.contentTypeHeader: "application/json"
      }).catchError((onError) {
        context.loaderOverlay.hide();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(onError.toString()),
        ));
      }).timeout(Duration(seconds: 500));
      // print(res.statusCode);
      print(res.body);
      return await handleresultlogin(res);
    } on TimeoutException catch (_) {
      print('Please try again after some time');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please try again after some time"),
      ));
    }
  }
}

dynamic handleresultlogin(res) {
  if (res.statusCode == 201 || res.statusCode == 200) {
    print("Bussinesss");
    return res.body;
  } else if (res.statusCode == 401) {
    Map<String, dynamic> logindetails = jsonDecode(res.body);
    print('------------------------${logindetails}');
    throw logindetails['message'];
  } else {
    throw ('Something Went Wrong Status code: ${res.statusCode}');
  }
}
