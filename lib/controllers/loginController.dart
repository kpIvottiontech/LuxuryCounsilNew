/*import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:luxury_council/api_config/api_services.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/config/prefrance.dart';
import 'package:luxury_council/constance/global_data.dart';
import 'package:luxury_council/linkedin_screen.dart';
import 'package:luxury_council/models/login/LoginModel.dart';
import 'package:luxury_council/screens/custom_alert.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import '../api_config/urls.dart';
import '../constance/firestore_constants.dart';
import '../social_login.dart';

class LoginController extends GetxController {
  TextEditingController LoginEmailController = TextEditingController();
  TextEditingController LoginPasswordController = TextEditingController();
  var appuserid = 0.obs;
  var subscriptionid = 0.obs;
  var subscriptiontype = 0.obs;
  var deviceType = 0.obs;
  var devicetoken = ''.obs;
  Future<String?> _getId() async {
    print("ios device type---- on click");
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceType.value = 2;
      // print("ios device type==${deviceType.value}");
      // print("ios id-==${iosDeviceInfo.identifierForVendor}");
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceType.value = 1;
      // print("android device type==-${deviceType.value}");
      // print("android id==${androidDeviceInfo.id}");
      return androidDeviceInfo.id; // unique ID on Android
    }
  }

  void login(BuildContext context, String firebaseToken, String from,
      {FacebookUserProfile? facebookData,
      String? socialType,
      String? facebookEmail,
      User? user,
      UserInfoModel? linkedinUser,
      AppleIdCredential? appleUser}) {
    // _getId();

    Map<String, dynamic> requestParam;
    if (from == 'emai_login') {
      requestParam = {
        "email": LoginEmailController.text.toString(),
        "password": LoginPasswordController.text.toString(),
        "device_type": Platform.isIOS? '2' : '1',
        "device_token": (firebaseToken.isNotEmpty) ? firebaseToken : ((Platform.isIOS) ? 'iOS' : 'android')
      };
    } else {
      String firstName = '';
      String lastName = '';
      if (socialType == 'linkedin') {
        var name = linkedinUser?.name.split(' ');
        firstName = name[0];
        lastName = name[1];
      }
      requestParam = {
        "social_id": (socialType == 'facebook')
            ? facebookData?.userId.toString()
            : (socialType == 'google')
                ? user?.providerData[0].uid
                : (socialType == 'linkedin')
                    ? linkedinUser?.sub.toString()
                    : (socialType == 'apple_sign_in')
                        ? appleUser?.user
                        : '',
        "social_type": socialType.toString(),
        "first_name": (socialType == 'facebook')
            ? facebookData?.firstName.toString()
            : (socialType == 'google')
                ? user?.displayName
                : (socialType == 'linkedin')
                    ? firstName
                    : (socialType == 'apple_sign_in')
                        ? appleUser?.fullName?.givenName
                        : '',
        "last_name": (socialType == 'facebook')
            ? facebookData?.lastName.toString()
            : (socialType == 'linkedin')
                ? lastName
                : (socialType == 'apple_sign_in')
                    ? appleUser?.fullName?.familyName
                    : '',
        "email": (socialType == 'facebook')
            ? ((facebookEmail != null) ? facebookEmail.toString() : '')
            : (socialType == 'google')
                ? user?.email
                : (socialType == 'linkedin')
                    ? linkedinUser?.email
                    : (socialType == 'apple_sign_in')
                        ? appleUser?.email
                        : '',
        "phone_no": (socialType == 'google')
            ? (user?.phoneNumber != null ? user?.phoneNumber : '')
            : ''
      };
    }
    LOGIN_POST_API(requestParam,
            (from == 'emai_login') ? Urls.LOGIN : Urls.SocialLoginApi, context)
        .then((response) {
      print("----------${response}");
      Map<String, dynamic> logindetails = jsonDecode(response);
      print("----------------${logindetails}");

      if (logindetails['status'] != true) {
        print("----------------${logindetails['status'] != true}");
        context.loaderOverlay.hide();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
          logindetails['message'], style: TextStyle(color: AppColor.white),),
        ));
      } else {
        LoginModel loginResponse = LoginModel.fromJson(jsonDecode(response));

        SetData("ApiToken", loginResponse.token ?? "");
        print("Token :-----> ${loginResponse.token}");
        SetData("Email", LoginEmailController.text.toString());

        SetData("Password", LoginPasswordController.text.toString());
        SetData("first_name", loginResponse.user?.firstName.toString() ?? '');
        SetData("last_name", loginResponse.user?.lastName.toString() ?? '');
        SetIntData(
            "subscription_id",
            loginResponse.user?.subscriptionExpired == 1
                ? 0
                : (loginResponse.user?.subscriptionId ?? 0));
        SetIntData(
            "subscription_type", loginResponse.user?.subscriptionType ?? 0);
        SetIntData("app_user_id", loginResponse.user?.appUserId ?? 0);
        SetData("facebook_id", loginResponse.user?.facebookId ?? '');
        SetData("google_id", loginResponse.user?.googleId ?? '');
        SetData("linkedin_id", loginResponse.user?.linkedinId ?? '');
        print("google----${loginResponse.user?.googleId}");
        GlobalData().subscriptionId = loginResponse.user?.subscriptionExpired == 1 ? 0 : (loginResponse.user?.subscriptionId ?? 0);
        GlobalData().groupSubscriptionId = loginResponse.user?.groupSubscriptionId ?? 0;
        GlobalData().userId = loginResponse.user?.appUserId ?? 0;
        // print("Login Response ---> ${jsonEncode(loginResponse.loginUserDetails)}");
        final FirebaseFirestore firebaseFirestore;

        firebaseFirestore = FirebaseFirestore.instance;

        firebaseFirestore
            .collection(FirestoreConstants.pathUserCollection)
            .doc(loginResponse.user?.appUserId.toString())
            // .collection(FirestoreConstants.chatList)
            // .doc(firebaseUser.data?.uniqueId.toString())
            .set({
          FirestoreConstants.nickname:
              '${loginResponse.user?.firstName} ${loginResponse.user?.lastName}',
          FirestoreConstants.photoUrl: '',
          FirestoreConstants.isOnline: 1,
          FirestoreConstants.id: loginResponse.user?.appUserId,
          FirestoreConstants.deviceToken: firebaseToken,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          FirestoreConstants.chattingWith: null
        });
        *//* if (loginResponse.user!.subscriptionId == null) {
          SetIntData("subscriptionId", 0);
        } else {
          SetIntData("subscriptionId", loginResponse.user!.subscriptionId!);
        }*//*

      //  deviceId.value = _getId().toString();
        appuserid.value = loginResponse.user!.appUserId ?? 0;
        print("appuserid-------- ${appuserid.value}");
        subscriptionid.value = loginResponse.user!.subscriptionId ?? 0;
        print("subscriptionid--------- ${subscriptionid.value}");
        subscriptiontype.value = loginResponse.user!.subscriptionType ?? 0;
        print("subscriptiontype---------- ${subscriptiontype.value}");
        context.loaderOverlay.hide();
        Get.back();
        if (loginResponse.user?.subscriptionExpired == 1 ||
            loginResponse.user!.subscriptionId == null) {
          Get.offAndToNamed("/HomeWithoutSignUp");
        } else {
          if(loginResponse.user?.subscriptionExpired == 0 && loginResponse.user?.groupSubscriptionId != 0){
            Get.offAndToNamed("/HomeWithSignUp");
          }else if(loginResponse.user?.subscriptionExpired == 0 && loginResponse.user?.groupSubscriptionId == 0){
            Get.offAndToNamed("/HomeWithoutSignUp");
          }else if(loginResponse.user?.subscriptionExpired == 1 && loginResponse.user?.groupSubscriptionId != 0) {
            CustomAlert.showAlert(
                context, 'Your subscription has been expired.',
                title: 'Luxury Council', btnFirst: 'Ok', handler: (int index) {
            });
          }

        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 1),
          content: Text(
            logindetails['message'],
            style: TextStyle(color: AppColor.white),
          ),
        ));
        LoginEmailController.clear();
        LoginPasswordController.clear();
      }
    }, onError: (e) {
      context.loaderOverlay.hide();
      print('object${e.toString()}');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
  }

  void logOut(
    BuildContext context,
  ) {
    context.loaderOverlay.show();
    print("LOGOUT----> ${Urls.log_out}");

    POST_API({
      "device_type": deviceType.value.toString(),
      "device_token": devicetoken.value.toString()
    }, Urls.log_out, context)
        .then((response) {
      print("c-> $response");
      Map<String, dynamic> map = jsonDecode(response);

      if (map["status"] != true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(map["message"]),
        ));
      } else {
        RemoveData('facebook_id');
        SocialLogin().facebookLogin?.logOut();
        RemoveData('google_id');
        SocialLogin().googleSignIn.signOut();
        SocialLogin().logoutUser = true;
        SocialLogin().user = null;
        RemoveData('linkedin_id');
        RemoveData("Email");
        RemoveData("Password");
        FirebaseFirestore.instance
            .collection(FirestoreConstants.pathUserCollection)
            .doc(GlobalData().userId.toString())
            .update({FirestoreConstants.isOnline: 0,
          FirestoreConstants.deviceToken:''
        });
        Navigator.pop(context);
        Get.offAllNamed("/Login");
      }

      context.loaderOverlay.hide();
    });
  }
}*/

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:luxury_council/api_config/api_services.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/config/prefrance.dart';
import 'package:luxury_council/constance/global_data.dart';
import 'package:luxury_council/controllers/homeController.dart';

import 'package:luxury_council/models/login/LoginModel.dart';
import 'package:luxury_council/screens/custom_alert.dart';
import 'package:luxury_council/screens/linkedin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import '../api_config/urls.dart';
import '../constance/firestore_constants.dart';
import '../social_login.dart';

class LoginController extends GetxController {
  TextEditingController LoginEmailController = TextEditingController();
  TextEditingController LoginPasswordController = TextEditingController();
  final HomeController homeController = Get.put(HomeController());
  var appuserid = 0.obs;
  var subscriptionid = 0.obs;
  var subscriptiontype = 0.obs;
  var deviceType = 0.obs;
  var devicetoken = ''.obs;

  Future<String?> getId() async {
    print("ios device type---- on click");
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceType.value = 2;
      // print("ios device type==${deviceType.value}");
      // print("ios id-==${iosDeviceInfo.identifierForVendor}");
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceType.value = 1;
      // print("android device type==-${deviceType.value}");
      // print("android id==${androidDeviceInfo.id}");
      return androidDeviceInfo.id; // unique ID on Android
    }
  }

  Future<void> login(BuildContext context, String firebaseToken, String from,
      {FacebookUserProfile? facebookData,
        String? socialType,
        String? facebookEmail,
        User? user,
        UserInfoModel? linkedinUser,
        AppleIdCredential? appleUser}) async {
   await getId();
    print("android device type----${deviceType.value}");
    print("token----${devicetoken.value}");

    Map<String, dynamic> requestParam;
    if (from == 'emai_login') {
      requestParam = {
        "email": LoginEmailController.text.toString(),
        "password": LoginPasswordController.text.toString(),
       // "device_type": deviceType.value.toString(),
        "device_type": Platform.isIOS ? 2 : 1,
        "device_token": devicetoken.value.toString()
      };

    } else {
      String firstName = '';
      String lastName = '';
      if (socialType == 'linkedin') {
        var name = linkedinUser?.name.split(' ');
        firstName = name[0];
        lastName = name[1];
        SetIntData("isLogin", 1);
      }
      requestParam = {
        "social_id": (socialType == 'facebook')
            ? facebookData?.userId.toString()
            : (socialType == 'google')
            ? user?.providerData[0].uid
            : (socialType == 'linkedin')
            ? linkedinUser?.sub.toString()
            : (socialType == 'apple_sign_in')
            ? appleUser?.user
            : '',
        "social_type": socialType.toString(),
        "first_name": (socialType == 'facebook')
            ? facebookData?.firstName.toString()
            : (socialType == 'google')
            ? user?.displayName
            : (socialType == 'linkedin')
            ? firstName
            : (socialType == 'apple_sign_in')
            ? appleUser?.fullName?.givenName
            : '',
        "last_name": (socialType == 'facebook')
            ? facebookData?.lastName.toString()
            : (socialType == 'linkedin')
            ? lastName
            : (socialType == 'apple_sign_in')
            ? appleUser?.fullName?.familyName
            : '',
        "email": (socialType == 'facebook')
            ? ((facebookEmail != null) ? facebookEmail.toString() : '')
            : (socialType == 'google')
            ? user?.email
            : (socialType == 'linkedin')
            ? linkedinUser?.email
            : (socialType == 'apple_sign_in')
            ? appleUser?.email
            : '',
        "phone_no": (socialType == 'google')
            ? (user?.phoneNumber != null ? user?.phoneNumber : '')
            : ''


      };
    }
    LOGIN_POST_API(requestParam,
        (from == 'emai_login') ? Urls.LOGIN : Urls.SocialLoginApi, context)
        .then((response) async {
      print("----------${response}");
      Map<String, dynamic> logindetails = jsonDecode(response);
      print("----------------${logindetails}");

      if (logindetails['status'] != true) {
        print("----------------${logindetails['status'] != true}");
        context.loaderOverlay.hide();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: logindetails['message']));
      } else {
        LoginModel loginResponse = LoginModel.fromJson(jsonDecode(response));
        SetIntData("isLogin", 1);
        SetData("ApiToken", loginResponse.token ?? "");
        print("Token :-----> ${loginResponse.token}");
        SetData("Email", LoginEmailController.text.toString());

        SetData("Password", LoginPasswordController.text.toString());
        SetData("first_name", loginResponse.user?.firstName.toString() ?? '');
        SetData("last_name", loginResponse.user?.lastName.toString() ?? '');
        SetIntData(
            "subscription_id",
            loginResponse.user?.subscriptionExpired == 1
                ? 0
                : (loginResponse.user?.subscriptionId ?? 0));
        SetIntData("subscription_type", loginResponse.user?.subscriptionType ?? 0);
        SetIntData("grp_subscription_id", loginResponse.user?.groupSubscriptionId  ?? 0);
        print('check groupSubscriptionId--->${loginResponse.user?.groupSubscriptionId }');
        SetIntData("app_user_id", loginResponse.user?.appUserId ?? 0);
        SetData("facebook_id", loginResponse.user?.facebookId ?? '');
        SetData("google_id", loginResponse.user?.googleId ?? '');
        SetData("linkedin_id", loginResponse.user?.linkedinId ?? '');
        print("google----${loginResponse.user?.googleId}");
        GlobalData().subscriptionId =
        loginResponse.user?.subscriptionExpired == 1
            ? 0
            : (loginResponse.user?.subscriptionId ?? 0);
        GlobalData().userId = loginResponse.user?.appUserId ?? 0;
        SharedPreferences pref = await SharedPreferences.getInstance();
        print('check group subscription id--->${pref.getInt('grp_subscription_id') ?? 0}');
        GlobalData().groupSubscriptionId = loginResponse.user?.groupSubscriptionId ?? 0;
        print('GlobalData().groupSubscriptionId->${GlobalData().groupSubscriptionId}');
        // print("Login Response ---> ${jsonEncode(loginResponse.loginUserDetails)}");
        final FirebaseFirestore firebaseFirestore;

        firebaseFirestore = FirebaseFirestore.instance;

        firebaseFirestore
            .collection(FirestoreConstants.pathUserCollection)
            .doc(loginResponse.user?.appUserId.toString())
        // .collection(FirestoreConstants.chatList)
        // .doc(firebaseUser.data?.uniqueId.toString())
            .set({
          FirestoreConstants.nickname:
          '${loginResponse.user?.firstName} ${loginResponse.user?.lastName}',
          FirestoreConstants.photoUrl: '',
          FirestoreConstants.isOnline: 1,
          FirestoreConstants.id: loginResponse.user?.appUserId,
          FirestoreConstants.deviceToken: firebaseToken,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          FirestoreConstants.chattingWith: null
        });
        /* if (loginResponse.user!.subscriptionId == null) {
          SetIntData("subscriptionId", 0);
        } else {
          SetIntData("subscriptionId", loginResponse.user!.subscriptionId!);
        }*/
        //  deviceId.value = _getId().toString();
        appuserid.value = loginResponse.user!.appUserId ?? 0;
        print("appuserid-------- ${appuserid.value}");
        subscriptionid.value = loginResponse.user!.subscriptionId ?? 0;
        print("subscriptionid--------- ${subscriptionid.value}");
        subscriptiontype.value = loginResponse.user!.subscriptionType ?? 0;
        print("subscriptiontype---------- ${subscriptiontype.value}");
        context.loaderOverlay.hide();
        Get.back();
        if (loginResponse.user?.subscriptionExpired == 1 ||
            loginResponse.user!.subscriptionId == null) {
          SetIntData("isLogin", 1);
          Get.offAndToNamed("/HomeWithoutSignUp");

        } else {
          if(loginResponse.user?.subscriptionExpired == 0 && loginResponse.user?.groupSubscriptionId != 0){
            SetIntData("isLogin", 1);
            int islogin = await GetIntData("isLogin");
            print('islogin==${islogin}');
            Get.offAndToNamed("/HomeWithSignUp");
          }else if(loginResponse.user?.subscriptionExpired == 0 && loginResponse.user?.groupSubscriptionId == 0){
            SetIntData("isLogin", 1);
            int islogin = await GetIntData("isLogin");
            print('islogin==${islogin}');
            Get.offAndToNamed("/HomeWithSignUp");
          }else if(loginResponse.user?.subscriptionExpired == 1 && loginResponse.user?.groupSubscriptionId != 0) {
            CustomAlert.showAlert(
                context, 'Your subscription has been expired.',
                title: 'Luxury Council', btnFirst: 'Ok', handler: (int index) {
            });
          }

        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 1),
          content: Text(
            logindetails['message'],
            style: TextStyle(color: AppColor.white),
          ),
        ));
        LoginEmailController.clear();
        LoginPasswordController.clear();
      }
    }, onError: (e) {
      context.loaderOverlay.hide();
      print('object${e.toString()}');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
  }

  void logOut(
      BuildContext context,
      ) {
    context.loaderOverlay.show();
    print("LOGOUT----> ${Urls.log_out}");

    POST_API({
      "device_type": deviceType.value.toString(),
      "device_token": devicetoken.value.toString()
    }, Urls.log_out, context)
        .then((response) async {
      print("LOGOUT response ----> $response");
      Map<String, dynamic> map = jsonDecode(response);

      if (map["status"] != true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(map["message"]),
        ));
      } else {
        RemoveData('facebook_id');
        SocialLogin().facebookLogin?.logOut();
        RemoveData('google_id');
        SocialLogin().googleSignIn.signOut();
        SocialLogin().logoutUser = true;
        SocialLogin().user = null;
        RemoveData('linkedin_id');
        RemoveData("Email");
        RemoveData("Password");
        FirebaseFirestore.instance
            .collection(FirestoreConstants.pathUserCollection)
            .doc(GlobalData().userId.toString())
            .update({FirestoreConstants.isOnline: 0});
        String accessToken = await GetData("ApiToken") ?? "";
        print("token = Bearer $accessToken");
        SetIntData("isLogin", 0);
        int islogin = await GetIntData("isLogin");
        print('islogin==${islogin}');
       // homeController.manageDeviceToken(context, accessToken ?? '',isdelete: '1');
        Navigator.pop(context);

        Get.offAllNamed("/Login");
      }

      context.loaderOverlay.hide();
    });
  }
}

