import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/constance/global_data.dart';
import 'package:luxury_council/controllers/spotlight_details_controller.dart';

import '../config/prefrance.dart';
import '../widgets/app_loader.dart';
import '../widgets/appbars.dart';
import '../widgets/aspect_size.dart';

class SpotlightMember extends StatefulWidget {
  final int memberId;

  const SpotlightMember({super.key, required this.memberId});

  @override
  State<SpotlightMember> createState() => _SpotlightMemberState();
}

class _SpotlightMemberState extends State<SpotlightMember> {
  final SpotlightDetailsController spotlightDetailsController =
      Get.put(SpotlightDetailsController());
  String userName = '';
  TextEditingController nameCtr = TextEditingController();

  String messageText = '';
  int subscriptionid = GlobalData().subscriptionId;

  @override
  void initState() {
    print('messageText>> ${messageText}');
    checkFirst();
    super.initState();
  }

  checkFirst() async {
    await spotlightDetailsController.getSpotlightDetails(
        context, widget.memberId);
    print('spotlight>> ${spotlightDetailsController.spotlightData.value!.spotlightMemberContactName}');
    spotlightDetailsController.updateScreen('spotlight');
    await getData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SpotlightDetailsController>(
        id: 'spotlight',
        init: SpotlightDetailsController(),
        builder: (spotlight) {
          return Scaffold(
            backgroundColor: AppColor.grey,
            floatingActionButton: GestureDetector(
              onTap: () {
                //convertTextToHtml();
                print('text is here>> ${nameCtr.text.toString()}');
                spotlight.sendSpotlightMail(
                    context,
                    spotlight.spotlightData.value?.spotlightMemberContactEmail ?? '',
                    convertTextToHtml());
              },
              child: Container(
                color: AppColor.grey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    height: 45,
                    decoration: BoxDecoration(
                        color: AppColor.primarycolor,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: Text('Send',
                          style: TextStyle(
                              color: AppColor.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ),
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            appBar: AppBarDetails(
                appBar: AppBar(),
                text: 'SPOTLIGHT MEMBER',
                isNotSubscription: subscriptionid == 0 ||
                    subscriptionid == 1 ||
                    subscriptionid == 2 ||
                    subscriptionid == 6,
                screenName: '/SpotlightMember',
                plan1: widget.memberId.toString()),
            body: Obx(() => spotlight
                        .spotlightData.value?.spotlightMemberId !=
                    null
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: AppColor.grey,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        // height: 200,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: AppColor.black),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl:
                                                    spotlight
                                                                .spotlightData
                                                                .value
                                                                ?.spotlightMemberCompanyLogoLink ??
                                                            '',
                                                    placeholder: (context,
                                                            url) =>
                                                        const AppLoader(
                                                            type: LoaderType
                                                                .activityIndicator),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                    fit: BoxFit.fill,
                                                    width: AspectSize.getWidthSize(
                                                        context: context,
                                                        sizeConstant:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                4),
                                                    height: AspectSize.getWidthSize(
                                                        context: context,
                                                        sizeConstant:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                4),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 2),
                                                    child: Text(
                                                      spotlight
                                                              .spotlightData
                                                              .value
                                                              ?.spotlightMemberContactName ??
                                                          '',
                                                      style: TextStyle(
                                                          color: AppColor.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 16, bottom: 10),
                                              child: Text(
                                                spotlight
                                                        .spotlightData
                                                        .value
                                                        ?.spotlightMemberCompanyShortDescription ??
                                                    '',
                                                style: TextStyle(
                                                    color: AppColor.white,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                        /*Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/21club.png',
                                  scale: 1.6,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam elementum feugiat augue, sed pharetra nunc',
                                  style: TextStyle(
                                      color: AppColor.white,
                                      fontSize: 12),
                                ),
                              ],
                            ),*/
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Html(
                                          style: {
                                            '#': Style(
                                              color: AppColor.white,
                                              backgroundColor: AppColor.black,
                                            ),
                                            'h1': Style(
                                              color: AppColor.white,
                                            ),
                                            'body': Style(
                                                // backgroundColor: AppColor.black,
                                                color: AppColor.white,
                                                fontSize: FontSize.medium),
                                            'p': Style(
                                                color: AppColor.white,
                                                fontSize: FontSize.medium),
                                          },
                                          data:
                                              '${spotlightDetailsController.spotlightData.value?.spotlightMemberCompanyLongDescription}'),
                                      /* Text(
                            spotlightDetailsController.spotlightData.value?.spotlightMemberCompanyLongDescription??'',
                            style:
                            TextStyle(color: AppColor.white, fontSize: 14),
                          ),*/
                                      /* SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Sed a nibh eros. Morbi mattis felis erat. Vestibulum rutrum nulla at lacus dignissim, nec aliquet augue aliquet. Praesent eu tempus odio. Interdum et malesuada fames ac ante ipsum primis in faucibus. Ut pharetra ullamcorper augue non scelerisque. Vestibulum sollicitudin velit ac ex tempus commodo. Etiam placerat elementum lobortis. Integer vel quam velit. Etiam a nunc rhoncus, ullamcorper arcu sed, convallis sem. Integer malesuada lorem ligula, vitae laoreet diam tincidunt ut. Mauris elementum consectetur diam, at viverra urna placerat pulvinar.',
                            style:
                            TextStyle(color: AppColor.white, fontSize: 12),
                          ),*/
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/email.png',
                                            scale: 2.9,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            spotlight
                                                    .spotlightData
                                                    .value
                                                    ?.spotlightMemberContactEmail ??
                                                '',
                                            style: TextStyle(
                                                color: AppColor.white,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        spotlight
                                                .spotlightData
                                                .value
                                                ?.spotlightMemberContactName ??
                                            '',
                                        style: TextStyle(
                                            color: AppColor.primarycolor,
                                            fontSize: 16),
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      TextFormField(
                                        controller: nameCtr,
                                        maxLines: 8,
                                        validator: (address) {
                                          if (address == '') {
                                            return "Please enter message";
                                          }
                                        },
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.white),
                                        keyboardType: TextInputType.multiline,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(8),
                                            hintText: 'Write Message',
                                            hintStyle: TextStyle(
                                                color: AppColor.white),
                                            disabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: AppColor.primarycolor),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: AppColor.primarycolor),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: AppColor.primarycolor),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: AppColor.primarycolor),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: AppColor.primarycolor),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: AppColor.primarycolor),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            )),
                                      ),
                                      /*Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 7, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                Border.all(color: AppColor.primarycolor)),
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dear ${spotlightDetailsController.spotlightData.value?.spotlightMemberContactName}',
                                  style: TextStyle(
                                      color: AppColor.white, fontSize: 14),
                                ),SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'I found your profile on the Luxury Council app and wanted to inquire about services. I look forward to connecting soon.',
                                  style: TextStyle(
                                      color: AppColor.white, fontSize: 14),
                                ),SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Best\n$userName',
                                  style: TextStyle(
                                      color: AppColor.white, fontSize: 14),
                                ),
                              ],
                            ),
                          ),*/
                                      /*   GestureDetector(
                            onTap:(){
                              spotlightDetailsController.sendSpotlightMail(context,
                                  spotlightDetailsController.spotlightData.value?.spotlightMemberContactEmail?? ''
                                  ,nameCtr.text.toString());
                                  },
                            child: Container(
                              margin: EdgeInsets.only(top: 35, bottom: 10),
                              height: 45,
                              decoration: BoxDecoration(
                                  color: AppColor.primarycolor,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Center(
                                child: Text('Send',
                                    style: TextStyle(
                                        color: AppColor.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                              ),
                            ),
                          ),*/
                                    ],
                                  ));
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 8,
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                      ],
                    ),
                  )
                : Container()),
          );
        });
  }

  Future<void> getData() async {
    userName = await GetData("first_name") ?? "";
    messageText =setController();
       /* '''Dear ${spotlightDetailsController.name},
    I found your profile on the Luxury Council app and wanted to inquire about services. I look forward to connecting soon.
    Best
    $userName''';*/
    nameCtr.text = messageText;
  }

  String convertTextToHtml() {
    print('nameCtr>> ${nameCtr.text}');
    final lines = nameCtr.text.split('\n'); // Split text into lines
    //final htmlLines = lines.map((line) => '<p style="color: black">${line.trim()}</p><br>').join();
    final htmlLines = lines.map((line) => '<p style="color: black">${line.trim()}</p><p>').join();

    final htmlContent = '''
    <html>
      <body>
        $htmlLines
        </p>
      </body>
    </html>
  ''';
    print('html content >>$htmlContent');

    return htmlContent;
  }

  /*setController() {
    nameCtr.text =
        '''Dear ${spotlightDetailsController.spotlightData.value?.spotlightMemberContactName},
    I found your profile on the Luxury Council app and wanted to inquire about services. I look forward to connecting soon.
   Best
   $userName''';
    print('nameCtr>> ${nameCtr.text}');
    return nameCtr;
  }*/

  setController() {
    final String contactName = spotlightDetailsController.spotlightData.value?.spotlightMemberContactName ?? '';
    final String message = '''no space Dear $contactName,
no spaceI found your profile on the Luxury Council app and wanted to inquire about services. I look forward to connecting soon.
no spaceBest
no space$userName''';

    // Replace the 'no space' and 'space' markers with actual spaces and newlines respectively
    final formattedMessage = message
        .replaceAll('no space','')
        .replaceAll('space',' '); // Replace 'space' with newline character for new line

    nameCtr.text = formattedMessage.trim(); // Trim removes leading/trailing spaces

    print('nameCtr >> ${nameCtr.text}');
    return nameCtr;
  }


}
