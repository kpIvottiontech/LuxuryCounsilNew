import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/config/prefrance.dart';
import 'package:luxury_council/controllers/editprofileController.dart';
import 'package:luxury_council/controllers/homeController.dart';
import 'package:luxury_council/controllers/loginController.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constance/firestore_constants.dart';
import '../constance/global_data.dart';
import '../models/chat/user_chat.dart';
import '../social_login.dart';

class DrawerWidget extends StatefulWidget {
  final bool? isChat;
  final bool? isEvent;

  const DrawerWidget({super.key, this.isChat, this.isEvent});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final HomeController homeController = Get.put(HomeController());
  LoginController loginController = Get.put(LoginController());
  EditProfileController editProfileController =
      Get.put(EditProfileController());

  @override
  void initState() {
    getPreference();
    super.initState();
    checkFirst();
  }

  checkFirst() async {
    // editProfileController.imagePath.value = '';
    await editProfileController.getProfileIntersetList(context, null, 0, 100);
    await editProfileController.getprofile(context);
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color(0xFF1A1A1A).withOpacity(0.8),
        ),
        child: Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 24,
              right: MediaQuery.of(context).size.width / 6,
              top: 16,
              bottom: MediaQuery.of(context).size.height / 19),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColor.black,
                  ),
                  height: MediaQuery.of(context).size.height / 22,
                  width: MediaQuery.of(context).size.height / 22,
                  child: Icon(
                    Icons.close,
                    color: AppColor.primarycolor,
                    size: 32,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 1.2,
                child: Drawer(
                  backgroundColor: AppColor.black,
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                        // color: Colors.red,
                        height: MediaQuery.of(context).size.height / 5.4,
                        child: DrawerHeader(
                            child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(500),
                              child: Container(
                                  height: MediaQuery.of(context).size.width / 3.8,
                                  width: MediaQuery.of(context).size.width / 3.8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColor.white,
                                  ),
                                  child: editProfileController.imagePath.value.isNotEmpty?
                                  Image.network(
                                    editProfileController.imagePath.value, fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context, Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      }
                                    },
                                  )
                                      : Image.asset(
                                    'assets/drawerprofile.png',
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          /*  CircleAvatar(
                                backgroundColor: Colors.greenAccent[400],
                                radius: 46,
                                child: Image.asset(
                                  'assets/drawerprofile.png',
                                  fit: BoxFit.cover,
                                )),*/
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 150,
                                  child: Text(
                                    "${editProfileController.firstname.toString()} ${editProfileController.lastname.toString()}",
                                    style: TextStyle(
                                        color: AppColor.primarycolor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  width: 150,
                                  child: editProfileController
                                          .titleController.text.isNotEmpty
                                      ? Text(
                                          "${editProfileController.title}",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: AppColor.white),
                                          textAlign: TextAlign.start,
                                        )
                                      : SizedBox(),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Get.toNamed("/Profile");
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 5),
                                    height: 30,
                                    width: 110,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: AppColor.primarycolor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'View Profile',
                                        style: TextStyle(
                                            color: AppColor.black,
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);

                                Get.toNamed("/HomeWithSignUp");
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);

                                    Get.toNamed("/HomeWithSignUp");
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/articles.png',
                                        scale: 2.9,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                32,
                                        width:
                                            MediaQuery.of(context).size.height /
                                                32,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        'Articles',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: AppColor.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: widget.isEvent ?? false,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Get.toNamed("/Events");
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(top: 15),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/events.png',
                                        scale: 2.9,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                32,
                                        width:
                                            MediaQuery.of(context).size.height /
                                                32,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        'Events',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: AppColor.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: widget.isChat ?? false,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Get.toNamed("/Chats");
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(top: 15),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/chats.png',
                                        scale: 2.9,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                32,
                                        width:
                                            MediaQuery.of(context).size.height /
                                                32,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        'Chats',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: AppColor.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            GlobalData().groupSubscriptionId == 0
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Get.toNamed("/Subscription");
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.only(top: 15),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/subscriptions.png',
                                            scale: 2.9,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                32,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                32,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            'Subscription',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: AppColor.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            GlobalData().groupSubscriptionId == 0
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Get.toNamed("/GroupSubscription");
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.only(top: 15),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/groupsubscription.png',
                                            scale: 2.9,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                32,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                32,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            'Group Subscription',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: AppColor.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Get.toNamed("/SpotlightListing");
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 15, left: 0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/spotlightmember.png',
                                      scale: 2.7,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              32,
                                      width:
                                          MediaQuery.of(context).size.height /
                                              32,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      'Spotlight Members',
                                      style: TextStyle(
                                          fontSize: 17, color: AppColor.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Get.toNamed("/FavouritePage");
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 15, left: 0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/favourites.png',
                                      scale: 2.9,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              32,
                                      width:
                                          MediaQuery.of(context).size.height /
                                              32,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      'Favorites',
                                      style: TextStyle(
                                          fontSize: 17, color: AppColor.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Get.toNamed("/AboutUs");
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 15),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: AppColor.primarycolor,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      'About Us',
                                      style: TextStyle(
                                          fontSize: 17, color: AppColor.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Get.toNamed("/ContactUs");
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 15),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.contact_emergency_outlined,
                                      color: AppColor.primarycolor,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      'Contact Us',
                                      style: TextStyle(
                                          fontSize: 17, color: AppColor.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height / 22,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  loginController.logOut(context);
                                  homeController.articleList.clear();
                                  homeController.pageNumber.value = 1;
                                  homeController.nosubsarticleList.clear();
                                  homeController.nosubsvideoList.clear();
                                  // RemoveData('facebook_id');
                                  // SocialLogin().facebookLogin?.logOut();
                                  // RemoveData('google_id');
                                  // SocialLogin().googleSignIn.signOut();
                                  // SocialLogin().logoutUser = true;
                                  // SocialLogin().user = null;
                                  // RemoveData('linkedin_id');
                                  // setState(() {});
                                  // RemoveData("Email");
                                  // RemoveData("Password");
                                  // FirebaseFirestore.instance
                                  //     .collection(FirestoreConstants.pathUserCollection)
                                  //     .doc(GlobalData().userId.toString())
                                  //     .update({FirestoreConstants.isOnline: 0});
                                  // Navigator.pop(context);
                                  // Get.offAllNamed("/Login");
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/logout.png',
                                      scale: 2.9,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Logout',
                                      style: TextStyle(
                                          color: AppColor.primarycolor,
                                          fontSize: 18),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getPreference() {}
}

class DrawerWidget2 extends StatefulWidget {
  const DrawerWidget2({
    super.key,
  });

  @override
  State<DrawerWidget2> createState() => _DrawerWidget2State();
}

class _DrawerWidget2State extends State<DrawerWidget2> {
  final HomeController homeController = Get.put(HomeController());
  LoginController loginController = Get.put(LoginController());
  EditProfileController editProfileController =
      Get.put(EditProfileController());

  @override
  void initState() {
    super.initState();
    checkFirst();
  }

  checkFirst() async {
    await editProfileController.getProfileIntersetList(context, null, 0, 100);
    await editProfileController.getprofile(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Color(0xFF1A1A1A).withOpacity(0.8),
        ),
        child: Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 24,
              right: MediaQuery.of(context).size.width / 6,
              top: 16,
              bottom: MediaQuery.of(context).size.height / 19),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColor.black,
                  ),
                  height: MediaQuery.of(context).size.height / 22,
                  width: MediaQuery.of(context).size.height / 22,
                  child: Icon(
                    Icons.close,
                    color: AppColor.primarycolor,
                    size: 32,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 1.2,
                child: Drawer(
                  backgroundColor: AppColor.black,
                  child: ListView(
                    children: [
                      DrawerHeader(
                          child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(500),
                            child: Container(
                                height: MediaQuery.of(context).size.width / 3.8,
                                width: MediaQuery.of(context).size.width / 3.8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor.white,
                                ),
                                child: editProfileController.imagePath.value.isNotEmpty?
                                Image.network(
                                  editProfileController.imagePath.value, fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context, Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    }
                                  },
                                )
                                : Image.asset(
                                  'assets/drawerprofile.png',
                                  fit: BoxFit.cover,
                                )),
                          ),
                        /*  CircleAvatar(
                              backgroundColor: Colors.greenAccent[400],
                              radius: 50,
                              child: Image.asset(
                                'assets/drawerprofile.png',
                                fit: BoxFit.cover,
                              )),*/
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 150,
                                child: Text(
                                  "${editProfileController.firstname.toString()} ${editProfileController.lastname.toString()}",
                                  style: TextStyle(
                                      color: AppColor.primarycolor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: 150,
                                child: editProfileController
                                        .titleController.text.isNotEmpty
                                    ? Text(
                                        "${editProfileController.title}",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: AppColor.white),
                                        textAlign: TextAlign.start,
                                      )
                                    : SizedBox(),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Get.toNamed("/Profile");
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 5),
                                  height: 30,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: AppColor.primarycolor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'View Profile',
                                      style: TextStyle(
                                          color: AppColor.black, fontSize: 13),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Get.toNamed("/Subscription");
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/subscriptions.png',
                                scale: 2.9,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                'Subscription',
                                style: TextStyle(
                                    fontSize: 18, color: AppColor.white),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: GestureDetector(
                                onTap: () {
                                  loginController.logOut(context);
                                  homeController.articleList.clear();
                                  homeController.nosubsarticleList.clear();
                                  homeController.nosubsvideoList.clear();
                                  homeController.pageNumber.value = 1;
                                  // RemoveData("Email");
                                  // RemoveData("Password");
                                  // Navigator.pop(context);
                                  // Get.offAllNamed("/Login");
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/logout.png',
                                      scale: 2.9,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Logout',
                                      style: TextStyle(
                                          color: AppColor.primarycolor,
                                          fontSize: 18),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
