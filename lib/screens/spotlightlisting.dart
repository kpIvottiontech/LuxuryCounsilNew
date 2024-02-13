import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/controllers/spotlight_listing_controller.dart';
import 'package:luxury_council/widgets/appbars.dart';

import '../constance/global_data.dart';
import '../widgets/app_loader.dart';
import '../widgets/aspect_size.dart';

class SpotlightListing extends StatefulWidget {
  const SpotlightListing({super.key});

  @override
  State<SpotlightListing> createState() => _SpotlightListingState();
}

class _SpotlightListingState extends State<SpotlightListing> {

  final SpotlightListingController spotlightListingController = Get.put(SpotlightListingController());
  final ScrollController scrollController = ScrollController();
  int page = 1;

int subscriptionid = GlobalData().subscriptionId;
  @override
  void initState() {
    spotlightListingController.getSpotlightListing(context, page);
    scrollController.addListener(pagination);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    //print('check>> ${spotlightListingController.spotlightListing[4].spotlightMemberCompanyLogoLink}');
    return Scaffold(
      backgroundColor: AppColor.grey,
      appBar: AppBarDetails(appBar: AppBar(), text: 'SPOTLIGHT MEMBERS', isNotSubscription: subscriptionid==0||subscriptionid==1||subscriptionid==2||subscriptionid==6,screenName: '/SpotlightListing'),
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
      //     'Spotlight Member',
      //     style: TextStyle(
      //         color: AppColor.white, fontWeight: FontWeight.bold, fontSize: 16),
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
      //   backgroundColor: AppColor.appbar,
      //   //   shadowColor: AppColor.loginappbar,
      //   centerTitle: false,
      //   bottomOpacity: 1.0,
      //   elevation: 4,
      // ),
      body:
      Obx(()=>
      spotlightListingController.spotlightListing.isNotEmpty ?
          Column(children: [
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(left: 15, right: 15, top: 25),
                controller: scrollController,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: spotlightListingController.spotlightListing.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      Get.toNamed("/SpotlightMember", arguments: [
                        spotlightListingController.spotlightListing[index].spotlightMemberId
                      ]);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: index % 2 == 0
                              ? AppColor.black
                              : AppColor.lightgrey
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl:spotlightListingController.spotlightListing[index].spotlightMemberCompanyLogoLink?? '',
                              placeholder: (context, url) =>
                              const AppLoader(type: LoaderType.activityIndicator),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                              fit: BoxFit.fill,
                              width: AspectSize.getWidthSize(
                                  context: context, sizeConstant: 115),
                              height: AspectSize.getWidthSize(
                                  context: context, sizeConstant: 110),

                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        spotlightListingController.spotlightListing[index].spotlightMemberContactName ?? '',
                                        style: TextStyle(
                                            color: AppColor.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 5),
                                      width: 200,
                                      child: Text(
                                        spotlightListingController.spotlightListing[index].spotlightMemberCompanyShortDescription?? '',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color:
                                            AppColor.white,
                                            fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                      height: 25,
                                      width: 90,
                                      margin: EdgeInsets.only(top: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: AppColor.primarycolor,
                                      ),
                                      child: Center(
                                        child: GestureDetector(
                                          child: Text(
                                            'Learn more',
                                            style: TextStyle(
                                                color: AppColor.black,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 10,
                  );
                },
              ),
            ),
            Visibility(
              visible: spotlightListingController.isLoading.value && page != 1,
              child: const AppLoader(
                type: LoaderType.activityIndicator,
              ),
            ),
          ],):
      Container()
      ),
    );
  }

  void pagination() {
    if ((scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) &&
        !spotlightListingController.isLastPage.value &&
        !spotlightListingController.isLoading.value) {
      setState(() {
        spotlightListingController.isLoading = true.obs;
        page += 1;
        spotlightListingController.getSpotlightListing(context, page);
        //add api for load the more data according to new page
      });
    }
  }
}
