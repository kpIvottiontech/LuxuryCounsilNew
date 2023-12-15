import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:luxury_council/colors.dart';
import 'package:get/get.dart';
import 'package:luxury_council/config/prefrance.dart';
import 'package:luxury_council/config/utils.dart';
import 'package:luxury_council/constance/global_data.dart';
import 'package:luxury_council/controllers/companylistController.dart';
import 'package:luxury_council/controllers/editprofileController.dart';
import 'package:luxury_council/controllers/filterController.dart';
import 'package:luxury_council/controllers/loginController.dart';

import '../widgets/player_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FilterController filterController = Get.put(FilterController());
  LoginController loginController = Get.put(LoginController());
  EditProfileController editProfileController =
      Get.put(EditProfileController());
  final CompanylistController companyController = Get.put(CompanylistController());
  File? image;
  String imagePath = "";

  @override
  void initState() {
    PlayerScreenState().assetsAudioPlayer.dispose();
    checkFirst();
    super.initState();
  }
  checkFirst() async {
   // editProfileController.imagePath.value = '';
    await editProfileController.getProfileIntersetList(context, null, 0, 100);
    await editProfileController.getprofile(context);
    await companyController.getCompanyListWithoutPagination(context);
  }

    Future<Uint8List> compressImage(File file) async {
      var result = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: 2300,
        minHeight: 1500,
        quality: 94,
        rotate: 90,
      );
      print(file.lengthSync());
      print(result!.length);
      return result;
  }

  Future<dynamic> imagePicker(BuildContext context) {
    //if (Platform.isIOS) {
    return showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          height: 120,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_sharp,
                  color: Colors.black,
                ),
                title: Text(
                  "Camera",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: Colors.black),
                ),
                onTap: () async {
                  Get.back();
                  try {
                    final image = await ImagePicker()
                        .pickImage(source: ImageSource.camera,imageQuality: 30);

                    if (image == null) return;

                    final imageTemp = File(image.path);
                    setState(() {
                      imagePath = imageTemp.path;
                      print('imagePath: ${imagePath}');
                    });
                    setState(() => this.image = imageTemp);
                    await editProfileController.editprofile(context,editProfileController.profileselectedId.value,image:imagePath, type: true);
                    // editProfileController.showProgressIndicator(context);
                    await editProfileController.getprofile(context);

                   /* compressImage(imageTemp).then((value) async {
                      await editProfileController.editprofile(context,editProfileController.profileselectedId.value,image: value!.path, type: true);
                    });*/

                   // await editProfileController.getprofile(context);
                  } on PlatformException catch (e) {
                    print('Failed to pick image: $e');
                  }
                },
              ),
              ListTile(
                onTap: () async {
                  Get.back();
                  try {
                    final image = await ImagePicker()
                        .pickImage(source: ImageSource.gallery,imageQuality: 30);
                    if (image == null) return;
                    final imageTemp = File(image.path);
                    setState(() {
                      imagePath = imageTemp.path;
                      print('imagePath: ${imagePath}');
                    });
                    setState(() => this.image = imageTemp);
                    editProfileController.editprofile(context,editProfileController.profileselectedId.value,image: imagePath, type: true);
                   // await editProfileController.getprofile(context);
                  } on PlatformException catch (e) {
                    print('Failed to pick image: $e');
                  }


                },
                leading: const Icon(Icons.image, color: Colors.black),
                title: Text(
                  "Gallery",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: Colors.black),
                ),
              ),
            ],
          ),
        ));
  }

  Widget getImageWidget() {
    if (editProfileController.imagePath.value != null &&
        editProfileController.imagePath.value.isNotEmpty) {
      if (editProfileController.imagePath.value != '' && imagePath == '') {
        // Display the container in white
        return Container(
          color: AppColor.white,
        );
      } else {
        // Display the image file
        return Image.file(
          File(imagePath),
          fit: BoxFit.cover,
        );
      }
    } else {
      // Display the default image asset
      return Image.asset(
        'assets/drawerprofile.png',
        fit: BoxFit.cover,
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    print('imagePath:vvds ${editProfileController.imagePath.value}');
    return GetBuilder<EditProfileController>(
        id: 'profile',
        init: EditProfileController(),
        builder: (profile) {
          return Scaffold(
            backgroundColor: AppColor.grey,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            color: AppColor.appbar.withOpacity(0.001),
                            padding: EdgeInsets.only(left: 8),
                            width: 50,
                            height: 50,
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: AppColor.white,
                              size: 20,
                            ),
                          ),),
                      ),
                      Center(
                          child: Image.asset(
                            'assets/profilebg1.png',
                            scale: 2.9,
                          )),
                      GestureDetector(
                        onTap: () {
                          imagePicker(context);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 60),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(500),
                                  child: Container(
                                      height: MediaQuery.of(context).size.width / 3,
                                      width: MediaQuery.of(context).size.width / 3,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColor.white,
                                      ),
                                      child: editProfileController.imagePath.value.isNotEmpty?
                                      (editProfileController.imagePath.value.isNotEmpty && imagePath == '')?
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
                                  ):
                                      Image.file(
                                        File(imagePath),
                                        fit: BoxFit.cover,
                                      )
                                          :
                                      imagePath != ''?
                                      Image.file(
                                        File(imagePath),
                                        fit: BoxFit.cover,
                                      ): Image.asset(
                                        'assets/drawerprofile.png',
                                        fit: BoxFit.cover,
                                      )),
                                ),
                              ),
                            ),
                            Positioned(
                              right: MediaQuery.of(context).size.width / 4,
                              bottom: 20,
                              child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColor.black,
                                  ),
                                  child: Icon(Icons.edit, color: AppColor.primarycolor, size: 20)),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    "${editProfileController.firstname} ${editProfileController.lastname}",
                    style: TextStyle(
                        color: AppColor.primarycolor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        height: 1.2),
                    textAlign: TextAlign.center,
                  ),
                  editProfileController.titleController.text.isNotEmpty
                      ? Text(
                    "${editProfileController.title}",
                    style: TextStyle(fontSize: 15, color: AppColor.white),
                    textAlign: TextAlign.center,
                  )
                      : SizedBox(),
                  SizedBox(
                    height: 20,
                  ),
                  editProfileController.startdate.isNotEmpty && GlobalData().subscriptionId!=0
                      ? Container(
                    //  margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/5),
                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/30, horizontal: MediaQuery.of(context).size.height/21,),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: AppColor.black),
                    child: Column(
                      children: [
                        Text(
                          "Your Subscription Plan",
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColor.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColor.white,
                              decorationThickness: 1
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          editProfileController.subscriptionname.value.toString(),
                          style: TextStyle(
                              fontSize: 16,
                              color: AppColor.primarycolor,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        GlobalData().groupSubscriptionId == 0?
                        Column(
                          children: [
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              editProfileController.subscriptiontype.toString() ==
                                  '1'
                                  ? "\$${editProfileController.subscriptionmonth}.00 / MONTH"
                                  : "\$${editProfileController.subscriptionyear}.00 / YEAR",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppColor.primarycolor,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Start Date:  ${Utils.dateFormate(editProfileController.startdate.toString())}",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColor.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Next Payment Date:  ${Utils.dateFormate(editProfileController.enddate.toString())}",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColor.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                print('cancel subscription');
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return    AlertDialog(
                                      title: Text('Cancel Subscription'),
                                      content: Text('Are you sure you want to cancel your subscription?'),
                                      actions: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context).size.height/20,
                                              width: MediaQuery.of(context).size.width/4,
                                              color: AppColor.primarycolor,
                                              child: TextButton(
                                                onPressed: () {
                                                  // Close the dialog
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('No',style: TextStyle(color: AppColor.black,fontSize: 15),),
                                              ),
                                            ),
                                            SizedBox(width: 14,),
                                            Container(
                                              height: MediaQuery.of(context).size.height/20,
                                              width: MediaQuery.of(context).size.width/4,
                                              color: AppColor.primarycolor,
                                              child: TextButton(
                                                onPressed: () {
                                                  editProfileController.cancelsub(context);
                                                },
                                                child: Text('Yes',style: TextStyle(color: AppColor.black,fontSize: 15),),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );

                              },
                              child: Container(
                                height: 40,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: AppColor.primarycolor),
                                child: Center(
                                  child: Text(
                                    'Cancel Subscription',
                                    style: TextStyle(
                                        color: AppColor.black, fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ):SizedBox(),
                      ],
                    ),
                  )
                      : SizedBox(),
                  GestureDetector(
                    onTap: () {
                      Get.offAndToNamed("/EditProfile");
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.grey, width: 1),
                        color: AppColor.grey,
                        boxShadow: [
                          BoxShadow(blurRadius: 3.0, color: AppColor.black),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Image.asset(
                                'assets/edit.png',
                                scale: 2.9,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Edit Profile',
                              style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GlobalData().groupSubscriptionId == 0?
                  GestureDetector(
                    onTap: () {

                      Get.toNamed("/Subscription");
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: AppColor.black,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Image.asset(
                                'assets/subscriptions.png',
                                scale: 2.2,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Change Subscription',
                              style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ):SizedBox(),
                ],
              ),
            ),
          );
    });


  }
}
