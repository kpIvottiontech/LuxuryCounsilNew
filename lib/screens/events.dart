import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/controllers/eventController.dart';
import 'package:luxury_council/widgets/appbars.dart';

import '../constance/global_data.dart';
import '../strings.dart';
import 'bottom_view_widget.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  EventController eventController = Get.put(EventController());
  late ScrollController _scrollController;
  int _pageNumber = 0;
  int limit = 10;
  int randomNumber =0;
  int subscriptionid = GlobalData().subscriptionId;
  @override
  void initState() {
    Random random = new Random();
    randomNumber = random.nextInt(GlobalData().spotlightListing.length);
    eventController.getEventList(  context,
      _pageNumber,
      limit,);
    _scrollController = ScrollController();
    super.initState();
  }
   @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
     _scrollController.addListener(() async {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (eventController.eventlistresponce.isTrue) {
            setState(() {
              _pageNumber = _pageNumber + 1;
            });
            eventController.eventlistresponce.value = false;
            print('object = ' + _pageNumber.toString());
            eventController.getEventList(
              context,
              _pageNumber,
              limit,
            );
          }
        }
      }
    });
    return Scaffold(
      backgroundColor: AppColor.grey,
        floatingActionButton: GlobalData().spotlightListing.isNotEmpty
            ? Padding(
          padding: EdgeInsets.only(bottom:0,),
          child: BottomViewWidget(
              data: GlobalData().spotlightListing[randomNumber]),
        )
            : Container(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBarDetails(appBar: AppBar(), text: 'EVENTS', isNotSubscription: subscriptionid==0||subscriptionid==1||subscriptionid==2||subscriptionid==6,screenName:'/Events' ),
      // appBar: AppBar(
      //   leading: Container(
      //     margin: EdgeInsets.only(left: 18),
      //     child: GestureDetector(
      //         onTap: () {Get.back();},
      //         child: Icon(
      //           Icons.arrow_back_ios,
      //           color: AppColor.white,
      //           size: 20,
      //         )),
      //   ),
      //   leadingWidth: 30,
      //   title: Text(
      //     'EVENTS',
      //     style: TextStyle(
      //         color: AppColor.white, fontWeight: FontWeight.bold, fontSize: 16),
      //     textAlign: TextAlign.left,
      //   ),
      //   actions: [
      //     Row(
      //       children: [
      //         Container(
      //           margin: EdgeInsets.only(right: 0),
      //           child: Padding(
      //             padding: const EdgeInsets.all(4.0),
      //             child: Image.asset(
      //               "assets/profile.png",
      //               scale: 2.9,
      //             ),
      //           ),
      //         ),
      //         Container(
      //           margin: EdgeInsets.only(right: 0),
      //           child: Padding(
      //             padding: const EdgeInsets.all(4.0),
      //             child: Image.asset(
      //               "assets/notification.png",
      //               scale: 2.9,
      //             ),
      //           ),
      //         ),
      //         Container(
      //           margin: EdgeInsets.only(right: 8),
      //           child: Padding(
      //             padding: const EdgeInsets.all(4.0),
      //             child: Image.asset(
      //               "assets/message.png",
      //               scale: 2.9,
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ],
      //   backgroundColor: AppColor.loginappbar.withOpacity(0.5),
      //   //   shadowColor: AppColor.loginappbar,
      //   centerTitle: false,
      //   bottomOpacity: 1.0,
      //   elevation: 4,
      // ),
      body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(controller: _scrollController,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Column(
                      children: [
                        Obx(
                              () => Container(
                              margin: EdgeInsets.only(top: 10),
                              child: eventController.eventList.isNotEmpty
                                  ? ListView.separated(

                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                primary: false,
                                itemCount: eventController.eventList.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      eventController.getArticleDetailsList(
                                          context,
                                          eventController.eventList[index].eventId
                                          as int);
                                      Get.toNamed("EventDetails");
                                    },
                                    child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: AppColor.black,
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${eventController.eventList[index].eventName}".toUpperCase(),
                                              style: TextStyle(
                                                  color: AppColor.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              '${DateFormat('dd/MM/yyyy').format(DateTime.parse(eventController.eventList[index].eventDate.toString()))}',
                                              // "${eventController.eventList[index].eventDate}",
                                              style: TextStyle(
                                                  color: AppColor.textlight,
                                                  fontSize: 14),
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                           /* Html(
                                                style: {
                                                  "body": Style(
                                                    color: AppColor.white,
                                                    fontSize: FontSize(14.0),
                                                  ),
                                                },

                                                data:"${eventController.eventList[index].eventDetail.toString()}"),*/
                                           /* SizedBox(
                                              height: 4,
                                            ),*/
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Read More',
                                                  style: TextStyle(
                                                      color: AppColor.primarycolor,
                                                      fontSize: 11),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 5, left: 10),
                                                  child: Image.asset(
                                                    'assets/rightarrow.png',
                                                    scale: 2.9,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  );
                                },
                                separatorBuilder: (BuildContext context, int index) {
                                  return SizedBox(
                                    height: 8,
                                  );
                                },
                              )
                                  : Center(
                                child: Text(
                                  noEventFound,
                                  style: TextStyle(color: AppColor.primarycolor),
                                ),
                              )),
                        ),

                        //   Container(
                        //     margin: EdgeInsets.only(top: 10),
                        //     child: ListView.separated(
                        //       scrollDirection: Axis.vertical,
                        //       shrinkWrap: true,
                        //       primary: false,
                        //       itemCount: 1,
                        //       itemBuilder: (context, index) {
                        //         return GestureDetector(
                        //           onTap: () {
                        //             Get.toNamed("EventDetails");
                        //           },
                        //           child: Container(
                        //               padding:
                        //                   EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        //               width: MediaQuery.of(context).size.width,
                        //               decoration: BoxDecoration(
                        //                 color: AppColor.black,
                        //               ),
                        //               child: Column(
                        //                 mainAxisAlignment: MainAxisAlignment.start,
                        //                 crossAxisAlignment: CrossAxisAlignment.start,
                        //                 children: [
                        //                   Text(
                        //                     'VIRTUAL INFLUENCER ROUNDTABLE LUNCHEON',
                        //                     style: TextStyle(
                        //                         color: AppColor.white,
                        //                         fontWeight: FontWeight.bold,
                        //                         fontSize: 12),
                        //                   ),
                        //                   Text(
                        //                     'Date: 29  sept',
                        //                     style: TextStyle(
                        //                         color: AppColor.textlight,
                        //                         fontSize: 11),
                        //                   ),
                        //                   SizedBox(
                        //                     height: 4,
                        //                   ),
                        //                   Text(
                        //                     'founded in 1994, the luxury marketing council worldwide is an exclusiv, "by invitation only" collaborative organization of more than 5,000 top ceos and cmos...',
                        //                     style: TextStyle(
                        //                         color: AppColor.white,
                        //                         fontSize: 11),
                        //                   ),
                        //                   SizedBox(
                        //                     height: 4,
                        //                   ),
                        //                   Row(
                        //                     mainAxisAlignment: MainAxisAlignment.start,
                        //                     crossAxisAlignment: CrossAxisAlignment.start,
                        //                     children: [
                        //                       Text(
                        //                         'Read More',
                        //                         style: TextStyle(
                        //                             color: AppColor.primarycolor,
                        //                             fontSize: 11),
                        //                       ),
                        //                       Container(
                        //                         margin: EdgeInsets.only(top: 5, left: 10),
                        //                         child: Image.asset(
                        //                           'assets/rightarrow.png',
                        //                           scale: 2.9,
                        //                         ),
                        //                       ),
                        //                     ],
                        //                   ),
                        //                 ],
                        //               )),
                        //         );
                        //       },
                        //       separatorBuilder: (BuildContext context, int index) {
                        //         return SizedBox(
                        //           height: 8,
                        //         );
                        //       },
                        //     ),
                        //   ),
                        //  Container(
                        //     margin: EdgeInsets.only(top: 15),
                        //     child: ListView.separated(
                        //       scrollDirection: Axis.vertical,
                        //       shrinkWrap: true,
                        //       primary: false,
                        //       itemCount: 1,
                        //       itemBuilder: (context, index) {
                        //         return Container(
                        //             padding:
                        //                 EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        //             width: MediaQuery.of(context).size.width,
                        //             decoration: BoxDecoration(
                        //               color: AppColor.grey,
                        //               boxShadow: [
                        //                 BoxShadow(blurRadius: 3.0, color: AppColor.black),
                        //               ],
                        //             ),
                        //             child: Column(
                        //               mainAxisAlignment: MainAxisAlignment.start,
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 Text(
                        //                   'INFLUENCER ROUNDTABLE LUNCHEON',
                        //                   style: TextStyle(
                        //                       color: AppColor.white,
                        //                       fontWeight: FontWeight.bold,
                        //                       fontSize: 12),
                        //                 ),
                        //                 Text(
                        //                   'Date: 10 nov',
                        //                   style: TextStyle(
                        //                       color: AppColor.textlight,
                        //                       fontSize: 11),
                        //                 ),
                        //                 SizedBox(
                        //                   height: 4,
                        //                 ),
                        //                 Text(
                        //                   'founded in 1994, the luxury marketing council worldwide is an exclusiv, "by invitation only" collaborative organization of more than 5,000 top ceos and cmos...',
                        //                   style: TextStyle(
                        //                       color: AppColor.white,
                        //                       fontSize: 11),
                        //                 ),
                        //                 SizedBox(
                        //                   height: 4,
                        //                 ),
                        //                 Row(
                        //                   mainAxisAlignment: MainAxisAlignment.start,
                        //                   crossAxisAlignment: CrossAxisAlignment.start,
                        //                   children: [
                        //                     Text(
                        //                       'Read More',
                        //                       style: TextStyle(
                        //                           color: AppColor.primarycolor, fontSize: 11),
                        //                     ),
                        //                     Container(
                        //                       margin: EdgeInsets.only(top: 5, left: 10),
                        //                       child: Image.asset(
                        //                         'assets/rightarrow.png',
                        //                         scale: 2.9,
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ],
                        //             ));
                        //       },
                        //       separatorBuilder: (BuildContext context, int index) {
                        //         return SizedBox(
                        //           height: 8,
                        //         );
                        //       },
                        //     ),
                        //   ),
                        //   Container(
                        //     margin: EdgeInsets.only(top: 15),
                        //     child: ListView.separated(
                        //       scrollDirection: Axis.vertical,
                        //       shrinkWrap: true,
                        //       primary: false,
                        //       itemCount: 1,
                        //       itemBuilder: (context, index) {
                        //         return Container(
                        //             padding:
                        //                 EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        //             width: MediaQuery.of(context).size.width,
                        //             decoration: BoxDecoration(
                        //               color: AppColor.black,
                        //             ),
                        //             child: Column(
                        //               mainAxisAlignment: MainAxisAlignment.start,
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 Text(
                        //                   'VIRTUAL INFLUENCER ROUNDTABLE LUNCHEON',
                        //                   style: TextStyle(
                        //                       color: AppColor.white,
                        //                       fontWeight: FontWeight.bold,
                        //                       fontSize: 12),
                        //                 ),
                        //                 Text(
                        //                   'Date: 29  sept',
                        //                   style: TextStyle(
                        //                       color: AppColor.textlight,
                        //                       fontSize: 11),
                        //                 ),
                        //                 SizedBox(
                        //                   height: 4,
                        //                 ),
                        //                 Text(
                        //                   'founded in 1994, the luxury marketing council worldwide is an exclusiv, "by invitation only" collaborative organization of more than 5,000 top ceos and cmos...',
                        //                   style: TextStyle(
                        //                       color: AppColor.white,
                        //                       fontSize: 11),
                        //                 ),
                        //                 SizedBox(
                        //                   height: 4,
                        //                 ),
                        //                 Row(
                        //                   mainAxisAlignment: MainAxisAlignment.start,
                        //                   crossAxisAlignment: CrossAxisAlignment.start,
                        //                   children: [
                        //                     Text(
                        //                       'Read More',
                        //                       style: TextStyle(
                        //                           color: AppColor.primarycolor, fontSize: 11),
                        //                     ),
                        //                     Container(
                        //                       margin: EdgeInsets.only(top: 5, left: 10),
                        //                       child: Image.asset(
                        //                         'assets/rightarrow.png',
                        //                         scale: 2.9,
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ],
                        //             ));
                        //       },
                        //       separatorBuilder: (BuildContext context, int index) {
                        //         return SizedBox(
                        //           height: 8,
                        //         );
                        //       },
                        //     ),
                        //   ),
                        //   Container(
                        //     margin: EdgeInsets.only(top: 15),
                        //     child: ListView.separated(
                        //       scrollDirection: Axis.vertical,
                        //       shrinkWrap: true,
                        //       primary: false,
                        //       itemCount: 1,
                        //       itemBuilder: (context, index) {
                        //         return Container(
                        //             padding:
                        //                 EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        //             width: MediaQuery.of(context).size.width,
                        //             decoration: BoxDecoration(
                        //               color: AppColor.grey,
                        //               boxShadow: [
                        //                 BoxShadow(blurRadius: 3.0, color: AppColor.black),
                        //               ],
                        //             ),
                        //             child: Column(
                        //               mainAxisAlignment: MainAxisAlignment.start,
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 Text(
                        //                   'INFLUENCER ROUNDTABLE LUNCHEON',
                        //                   style: TextStyle(
                        //                       color: AppColor.white,
                        //                       fontWeight: FontWeight.bold,
                        //                       fontSize: 12),
                        //                 ),
                        //                 Text(
                        //                   'Date: 10 nov',
                        //                   style: TextStyle(
                        //                       color: AppColor.textlight,
                        //                       fontSize: 11),
                        //                 ),
                        //                 SizedBox(
                        //                   height: 4,
                        //                 ),
                        //                 Text(
                        //                   'founded in 1994, the luxury marketing council worldwide is an exclusiv, "by invitation only" collaborative organization of more than 5,000 top ceos and cmos...',
                        //                   style: TextStyle(
                        //                       color: AppColor.white,
                        //                       fontSize: 11),
                        //                 ),
                        //                 SizedBox(
                        //                   height: 4,
                        //                 ),
                        //                 Row(
                        //                   mainAxisAlignment: MainAxisAlignment.start,
                        //                   crossAxisAlignment: CrossAxisAlignment.start,
                        //                   children: [
                        //                     Text(
                        //                       'Read More',
                        //                       style: TextStyle(
                        //                           color: AppColor.primarycolor, fontSize: 11),
                        //                     ),
                        //                     Container(
                        //                       margin: EdgeInsets.only(top: 5, left: 10),
                        //                       child: Image.asset(
                        //                         'assets/rightarrow.png',
                        //                         scale: 2.9,
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ],
                        //             ));
                        //       },
                        //       separatorBuilder: (BuildContext context, int index) {
                        //         return SizedBox(
                        //           height: 8,
                        //         );
                        //       },
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 6,
              )
             /* GlobalData().spotlightListing.isNotEmpty ?
              BottomViewWidget(data : GlobalData().spotlightListing[randomNumber]):
              Container()*/
            ],
          )
    );
  }
}
