import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/widgets/appbars.dart';

class Digest extends StatefulWidget {
  const Digest({super.key});

  @override
  State<Digest> createState() => _DigestState();
}

class _DigestState extends State<Digest> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: AppColor.grey,
      appBar: AppBarDetails(appBar: AppBar(), text: 'MY DIGEST'),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              
              Container(
                margin: EdgeInsets.only(top: 15),
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                       // Get.toNamed("/ArticleVideoAudioDetails");
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppColor.black,
                        ),
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 200,
                                    child: Text(
                                      'ABASPOR, SHAWN',
                                      style: TextStyle(
                                          color: AppColor.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ),
                                  Container(
                                    width: 100,
                                    child: Text(
                                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                                      style: TextStyle(
                                          color: AppColor.textlight,
                                          fontSize: 14),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 20),
                                    child: Image.asset(
                                      'assets/heart.png',
                                      scale: 2.9,
                                    ),
                                  ),
                                ],
                              ),
                              Stack(
                                children: [
                                  Container(
                                    height: 90,
                                    width: 90,
                                    // decoration: BoxDecoration(
                                    //     border: Border.all(color: AppColor.grey)),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Image.asset(
                                            "assets/homeimage2.png",
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                        Center(
                                          child: Image.asset(
                                            "assets/circularplay.png",
                                            scale: 2.9,
                                          ),
                                        ),
                                        Center(
                                          child: Image.asset(
                                            "assets/circularplay2.png",
                                            scale: 2.9,
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.only(top: 2, left: 2),
                                          child: Center(
                                            child: Image.asset(
                                              "assets/play.png",
                                              scale: 2.9,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 45, top: 10),
                                      width: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: AppColor.black),
                                      child: Center(
                                          child: Text(
                                        '5:00',
                                        style: TextStyle(
                                            color: AppColor.white, fontSize: 9),
                                      ))),
                                ],
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
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
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
                        boxShadow: [
                          BoxShadow(blurRadius: 3.0, color: AppColor.black),
                        ],
                      ),
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 200,
                                  child: Text(
                                    'ABASPOR, SHAWN',
                                    style: TextStyle(
                                        color: AppColor.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  child: Text(
                                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                                    style: TextStyle(
                                        color: AppColor.textlight, fontSize: 9),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Image.asset(
                                    'assets/heartselect.png',
                                    scale: 2.9,
                                  ),
                                ),
                              ],
                            ),
                            Stack(
                              children: [
                                Container(
                                  height: 90,
                                  width: 90,
                                  // decoration: BoxDecoration(
                                  //     border: Border.all(color: AppColor.grey)),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Image.asset(
                                          "assets/homeimage2.png",
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                      Center(
                                        child: Image.asset(
                                          "assets/circularplay.png",
                                          scale: 2.9,
                                        ),
                                      ),
                                      Center(
                                        child: Image.asset(
                                          "assets/circularplay2.png",
                                          scale: 2.9,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 2, left: 2),
                                        child: Center(
                                          child: Image.asset(
                                            "assets/play.png",
                                            scale: 2.9,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(left: 45, top: 10),
                                    width: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: AppColor.black),
                                    child: Center(
                                        child: Text(
                                      '5:00',
                                      style: TextStyle(
                                          color: AppColor.white, fontSize: 9),
                                    ))),
                              ],
                            ),
                          ],
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
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: AppColor.black,
                      ),
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 200,
                                  child: Text(
                                    '3 KEY TAKE-AWAYS ABOUT DIGITAL MARKETING FROM TOP BRANDS',
                                    style: TextStyle(
                                        color: AppColor.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  child: Text(
                                    'Top-performing marketers — those ranked “Genius” on the Gartner Digital IQ index — offer critical lessons to use in email, on social, in advertising and on other channels. Contributor: Jackie Wiles',
                                    style: TextStyle(
                                        color: AppColor.textlight, fontSize: 9),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 7),
                                  child: Image.asset(
                                    'assets/heart.png',
                                    scale: 2.9,
                                  ),
                                ),
                              ],
                            ),
                            Stack(
                              children: [
                                Container(
                                  height: 90,
                                  width: 90,
                                  // decoration: BoxDecoration(
                                  //     border: Border.all(color: AppColor.grey)),
                                  child: Center(
                                    child: Image.asset(
                                      "assets/homeimage2.png",
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
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
                        boxShadow: [
                          BoxShadow(blurRadius: 3.0, color: AppColor.black),
                        ],
                      ),
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 200,
                                  child: Text(
                                    '3 KEY TAKE-AWAYS ABOUT DIGITAL MARKETING FROM TOP BRANDS',
                                    style: TextStyle(
                                        color: AppColor.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  child: Text(
                                    'Top-performing marketers — those ranked “Genius” on the Gartner Digital IQ index — offer critical lessons to use in email, on social, in advertising and on other channels. Contributor: Jackie Wiles',
                                    style: TextStyle(
                                        color: AppColor.textlight, fontSize: 14),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 7),
                                  child: Image.asset(
                                    'assets/heart.png',
                                    scale: 2.9,
                                  ),
                                ),
                              ],
                            ),
                            Stack(
                              children: [
                                Container(
                                  height: 90,
                                  width: 90,
                                  // decoration: BoxDecoration(
                                  //     border: Border.all(color: AppColor.grey)),
                                  child: Center(
                                    child: Image.asset(
                                      "assets/homeimage2.png",
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: AppColor.black,
                      ),
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 200,
                                  child: Text(
                                    'ABASPOR, SHAWN',
                                    style: TextStyle(
                                        color: AppColor.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  child: Text(
                                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                                    style: TextStyle(
                                        color: AppColor.textlight, fontSize: 9),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Image.asset(
                                    'assets/heart.png',
                                    scale: 2.9,
                                  ),
                                ),
                              ],
                            ),
                            Stack(
                              children: [
                                Container(
                                  height: 90,
                                  width: 90,
                                  // decoration: BoxDecoration(
                                  //     border: Border.all(color: AppColor.grey)),
                                  child: Center(
                                    child: Image.asset(
                                      "assets/homeimage2.png",
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(left: 45, top: 10),
                                    width: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: AppColor.black),
                                    child: Center(
                                        child: Text(
                                      '5:00',
                                      style: TextStyle(
                                          color: AppColor.white, fontSize: 9),
                                    ))),
                              ],
                            ),
                          ],
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
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
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
                        boxShadow: [
                          BoxShadow(blurRadius: 3.0, color: AppColor.black),
                        ],
                      ),
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 200,
                                  child: Text(
                                    'ABASPOR, SHAWN',
                                    style: TextStyle(
                                        color: AppColor.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  child: Text(
                                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                                    style: TextStyle(
                                        color: AppColor.textlight, fontSize: 14),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Image.asset(
                                    'assets/heartselect.png',
                                    scale: 2.9,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 90,
                              width: 90,
                              // decoration: BoxDecoration(
                              //     border: Border.all(color: AppColor.grey)),
                              child: Center(
                                child: Image.asset(
                                  "assets/homeimage2.png",
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ],
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
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppColor.loginappbar,
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Image.asset(
                          'assets/21club.png',
                          scale: 2.9,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              '21 Club',
                              style: TextStyle(
                                  color: AppColor.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            width: 200,
                            child: Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam elementum feugiat augue, sed pharetra nunc ',
                              style: TextStyle(
                                  color: AppColor.textlight, fontSize: 14),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed("/SpotlightMember");
                            },
                            child: Container(
                              height: 20,
                              width: 90,
                              margin: EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: AppColor.primarycolor,
                              ),
                              child: Center(
                                child: GestureDetector(
                                  child: Text(
                                    'Learn more',
                                    style: TextStyle(
                                        color: AppColor.black, fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      )),
   
    );
  }
}
