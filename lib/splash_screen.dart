import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/config/prefrance.dart';
import 'package:luxury_council/controllers/loginController.dart';
import 'package:video_player/video_player.dart';
import 'package:uni_links/uni_links.dart';
bool _initialUriIsHandled = false;
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const splashScreen = "splashscreen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription? _streamSubscription;
  StreamSubscription? _sub;
  Uri? _initialUri;
  Uri? _latestUri;
  Object? _err;



  final _firebaseMessaging = FirebaseMessaging.instance;
  String firebaseToken = '';
  // void initState() {
  //   super.initState();
  //   Timer(
  //       Duration(seconds: 2),
  //       () =>Get.offAndToNamed("/Login"));
  // }

  final LoginController loginController = Get.put(LoginController());
  late VideoPlayerController _videoPlayerController;
  int isBackMsg = 0;
  @override
  void initState() {
    _firebaseMessaging.getToken().then((value) {
      setState(() {
        firebaseToken = value ?? '';
        print('fffff $firebaseToken');
      });
       loginController.devicetoken.value = value ?? '';
    });
   
    super.initState();
    getBackgrndMsg();
    _videoPlayerController =
        VideoPlayerController.asset('assets/splashvideo.mp4')
          ..initialize().then((_) {
            setState(() {});
            _videoPlayerController.play();
          });
    Future.delayed(
        Duration(
          seconds: 11,
        ), () {
      print('testingdddd');
      _handleInitialUri();
      _handleIncomingLinks();
    });

   /* */
  }

  getBackgrndMsg() async {
     await GetIntData("isBackMsg").then((value) {
       isBackMsg = value ?? 0;
     });
    print('isBackMsg==${isBackMsg}');
  }

  Future<void> checkdata() async {
    int subsId = await GetIntData("subscription_id");
    print("objectobjectobjectobject------${subsId}");

    if (subsId == 0) {
      Get.offAndToNamed("/HomeWithoutSignUp");
    } else {
      Get.offAndToNamed("/HomeWithSignUp");
    }
  }
/*  StreamSubscription? _streamSubscription;

  void initUniLinks() async {
    try {
      await getInitialLink();
    } on PlatformException {
      // Handle exception if platform is not supported or other error occurs
    }
    print("uri------------------------------>");
    Uri? initialUri;
    print("uri------------------------------>${initialUri}");
    getLinksStream().listen((String? uri) {
      if (uri != null && uri != initialUri) {
        initialUri = Uri.parse(uri);
        handleDeepLink(initialUri!);
      }else{
        GetData("Email")
            .then((a) => a == null ? Get.offAndToNamed('/Login') : checkdata());
      }

      if (!kIsWeb) {
        _streamSubscription = uriLinkStream.listen((Uri? uri) {
          if (uri != null) {
            initialUri = Uri.parse(uri.toString());
            handleDeepLink(initialUri!);
          }else{
            GetData("Email")
                .then((a) => a == null ? Get.offAndToNamed('/Login') : checkdata());
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
    print("uri---111------------path--------------->${path}");
    print("uri---111-----------query---------------->${query}");

    // Example: Navigating to a specific screen based on the deep link
    if (path == '/Article') {
      String id = query ?? '';
      print("uri---111-----------query---------------->${id}");

      GetData("Email").then((a) => a == null ? Get.offAndToNamed('/Login') : articleNavi(id));

      // Navigator.pushNamed(context, '/product', arguments: productId);
    }
  }

  void articleNavi(String id){
    Get.offNamed("/ArticleVideoAudioDetails", parameters: {
      "articleId": id,
      "key": "key",
    });
  }*/




  void _handleIncomingLinks() {
    print('testing8d');
    if (!kIsWeb) {
      print('testing9d');
      _sub = uriLinkStream.listen((Uri? uri) {
        print('testing10d');
        if (!mounted) return;
        print('got uri: $uri');
        setState(() {
          _latestUri = uri;
          _err = null;
        });
      }, onError: (Object err) {
        print('testing11d');
        if (!mounted) return;
        print('got err: $err');
        setState(() {
          _latestUri = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  Future<void> _handleInitialUri() async {
    print('testing1d');
    if (!_initialUriIsHandled) {
      print('testing2d');
      _initialUriIsHandled = true;
      try {
        final uri = await getInitialUri();
        if (uri == null) {
          print('testing3d');
          print('no initial uri');
          if (Navigator.of(context).canPop()) {
            print('testingd123');
            return;
          }else{
            print('testingd111');
            GetData("Email").then((a) => a == null ? Get.offAndToNamed('/Login') :  checkdata());
          }
        } else {
          print('testing4d');
          print('got initial uri: $uri');
          handleDeepLink(uri);
        }
        if (!mounted) return;
        setState(() => _initialUri = uri);
      } on PlatformException {
        // Platform messages may fail but we ignore the exception
        print('falied to get initial uri');
      } on FormatException catch (err) {
        if (!mounted) return;
        print('malformed initial uri');
        setState(() => _err = err);
      }
    }
  }

  Future<void> handleDeepLink(Uri uri) async {
    print('testing5d');
    print("uri-----111--------------------123----->${uri}");
    String path = uri.path;
    String? query = uri.queryParameters['id'];
    print("uri----111-----------path--------------->${path}");
    print("uri----111----------query---------------->${query}");
    if (path == '/Article') {
      print('testing6d');
      String id = query ?? '';
      print("uri---111-----------query---------------->${id}");
      GetData("Email").then((a) => a == null ? Get.offAndToNamed('/Login') : articleNavi(id));
    }
  }

void articleNavi(String id){
  print('testing7d');
  Get.offNamed("/ArticleVideoAudioDetails", parameters: {
    "articleId": id,
    "key": "key",
  });
}


  void call(String email) {
    loginController.LoginEmailController.text = email;
    GetData("Password").then((a) {
      loginController.LoginPasswordController.text = a;
      print("Email -->${loginController.LoginEmailController.text}");
      print("Password -->${loginController.LoginPasswordController.text}");
      loginController.login(context, firebaseToken, '');
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height:  MediaQuery.of(context).size.height / 3.56,
              width:  MediaQuery.of(context).size.width ,
              color: AppColor.white,
              child: VideoPlayer(_videoPlayerController),
            ),
          ],
        ));
  }
}
