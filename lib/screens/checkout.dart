import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/controllers/homeController.dart';
import 'package:luxury_council/controllers/notification_controller.dart';
import 'package:luxury_council/widgets/appbars.dart';

import '../constance/global_data.dart';

class CheckOut extends StatefulWidget {

   String? content = '';
   String? plan = '';
   String? plan1 = '';
   String? subscriptionLevel = '';

   CheckOut({super.key, required this.content, required this.plan,required this.plan1, required this.subscriptionLevel});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  final NotificationController notificationController = Get.put(NotificationController());
  final HomeController homeController = Get.put(HomeController());
  int? type = Get.arguments[4];

@override
  void initState() {
 // getNotification();
    super.initState();
    print('check>>> ${widget.plan} >> ${widget.plan1} >> ${widget.subscriptionLevel} >> ${widget.content} >>>>> ${type.toString()}');
  }

  getNotification() async {
    await notificationController.getNotificationListing(Get.context!);
  }

int subscriptionid = GlobalData().subscriptionId;

  @override
  Widget build(BuildContext context) {
    print("------------>${widget.plan.toString()}");
     print("------------>${widget.plan1.toString()}");
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColor.grey,
      appBar: AppBarDetails(appBar: AppBar(), text: 'CHECKOUT', isNotSubscription: subscriptionid==0||subscriptionid==1||subscriptionid==2||subscriptionid==6,screenName: '/Checkout',content: widget.content,plan1: widget.plan1,plan: widget.plan ,subscriptionLevel: widget.subscriptionLevel,type: type ?? 1, ),
      // appBar: AppBar(
      //   leading: Container(
      //     margin: EdgeInsets.only(left: 18),
      //     child: GestureDetector(
      //         onTap: () {
      //           Get.back();
      //         },
      //         child: Icon(
      //           Icons.arrow_back_ios,
      //           color: AppColor.white,
      //           size: 20,
      //         )),
      //   ),
      //   leadingWidth: 30,
      //   title: Text(
      //     'CHECKOUT',
      //     style: TextStyle(
      //         color: AppColor.white, fontWeight: FontWeight.bold, fontSize: 12),
      //     textAlign: TextAlign.left,
      //   ),
      //   actions: [
      //     Row(
      //       children: [
      //         // GestureDetector(
      //         //   onTap: () {
      //         //     Get.toNamed("/Profile");
      //         //   },
      //         //   child: Container(
      //         //     margin: EdgeInsets.only(right: 0),
      //         //     child: Padding(
      //         //       padding: const EdgeInsets.all(4.0),
      //         //       child: Image.asset(
      //         //         "assets/profile.png",
      //         //         scale: 2.9,
      //         //       ),
      //         //     ),
      //         //   ),
      //         // ),
      //         Container(
      //           margin: EdgeInsets.only(right: 16),
      //           child: Padding(
      //             padding: const EdgeInsets.all(4.0),
      //             child: Image.asset(
      //               "assets/notification.png",
      //               scale: 2.9,
      //             ),
      //           ),
      //         ),
      //         // Container(
      //         //   margin: EdgeInsets.only(right: 8),
      //         //   child: Padding(
      //         //     padding: const EdgeInsets.all(4.0),
      //         //     child: Image.asset(
      //         //       "assets/message.png",
      //         //       scale: 2.9,
      //         //     ),
      //         //   ),
      //         // ),
      //       ],
      //     ),
      //   ],
      //   backgroundColor: Colors.black.withOpacity(0.7),
      //   centerTitle: false,
      //   bottomOpacity: 1.0,
      //   elevation: 4,
      // ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              "assets/background.png",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              "assets/registerbottom.png",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                                color: AppColor.black,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Summary',
                                  style: TextStyle(
                                      color: AppColor.primarycolor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  widget.subscriptionLevel.toString(),
                                  style: TextStyle(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  widget.plan.toString(),
                                  style: TextStyle(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Html(
                                  //  style: {
                                  //     "body": Style(
                                  //       color: AppColor.white,
                                  //       fontSize: FontSize(14.0),
                                  //     ),
                                  //   },
                                  style: {
                                    '#': Style(color: Colors.white),
                                    'h1': Style(color: Colors.white),
                                    'body': Style(
                                        color: Colors.white,
                                        fontSize: FontSize.medium),
                                    'p': Style(
                                        color: Colors.white,
                                        fontSize: FontSize.medium),
                                  },
                                  data:
                                  "${ widget.content.toString()}",
                                ),
                               /* SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'No chat capacity',
                                  style: TextStyle(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Live events will only come months after the events have happened. ',
                                  style: TextStyle(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),*/
                              ],
                            ));
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 8,
                        );
                      },
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print('----------------->${widget.plan1.toString()}');
                     Get.toNamed("/PayScreen",arguments :[
                     //   widget.plan,
                        widget.plan1,subscriptionid,type
                      ]);
                  //  Get.toNamed("/PayScreen");
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 10, bottom: 10),
                    height: 45,
                    decoration: BoxDecoration(
                        color: AppColor.black,
                        border: Border.all(
                            color: AppColor.primarycolor, width: 2),
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: Text('Payment',
                          style: TextStyle(
                              color: AppColor.primarycolor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
