import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:math';


class LinkedInScreen extends StatefulWidget {
  LinkedInScreen({
    Key? key,
  }) : super(key: key);

  @override
  _LinkedInScreenState createState() => _LinkedInScreenState();
}

class _LinkedInScreenState extends State<LinkedInScreen> {
  late WebViewController controller;
  var clientId = "78gm5vcnapfi6h";
  var clientSecret = "A7ogLIV3IqGdkXzd";
  var redirectUri = "https://dev.luxurycouncil.com/auth/linkedin/callback";
  Dio dio = Dio();
  String randomString ='';
  bool codeProcessed = false; // Add this flag
  String randomUrls ='';

  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      )
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) {
        },
        onNavigationRequest: (navReq) {
          print('navigateUrl::${navReq.url}');
          if (navReq.url.contains('https://dev.luxurycouncil.com/auth/linkedin/callback')) {
            if (!codeProcessed) {
              String mainUrl = navReq.url;
              print('__________mainUrl____${mainUrl}');
              var s = mainUrl.split('code=');
              print('__________scheck____${s}');
              print('__________scheck____${s[0]}');
              if(s.length>1) {
                print('__________scheck12____${s[1]}');
                var s2 = s[1].split('&state=');
                print('__________s____${s[0]}');
                print('__________s2121321321____${s2[0]}');
                print('__________s2____${s2[1]}');
              context.loaderOverlay.show();
              randomString = s2[0];
                print('randomString::${randomString}');
                callApiForAccessToken(randomString);
                codeProcessed = true; // Set the flag to true after processing
              }
            }
          }
          else if (navReq.url.contains('/login-cancel')){
            _clearCoookie();
            print('cancel clicked');
            Navigator.pop(context);
          }
          return NavigationDecision.navigate;

        },
      ))
      ..clearCache()
      ..loadRequest(Uri.parse('https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=$clientId&redirect_uri=$redirectUri&state=foobar&scope=profile%20openid%20email'));

    _clearCoookie();


  }
  _clearCoookie() async {
    await  WebViewCookieManager().clearCookies();
  }

  String? htmlText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: WebViewWidget(controller: controller)),
    );
  }

  Future<void> callApiForAccessToken(String s2) async {
    var url = "https://www.linkedin.com/oauth/v2/accessToken?code=$s2&grant_type=authorization_code&client_id=$clientId&client_secret=$clientSecret&redirect_uri=$redirectUri";
    print("CallbackUrlsCreate$url");
    try {
      dio.options.headers['Content-Type'] = 'x-www-form-urlencoded';
      final response = await dio.post(url);
      print('response______${response.data} : ${response.data.toString()}');
      if (response.statusCode == 200) {
        var data = AccessToken.fromJson(response.data);
        if(data.accessToken != null) {
          getInfoApiCall(data);
        }
      } else {
        print('${response.statusCode} : ${response.data.toString()}');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> getInfoApiCall(AccessToken a) async {
    print("accessToken ${a.accessToken}");
    Dio dio = Dio();
    // dio.options.headers['Content-Type'] = 'x-www-form-urlencoded';
    dio.options.headers['Authorization'] = 'Bearer ${a.accessToken}';


    try {
      final response = await dio.get('https://api.linkedin.com/v2/userinfo');
      print('userinfo    ${response.statusCode} : ${response.data.toString()}');
      if (response.statusCode == 200) {
        var user = UserInfoModel.fromJson(response.data);
        Navigator.pop(context, user);
      } else {
        print('${response.statusCode} : ${response.data.toString()}');
      }
    } catch (error) {
      print(error);
    }
  }
}

class UserInfoModel {
  UserInfoModel({
    this.sub,
    this.emailVerified,
    this.name,
    this.locale,
    this.givenName,
    this.familyName,
    this.email,
  });

  UserInfoModel.fromJson(dynamic json) {
    sub = json['sub'];
    emailVerified = json['email_verified'];
    name = json['name'];
    locale = json['locale'] != null ? Locale.fromJson(json['locale']) : null;
    givenName = json['given_name'];
    familyName = json['family_name'];
    email = json['email'];
  }

  dynamic sub;
  dynamic emailVerified;
  dynamic name;
  Locale? locale;
  dynamic givenName;
  dynamic familyName;
  dynamic email;

  UserInfoModel copyWith({
    dynamic sub,
    dynamic emailVerified,
    dynamic name,
    Locale? locale,
    dynamic givenName,
    dynamic familyName,
    dynamic email,
  }) =>
      UserInfoModel(
        sub: sub ?? this.sub,
        emailVerified: emailVerified ?? this.emailVerified,
        name: name ?? this.name,
        locale: locale ?? this.locale,
        givenName: givenName ?? this.givenName,
        familyName: familyName ?? this.familyName,
        email: email ?? this.email,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sub'] = sub;
    map['email_verified'] = emailVerified;
    map['name'] = name;
    if (locale != null) {
      map['locale'] = locale?.toJson();
    }
    map['given_name'] = givenName;
    map['family_name'] = familyName;
    map['email'] = email;
    return map;
  }
}

class Locale {
  Locale({
    this.country,
    this.language,
  });

  Locale.fromJson(dynamic json) {
    country = json['country'];
    language = json['language'];
  }

  String? country;
  String? language;

  Locale copyWith({
    String? country,
    String? language,
  }) =>
      Locale(
        country: country ?? this.country,
        language: language ?? this.language,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['country'] = country;
    map['language'] = language;
    return map;
  }
}

class AccessToken {
  AccessToken({
    this.accessToken,
    this.expiresIn,
    this.scope,
  });

  AccessToken.fromJson(dynamic json) {
    accessToken = json['access_token'];
    expiresIn = json['expires_in'];
    scope = json['scope'];
  }

  String? accessToken;
  dynamic expiresIn;
  String? scope;

  AccessToken copyWith({
    String? accessToken,
    dynamic expiresIn,
    String? scope,
  }) =>
      AccessToken(
        accessToken: accessToken ?? this.accessToken,
        expiresIn: expiresIn ?? this.expiresIn,
        scope: scope ?? this.scope,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_token'] = accessToken;
    map['expires_in'] = expiresIn;
    map['scope'] = scope;
    return map;
  }
}

String generateRandomString() {
  var r = Random();
  const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(15, (index) => _chars[r.nextInt(_chars.length)]).join();
}