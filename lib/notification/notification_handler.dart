import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:luxury_council/config/prefrance.dart';
import 'package:luxury_council/constance/global_data.dart';
import 'package:luxury_council/controllers/homeController.dart';
import 'package:luxury_council/controllers/notification_controller.dart';
import 'package:luxury_council/screens/chatdetails.dart';

class FirebasePushNotificationsHandler {
  final NotificationController notificationController =
  Get.put(NotificationController());
  final HomeController homeController = Get.put(HomeController());
  DateTime? dateTime;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  AndroidNotificationChannel? channel;
  FirebaseMessaging? _messaging = FirebaseMessaging.instance;
  static Map<dynamic, dynamic>? _messageMain;
  int? subscriptionid;

  Future registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    if (Platform.isIOS) {
      _messaging?.requestPermission();
    }

    FirebaseMessaging.onBackgroundMessage(
            (firebaseMessagingBackgroundHandler) async {
          if (firebaseMessagingBackgroundHandler.data['article_id'] != null) {
            print('testing4');
          }else{
            print('testing50');
            print('${firebaseMessagingBackgroundHandler.data}');
          }
          return _navigateToScreen(firebaseMessagingBackgroundHandler.data);
        });

    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        // 'This channel is used for important notifications.', // description
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          ?.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel!);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      init();
    }
  }

  getCurrentId() async {
    await GlobalData().retrieveLoggedInUserDetail();
  }

  void init() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      print('testing1');
          if (message!.data.isNotEmpty) {
        print('navigate : $message');
        Future.delayed(Duration(milliseconds: 3500), () async {
          await _navigateToScreen(message.data);
        });
      }
    });
    checkForInitialMessage();
    _initializeLocalNotification();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await getCurrentId();
      int subscriptionid = GlobalData().subscriptionId;
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      print('testing3');
      if (message.data['article_id'] != null) {
        print('testing4');
        notificationController.getNotificationListing(Get.context!);
      }
      print('message11:::${message.data}');
      log('message12:::${message.notification} ${message.data['article_id']}');
      _messageMain = message.data;
      if (notification != null && android != null && !kIsWeb) {
        print('testing6');
        print('subscriptionid : $subscriptionid >> ${message
            .data['article_id']} >>${currentChatId}');
        if ((subscriptionid == 3 ||
            subscriptionid == 4 ||
            subscriptionid == 5) && message.data['article_id'] == null && currentChatId != message.data['peerId']) {
          print('testing7');
          flutterLocalNotificationsPlugin?.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel?.id ?? '',
                channel?.name ?? '',
                priority: Priority.max,
                importance: Importance.max,
                icon: '@mipmap/ic_launcher',
              ),
            ),
            payload: jsonEncode(message.data),
          );
        } else if (message.data['article_id'] != null) {
          print('testing8');
          flutterLocalNotificationsPlugin?.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel?.id ?? '',
                channel?.name ?? '',
                priority: Priority.max,
                importance: Importance.max,
                icon: '@mipmap/ic_launcher',
              ),
            ),
            payload: jsonEncode(message.data),
          );
        }
        else {
          print('testing9');
        }
      }
      else {
        print('testing50');
        print('subscriptionid : $subscriptionid >> ${message
            .data['article_id']} >>${currentChatId}');
        if ((subscriptionid == 3 ||
            subscriptionid == 4 ||
            subscriptionid == 5) && message.data['article_id'] == null && currentChatId != message.data['peerId']) {
          print('testing51');
          flutterLocalNotificationsPlugin?.show(
            notification.hashCode,
            notification!.title,
            notification.body,
            NotificationDetails(
              iOS: DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,


                /* channel?.id ?? '',
                  channel?.name ?? '',
                  priority: Priority.max,
                  importance: Importance.max,
                  icon: '@mipmap/ic_launcher',*/
              ),
            ),
            payload: jsonEncode(message.data),
          );
        } else if (message.data['article_id'] != null) {
          print('testing8');
          flutterLocalNotificationsPlugin?.show(
            notification.hashCode,
            notification!.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel?.id ?? '',
                channel?.name ?? '',
                priority: Priority.max,
                importance: Importance.max,
                icon: '@mipmap/ic_launcher',
              ),
            ),
            payload: jsonEncode(message.data),
          );
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('navigate1 : $message');
      _navigateToScreen(message.data);
      print('A new onMessageOpenedApp event was published!');
    });
  }

  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print('navigate2 : ${initialMessage.data}');
      Future.delayed(Duration(milliseconds: 3500), () async {
        Get.context!.loaderOverlay.hide();
        _navigateToScreen(initialMessage.data);
      });
    }
  }

  _navigateToScreen(Map<dynamic, dynamic>? message) async {
    print('navigate3 : ${message}');
    if (message != null) {
      // await addToHive(id: message['article_id']);
      print('msg : ${message['article_id']}');
      Map<dynamic, dynamic> data;
      if (Platform.isAndroid) {
        data = message;
        print('Notification ::::: $data');
      } else {
        data = message;
      }
      if (data['article_id'] == null) {
        print('check 11');
        int islogin = await GetIntData("isLogin");
        print('islogin==${islogin}');
        if (islogin == 1) {
          print('testing chat id>>${data['peerId']}');
          Get.offAndToNamed("/ChatDetails", arguments: [
            data['peerId'],
            '',
            data['peerNickname'],
          ], parameters: {
            "key": "key",
          });
        }
        else {
          Get.offAndToNamed('/Login');
        }
      } else {
        print('check 22');
        print('id is here >>${message['article_id']}');
        int islogin = await GetIntData("isLogin");
        print('islogin==${islogin}');
        if (islogin == 1) {
          Get.offNamed("/ArticleVideoAudioDetails", parameters: {
            "articleId": message['article_id'],
            "key": "key",
          });
        }
        else {
          Get.offAndToNamed('/Login');
        }
      }
    }
  }

  ///configure local notification
  _initializeLocalNotification() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = DarwinInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) {
          print('id $id >>> $payload');
        },);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin?.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) {
          print('payload>>>> ${details.payload}');
          Map<String,dynamic> datanew = jsonDecode(details.payload!);
          print('payload>>>> deode ${datanew['peerId']}');
          if (details.payload != null) {
            if (Platform.isAndroid) {
              _navigateToScreen(datanew);
            } else {
              _navigateToScreen(datanew);
            }
          }
        },
        onDidReceiveBackgroundNotificationResponse: (details) {
          print('payload>123>>> ${details}');
          Map<String,dynamic> datanew = jsonDecode(details.payload!);
          if (details.payload != null) {
            if (Platform.isAndroid) {
              _navigateToScreen(datanew);
            } else {
              _navigateToScreen(datanew);
            }
          }
        },);
  }

  Future<void> onDidReceiveLocalNotification(int? id, String? title,
      String? body, dynamic payload) async {
    // print("onDid $_messageMain");
    print("payload $payload");
    if (payload != null && payload is NotificationResponse) {
      print('tesing>t> testing');
      String? peerId = payload.id.toString(); // Assuming 'peerId' is a property in NotificationResponse
      if (peerId != null) {
        print('peerId : $peerId>>t> ${payload.payload}>>t>${payload.input}>>t> testing testing');
        // Perform actions based on peerId, such as navigating to a specific screen
        // _navigateToScreen(peerId);
      }
    }

    if (payload != null) {
      if (Platform.isAndroid) {
        _navigateToScreen(payload);
      } else {
        _navigateToScreen(payload);
      }
    }
  }

/*  Future<void> onSelectNotification(dynamic payload) async {
    if (payload != null && payload is NotificationResponse) {
      print('tesing>> testing');
      String? peerId = payload.id.toString(); // Assuming 'peerId' is a property in NotificationResponse
      if (peerId != null) {
        print('peerId : $peerId>>> ${payload.payload}>>>${payload.input}>>> testing testing');
        // Perform actions based on peerId, such as navigating to a specific screen
       // _navigateToScreen(peerId);
      }
    }
  }*/

/*  Future<void> onSelectNotification(dynamic payload) async {
    print('testing>>payload');
    if (payload != null && payload is Map<dynamic, dynamic>) {
      if (payload['article_id'] != null) {
        print('Article ID: ${payload['article_id']}');
        // Perform navigation based on the article_id
        int isLogin = await GetIntData("isLogin");
        if (isLogin == 1) {
          Get.offNamed("/ArticleVideoAudioDetails", parameters: {
            "articleId": payload['article_id'],
            "key": "key",
          });
        } else {
          Get.offAndToNamed('/Login');
        }
      } else if (payload['peerId'] != null) {
        print('Peer ID: ${payload['peerId']}');
        // Perform navigation based on the peerId
        int isLogin = await GetIntData("isLogin");
        if (isLogin == 1) {
          Get.offAndToNamed("/ChatDetails", arguments: [
            payload['peerId'],
            '',
            payload['peerNickname'],
          ], parameters: {
            "key": "key",
          });
        } else {
          Get.offAndToNamed('/Login');
        }
      }
    } else {
      print('Payload is null or not in the expected format');
    }
  }*/

  Future<void> onSelectNotification(dynamic payload) async {
    if (Platform.isAndroid) {
      print("on select : before");
      // String ss = await _getMainMsg();
      print("payload ::::: $payload >> $_messageMain");
      _navigateToScreen(_messageMain);
    } else {
      _navigateToScreen(_messageMain);
    }
  }
}


