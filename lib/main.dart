import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:luxury_council/config/prefrance.dart';
import 'package:luxury_council/models/hive/notification_model/notificationmodel.dart';
import 'package:luxury_council/notification/fcm_helper.dart';
import 'package:luxury_council/screens/forgot.dart';
import 'package:luxury_council/screens/aboutus.dart';
import 'package:luxury_council/screens/articlevideoaudiodetails.dart';
import 'package:luxury_council/screens/articlevideoimagedetails.dart';
import 'package:luxury_council/screens/chatdetails.dart'; 
import 'package:luxury_council/screens/checkout.dart';
import 'package:luxury_council/screens/companylist.dart';
import 'package:luxury_council/screens/contactus.dart';
import 'package:luxury_council/screens/editprofile.dart';
import 'package:luxury_council/screens/eventdetails.dart';
import 'package:luxury_council/screens/events.dart';
import 'package:luxury_council/screens/homewithoutsignup.dart';
import 'package:luxury_council/screens/linkedin_screen.dart';
import 'package:luxury_council/screens/login.dart';
import 'package:luxury_council/screens/notification_screen.dart';
import 'package:luxury_council/screens/payment.dart';
import 'package:luxury_council/screens/profile.dart';
import 'package:luxury_council/screens/rating.dart';
import 'package:luxury_council/screens/register.dart';
import 'package:luxury_council/screens/searchpage.dart';
import 'package:luxury_council/screens/spotlightlisting.dart';
import 'package:luxury_council/screens/spotlightmember.dart';
import 'package:luxury_council/screens/subscription.dart';
import 'package:luxury_council/splash_screen.dart';
import 'package:uni_links/uni_links.dart';

import 'constance/global_data.dart';
import 'notification/notification_handler.dart';
import 'screens/chats.dart';
import 'screens/digest.dart';
import 'screens/favouritepage.dart';
import 'screens/groupsubscription.dart';
import 'screens/homewithsignup.dart';
import 'screens/pay.dart';
import 'package:permission_handler/permission_handler.dart';


import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
/*@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await setupFlutterNotifications();
  showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {

  print('message : $message');

  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'launch_background',
        ),
      ),
    );
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;*/




void main() async{
  // Initialize Firebase.
  
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then((value) {
        if (value) {
          Permission.notification.request();
        }
      });
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalData().retrieveLoggedInUserDetail();
  //await FirebaseService.initializeFirebase();

/*  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }*/

  var pushNotificationsHandler = FirebasePushNotificationsHandler();
  pushNotificationsHandler.registerNotification();

  initUniLinks();
  runApp(const MyApp());
}
StreamSubscription? _streamSubscription;
void initUniLinks() async {
  try {
    await getInitialLink();
  } on PlatformException {
    // Handle exception if platform is not supported or other error occurs
  }
  print("uri------------------------------>");
  // Ensure that the app is ready to handle deep links
  /*try {
    await getInitialLink();
  } on PlatformException {
    // Handle exception if platform is not supported or other error occurs
  }*/

  // Set up a stream subscription to handle deep links when the app is running
  Uri? initialUri;
  print("uri------------------------------>${initialUri}");
  getLinksStream().listen((String? uri) {
    if (uri != null && uri != initialUri) {
      initialUri = Uri.parse(uri);
      handleDeepLink(initialUri!);
    }

    if (!kIsWeb) {
      _streamSubscription = uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          initialUri = Uri.parse(uri.toString());
          handleDeepLink(initialUri!);
        }
      });
    }
  }, onError: (err) {
    // Handle stream subscription errors
  });
}

void handleDeepLink(Uri uri) {
  print("uri-------------------------123----->${uri}");
  // Extract relevant information from the deep link and perform actions accordingly
  String path = uri.path;
  String? query = uri.queryParameters['id'];
  print("uri---123------------path--------------->${path}");
  print("uri---123-----------query---------------->${query}");

  // Example: Navigating to a specific screen based on the deep link
  if (path == '/Article') {
    String id = query ?? '';
    print("uri---123-----------query---------------->${id}");

    GetData("Email").then((a) => a == null ? Get.offAndToNamed('/Login') : articleNavi(id));

    // Navigator.pushNamed(context, '/product', arguments: productId);
  }
}

void articleNavi(String id){
  Get.offNamed("/ArticleVideoAudioDetails", parameters: {
    "articleId": id,
    "key": "key",
  });
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {

    super.initState();
   /* FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('message 123: $message');
      print('A new onMessageOpenedApp event was published!');
      *//* Navigator.pushNamed(
        context,
        '/message',
        arguments: MessageArguments(message, true),
      );*//*
    });*/
  }

  @override
  Widget build(BuildContext context) {

    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: Center(child: CircularProgressIndicator(
        color: Colors.blue,
      ),),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Luxury Council',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => SplashScreen()),
          GetPage(name: '/Login', page: () => Login()),
          GetPage(name: '/Register', page: () => Register()),
          GetPage(name: '/HomeWithoutSignUp', page: () => HomeWithoutSignUp()),
          GetPage(name: '/HomeWithSignUp', page: () => HomeWithSignUp()),
          GetPage(
              name: '/ArticleVideoAudioDetails',
              page: () => ArticleVideoAudioDetails()),
          GetPage(
              name: '/ArticleVideoImageDetails',
              page: () => ArticleVideoImageDetails()),
          GetPage(name: '/Events', page: () => Events()),
          GetPage(name: '/EventDetails', page: () => EventDetails()),
          GetPage(name: '/Profile', page: () => Profile()),
          GetPage(name: '/Subscription', page: () => Subscription()),
          GetPage(name: '/CheckOut', page: () => CheckOut(
            content: Get.arguments[0],
            plan: Get.arguments[1],
            plan1: Get.arguments[2],
            subscriptionLevel: Get.arguments[3],
          )),
          GetPage(name: '/Payment', page: () => Payment()),
          GetPage(name: '/AboutUs', page: () => AboutUs()),
          GetPage(name: '/ContactUs', page: () => ContactUs()),
          GetPage(name: '/GroupSubscription', page: () => GroupSubscription()),
          GetPage(name: '/SpotlightMember', page: () => SpotlightMember(
            memberId: Get.arguments[0],
          )),
          GetPage(name: '/SpotlightListing', page: () => SpotlightListing()),
          GetPage(name: '/Digest', page: () => Digest()),
          GetPage(name: '/Chats', page: () => Chats()),
          GetPage(name: '/SearchPage', page: () => SearchPage()),
          GetPage(name: '/ChatDetails', page: () => ChatDetails(
            peerId: Get.arguments[0],
            peerImage: Get.arguments[1],
            peerNickname: Get.arguments[2],
          )),
          GetPage(name: '/EditProfile', page: () => EditProfile()),
          GetPage(name: '/FavouritePage', page: () => FavouritePage()),
          GetPage(name: '/LinkedInLogin', page: () => LinkedInScreen()),
          GetPage(name: '/PayScreen', page: () => PayScreen(plan1: Get.arguments[0],)),
          GetPage(name: '/Forgot', page: () => Forgot()),
          GetPage(
              name: '/RatingAndReviewScreen',
              page: () => RatingAndReviewScreen()),
          GetPage(name: '/CompanyList', page: () => CompanyList()),
          GetPage(name: '/NotificationScreen', page: () => NotificationScreen()),
        ],
        home: SplashScreen(),
      ),
    );
  }


}
