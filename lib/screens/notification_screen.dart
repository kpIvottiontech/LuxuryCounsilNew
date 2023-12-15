import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_council/config/prefrance.dart';
import 'package:luxury_council/controllers/homeController.dart';
import 'package:luxury_council/controllers/notification_controller.dart';
import 'package:luxury_council/models/notification_list/notification_list_response.dart' as notif;
import 'package:luxury_council/widgets/player_screen.dart';
import '../colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final HomeController homeController = Get.put(HomeController());
  final NotificationController notificationController =
      Get.put(NotificationController());
  int selectedIndex = -1;
  String getStringArgument = Get.arguments[0].toString();
  String plan1 =
      Get.arguments[1].toString().isNotEmpty ? Get.arguments[1].toString() : "";
  String plan =
      Get.arguments[2].toString().isNotEmpty ? Get.arguments[2].toString() : "";
  String subscriptionLevel =
      Get.arguments[4].toString().isNotEmpty ? Get.arguments[4].toString() : "";
  String content =
      Get.arguments[3].toString().isNotEmpty ? Get.arguments[3].toString() : "";
  int type = Get.arguments[5] ?? 1;

  @override
  void initState() {
    print('check 44');
    checkLogin();
    notificationController.getNotificationListing(context);
    PlayerScreenState().assetsAudioPlayer.dispose();
    // TODO: implement initState
    super.initState();
  }

  checkLogin() async {
    int islogin = await GetIntData("isLogin");
    print('islogin==${islogin}');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  deleteNotification({List<num>? articleList}) async {
    print('check it.....${articleList}');
    if (articleList!.isNotEmpty) {
     String articleListString = articleList.toString().replaceAll('[', '').replaceAll(']', '');
      await notificationController.deleteNotification(context, articleListString);
    }
    notificationController.articleData.clear();
    notificationController.notificationStreamController.sink
        .add(notificationController.articleData);
    notificationController.notificationCount.value = 0;
    //Get.offNamed("/NotificationScreen");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.loginappbar,
      appBar: AppBar(
        backgroundColor: AppColor.appbar,
        bottomOpacity: 1.0,
        elevation: 4,
        leadingWidth: 30,
        title: Text(
          "Notifications",
          style: TextStyle(
              color: AppColor.white, fontWeight: FontWeight.bold, fontSize: 16),
          textAlign: TextAlign.left,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              List<num> articleList = [];
              if (notificationController.articleData.isNotEmpty) {
                for (var item in notificationController.articleData) {
                  articleList.add(item.articleId!);
                }
              }
              deleteNotification(articleList: articleList);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                height: 32,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: AppColor.primarycolor),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10),
                  child: Center(
                    child: Text(
                      'Clear All',
                      style: TextStyle(color: AppColor.black, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        leading: Container(
          margin: EdgeInsets.only(left: 18),
          child: GestureDetector(
             /* onTap: () {
                print(
                    'check >> ${getStringArgument} >> ${plan1} >> ${plan} >> ${content} >> ${subscriptionLevel}');
                switch (getStringArgument) {
                  case '/HomeWithSignUp':
                    Get.offNamed("/HomeWithSignUp");
                    break;
                  case '/AboutUs':
                    Get.offNamed('/AboutUs');
                    break;
                  case '/Events':
                    Get.offNamed('/Events');
                    break;
                  case '/Checkout':
                    Get
                      ..offNamed("/CheckOut", arguments: [
                        content,
                        plan,
                        plan1,
                        subscriptionLevel,
                        type
                      ]);
                    //Get.offNamed('/Checkout',arguments: [content,plan,plan1,subscriptionLevel]);
                    break;
                  case '/ContactUs':
                    Get.offNamed('/ContactUs');
                    break;
                  case '/EventDetails':
                    Get.offNamed("/EventDetails");
                    break;
                  case '/FavouritePage':
                    Get.offNamed("/FavouritePage");
                    break;
                  case '/GroupSubscription':
                    Get.offNamed("/GroupSubscription");
                    break;
                  case '/PayScreen':
                    Get.offNamed('/PayScreen', arguments: [plan1]);
                    break;
                  case '/SpotlightListing':
                    Get.offNamed("/SpotlightListing");
                    break;
                  case '/SpotlightMember':
                    Get.offNamed("/SpotlightMember",
                        arguments: [int.parse(plan1)]);
                    break;
                  case '/Subscription':
                    Get.offNamed('/Subscription');
                    break;
                  case '/ArticleVideoAudioDetails':
                    Get.offNamed('/ArticleVideoAudioDetails', parameters: {
                      "articleId": plan1,
                      'key': Get.parameters['key'] ?? '',
                    });
                    break;
                }
              },*/
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColor.white,
                size: 20,
              )),
        ),
      ),
      body: StreamBuilder<List<notif.Artical>>(
        stream: notificationController.notificationStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<notif.Artical>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              'There are no new notifications available.',
              style: TextStyle(
                color: AppColor.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ));
          } else {
            final notifications = snapshot.data;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: notifications!.length,
                // itemCount: 20,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(()  {
                        selectedIndex = index;
                        if (selectedIndex == index) {
                          List<int> articleIdInt = [];
                          articleIdInt.add(int.parse(notifications[index].articleId
                              .toString()));
                           Get.offNamed(
                                "/ArticleVideoAudioDetails",
                                parameters: {
                                  "articleId": notifications[index].articleId.toString(),
                                  'key': '-1'
                                });
                        }
                      });
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: AppColor.black,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10),
                        child: notifications![index].thumbnailImage!.isNotEmpty
                            ? Row( mainAxisAlignment:
                        MainAxisAlignment.start,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                notifications![index]
                                                        .articleName
                                                        .toString() ??
                                                    '',
                                                maxLines: 3,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: AppColor.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                notifications![index]
                                                        .articalShortDesc
                                                        .toString() ??
                                                    '',
                                                maxLines: 3,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: AppColor.textlight,
                                                    fontSize: 14),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: notifications![index]
                                                .thumbnailImage!
                                                .isNotEmpty ||
                                            notifications![index]
                                                    .image!.isNotEmpty
                                        ? Align(
                                            alignment: Alignment.centerRight,
                                            child: Image.network(
                                              notifications![index]
                                                              .thumbnailImage !=
                                                          null &&
                                                      notifications![index].image!.isEmpty
                                                  ? "${notifications![index].thumbnailImage}"
                                                  : "${notifications![index].image?.first.imageurl ?? ''}",
                                              fit: BoxFit.cover,
                                              height: 90,
                                              width: 90,
                                            ),
                                          )
                                        : Container(),
                                  )
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notifications![index]
                                            .articleName
                                            .toString() ??
                                        '',
                                    maxLines: 3,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: AppColor.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    notifications![index]
                                            .articalShortDesc
                                            .toString() ??
                                        '',
                                    maxLines: 3,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: AppColor.textlight,
                                        fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 8,
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
