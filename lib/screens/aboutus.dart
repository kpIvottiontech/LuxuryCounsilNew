
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/controllers/aboutus_controller.dart';
import 'package:luxury_council/strings.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constance/global_data.dart';
import '../widgets/app_loader.dart';
import '../widgets/appbars.dart';
import 'bottom_view_widget.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final AboutUsController aboutUsController = Get.put(AboutUsController());
  WebViewController? webViewController;
  PageController pageController = PageController();
  int currentIndex = 0;
  int randomNumber = 0;
int subscriptionid = GlobalData().subscriptionId;
  double aspectRatio = 16 / 6;
  @override
  void initState() {
    Random random = new Random();
    randomNumber = random.nextInt(GlobalData().spotlightListing.length);
    aboutUsController.getAboutUsAPI(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.grey,
      appBar: AppBarDetails(appBar: AppBar(), text: 'ABOUT US' ,isNotSubscription: subscriptionid==0||subscriptionid==1||subscriptionid==2||subscriptionid==6,screenName: '/AboutUs'),
      body:
      Obx(()=>
      aboutUsController.aboutUs.value?.header != null ?
      SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            aboutUsController.aboutUs.value?.header ?? '',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColor.white, fontSize: 15)),
        SizedBox(height: 10,),
        Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child:
            CachedNetworkImage(
              imageUrl:aboutUsController.aboutUs.value?.image ?? '',
              placeholder: (context, url) =>
              const AppLoader(type: LoaderType.activityIndicator),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Html(
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
          "${aboutUsController.aboutUs.value?.headerLongDesc ?? ''}",
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          color: AppColor.black,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
              horizontal: 15, vertical: 7),
          child: Text(
            testmonials,
            style: TextStyle(
                color: AppColor.primarycolor,
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        ExpandablePageView.builder(
          controller: pageController,
          onPageChanged: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          itemCount: (aboutUsController.aboutUs.value?.testimonials ?? []).length,
          itemBuilder: (context, index) {
            String name = aboutUsController.aboutUs.value?.testimonials?[index].testimonialsName ?? '';
            String title = aboutUsController.aboutUs.value?.testimonials?[index].testimonialsTitle ?? '';
            String desc = aboutUsController.aboutUs.value?.testimonials?[index].testimonialsDesc ?? '';
            return Container(
              width: MediaQuery.of(context).size.width,
              //height: containerHeight, // Set the height of the container
              margin: EdgeInsets.symmetric(horizontal: 0),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              decoration: BoxDecoration(
                color: AppColor.black,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$name ($title)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor.white,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.9,
                      child: Text(
                        desc,
                        maxLines: 5,
                        style: TextStyle(
                          color: AppColor.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
              },
              child: Image.asset(
                'assets/leftarrow.png',
                scale: 2.5,
                color: currentIndex == 0 ?AppColor.white : AppColor.primarycolor,
              ),
            ),
            SizedBox(
              width: 30,
            ),
            GestureDetector(
              onTap: (){
                pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
              },
              child: Image.asset(
                'assets/rightarrow.png',
                scale: 1.4,
                color: currentIndex == ((aboutUsController.aboutUs.value?.testimonials?.length ?? 0)-1) ?AppColor.white : AppColor.primarycolor,
              ),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
        ),
      ) : Container()
      ),
    );
  }

}
