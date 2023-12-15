import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/controllers/eventController.dart';
import 'package:luxury_council/screens/custom_alert.dart';
import 'package:luxury_council/strings.dart';
import 'package:luxury_council/widgets/appbars.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constance/firestore_constants.dart';
import '../constance/global_data.dart';
import 'bottom_view_widget.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
// import 'package:share_plus/share_plus.dart';


class EventDetails extends StatefulWidget {
  const EventDetails({super.key});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  ScreenshotController screenshotController = ScreenshotController();
  final GlobalKey _boundaryKey = GlobalKey();
  EventController eventController = Get.put(EventController());
  File? image;
  String imagePath = "";
  int randomNumber = 0;
  bool isEvent = false;
  int subscriptionid = GlobalData().subscriptionId;
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
                            .pickImage(source: ImageSource.camera);

                        if (image == null) return;

                        final imageTemp = File(image.path);
                      setState(() {
                        imagePath = imageTemp.path;
                        print('imagePath: ${imagePath}');
                      });

                        setState(() => this.image = imageTemp);
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
                            .pickImage(source: ImageSource.gallery);
                        if (image == null) return;
                        final imageTemp = File(image.path);
                        setState(() {
                          imagePath = imageTemp.path;
                          print('imagePath: ${imagePath}');
                        });
                        setState(() => this.image = imageTemp);
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

  // Future pickImage() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.gallery);

  //     if (image == null) return;

  //     final imageTemp = File(image.path);

  //     setState(() => this.image = imageTemp);
  //   } on PlatformException catch (e) {
  //     print('Failed to pick image: $e');
  //   }
  // }

  // Future pickImageC() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.camera);

  //     if (image == null) return;

  //     final imageTemp = File(image.path);

  //     setState(() => this.image = imageTemp);
  //   } on PlatformException catch (e) {
  //     print('Failed to pick image: $e');
  //   }
  // }
  @override
  void initState() {
    Random random = new Random();
    randomNumber = random.nextInt(GlobalData().spotlightListing.length);
    setEventVisibility();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.grey,
      floatingActionButton: GlobalData().spotlightListing.isNotEmpty
          ? Padding(
        padding: EdgeInsets.only(bottom: 0,),
        child: BottomViewWidget(
            data: GlobalData().spotlightListing[randomNumber]),
      )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBarDetails(appBar: AppBar(), text: 'EVENT DETAILS', isNotSubscription: subscriptionid==0||subscriptionid==1||subscriptionid==2||subscriptionid==6,screenName: '/EventDetails'),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Obx(
                () => Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    child: eventController.event_id != null
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${eventController.event_name}',
                                  style: TextStyle(
                                      color: AppColor.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                                Text(
                                  '${DateFormat('dd/MM/yyyy').format(DateTime.parse(eventController.event_date.toString()))}',
                                 // '${eventController.event_date}',
                                  style: TextStyle(
                                      color: AppColor.textlight, fontSize: 14),
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
                                      "${eventController.event_detail.toString()}",
                                ),
                                // Text(
                                //    '${eventController.event_detail}',
                                //    style: TextStyle(
                                //       color: AppColor.white,
                                //       fontSize: 11),
                                // ),
                                SizedBox(
                                  height: 25,
                                ),
                                Visibility(
                                  visible: isEvent??false,
                                  child: Container(
                                    color: AppColor.black,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    imagePicker(context);
                                                  },
                                                  child: Container(
                                                    height: MediaQuery.of(context).size.height / 5.8,
                                                    width: MediaQuery.of(context).size.height / 5,
                                                    decoration: BoxDecoration(
                                                        color: AppColor.grey),
                                                    child: image != null
                                                        ? Image.file(
                                                      image!,
                                                      fit: BoxFit.cover,
                                                    )
                                                        : Icon(Icons.image_outlined,color: Colors.white,size: 30,),
                                                  ),
                                                ),
                                              ],
                                            ),
                                           /* Text(
                                              '${eventController.hash_tags}',
                                              style: TextStyle(
                                                color: AppColor.white, fontSize: 14,fontWeight: FontWeight.w500,),
                                            )*/
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            if(imagePath != ''){
                                              /*Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) =>  ShareToSocial()),
                                              );*/

                                            /*  String? response;
                                            if (image != null) {
                                            response = await FlutterShareMe().shareToWhatsApp(
                                            imagePath: image!.path,
                                            fileType:  FileType.image);
                                            print('response>> $response');
                                            } else {
                                            response = await FlutterShareMe().shareToWhatsApp(msg: 'Kinjal....');
                                            }
*/
                                             // shareToWhatsApp();
                                              print('Image selected>> ${this.image!.path}');
                                             /* AppinioSocialShare().shareToFacebook(
                                                  eventController.hash_tags.value,
                                                '/data/user/0/com.luxury_council.luxury_council/cache/c5d79c31-edc6-4633-8c83-1c9b58ef720d/Screenshot_20231103_130715.jpg'//this.image!.path.toString()

                                              );*/
                                              //shareImageToWhatsApp();



                                             // shareImageAndText(imagePath);

                                             /* await Share.file(
                                                'Image Sharing',
                                                'your_image.png',
                                                File(imagePath).readAsBytesSync(),
                                                'image/png',
                                              );*/   // final fun


                                             // shareImageWithText(image!,eventController.hash_tags.value);

                                              /*Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) =>  ImageTextDialog(image:image! ,imagePath:image!.path ,hashTag: eventController.hash_tags.value,)),
                                              )*/
                                              showImageTextDialog(context);



                                            /*  print('Image selected>> ${image!.path}>>>${eventController.event_name}>>${eventController.hash_tags}');
                                              await Share.shareXFiles([XFile(image!.path)], text: '${eventController.hash_tags}');*/


                                              /*if (Platform.isAndroid) {

                                                shareImageAndText(imagePath);
                                              }else{
                                                ImageShare.shareImageToWhatsApp(imagePath);
                                              }*/

                                            }else{
                                              print('No image selected');
                                              CustomAlert.showAlert(
                                                  context, 'Please select an image first',
                                                  title: 'Luxury Council', btnFirst: 'Ok', handler: (int index) {
                                              });
                                            }
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 120,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: AppColor.primarycolor),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/upload.png',
                                                    scale: 2.9,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'Upload images',
                                                    style: TextStyle(
                                                        color: AppColor.black,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: isEvent??false,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 15),
                                    width: MediaQuery.of(context).size.width,
                                    color: AppColor.black,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    child: Text(
                                      '${eventController.hash_tags}',
                                      style: TextStyle(
                                          color: AppColor.white, fontSize: 14,fontWeight: FontWeight.w500,),
                                    ),
                                  ),
                                )
                              ],
                            ))
                        : Center(
                            child: Text(
                            noEventDetailsFound,
                            style: TextStyle(color: AppColor.primarycolor),
                          )),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 6,
              )
             /* GlobalData().spotlightListing.isNotEmpty
                  ? BottomViewWidget(
                      data: GlobalData().spotlightListing[randomNumber])
                  : Container()*/



              // Container(
              //   margin: EdgeInsets.only(top: 30),
              //   child: ListView.separated(
              //     scrollDirection: Axis.vertical,
              //     shrinkWrap: true,
              //     primary: false,
              //     itemCount: 1,
              //     itemBuilder: (context, index) {
              //       return Container(
              //           width: MediaQuery.of(context).size.width,
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                 'VIRTUAL INFLUENCER ROUNDTABLE LUNCHEON',
              //                 style: TextStyle(
              //                     color: AppColor.white,
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 12),
              //               ),
              //               Text(
              //                 'Date: 29  sept',
              //                 style: TextStyle(
              //                     color: AppColor.textlight,
              //                     fontSize: 11),
              //               ),
              //               SizedBox(
              //                 height: 15,
              //               ),
              //               Text(
              //                 'founded in 1994, the luxury marketing council worldwide is an exclusiv, "by invitation only" collaborative organization of more than 5,000 top ceos and cmos from more than 1,000 major luxury goods and service companies in 41 cities worldwide,the council serves primarily as a catalyyst in bringing  the smartest, most imaginative  marketers of luxury product and services together to explore best practice and critical issues, and share intellgences on best customer and  marketing trends.',
              //                 style: TextStyle(
              //                     color: AppColor.white,
              //                     fontSize: 11),
              //               ),
              //               SizedBox(
              //                 height: 25,
              //               ),
              //               Container(
              //                 color: AppColor.black,
              //                 padding: EdgeInsets.symmetric(
              //                     horizontal: 15, vertical: 10),
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   crossAxisAlignment: CrossAxisAlignment.center,
              //                   children: [
              //                     Row(
              //                       mainAxisAlignment:
              //                           MainAxisAlignment.spaceBetween,
              //                       crossAxisAlignment: CrossAxisAlignment.start,
              //                       children: [
              //                         Container(
              //                             height: 110,
              //                             width: 140,
              //                             child: Image.asset(
              //                               'assets/evnet2.png',
              //                               fit: BoxFit.cover,
              //                             )),
              //                         SizedBox(
              //                           width: 10,
              //                         ),
              //                         Container(
              //                             height: 110,
              //                             width: 140,
              //                             child: Image.asset(
              //                               'assets/evnet1.png',
              //                               fit: BoxFit.cover,
              //                             )),
              //                       ],
              //                     ),
              //                     SizedBox(
              //                       height: 10,
              //                     ),
              //                     Container(
              //                       height: 30,
              //                       width: 120,
              //                       decoration: BoxDecoration(
              //                           borderRadius: BorderRadius.circular(15),
              //                           color: AppColor.primarycolor),
              //                       child: Center(
              //                         child: Row(
              //                           mainAxisAlignment:
              //                               MainAxisAlignment.center,
              //                           children: [
              //                             Image.asset(
              //                               'assets/upload.png',
              //                               scale: 2.9,
              //                             ),
              //                             SizedBox(
              //                               width: 5,
              //                             ),
              //                             Text(
              //                               'Upload images',
              //                               style: TextStyle(
              //                                   color: AppColor.black,
              //                                   fontSize: 10),
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                     ),
              //                     SizedBox(
              //                       height: 5,
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //               Container(
              //                 margin: EdgeInsets.only(top: 15),
              //                 width: MediaQuery.of(context).size.width,
              //                 color: AppColor.black,
              //                 padding: EdgeInsets.symmetric(
              //                     horizontal: 8, vertical: 8),
              //                     child: Text('#Articles, #Virtualinfluencer',style: TextStyle(color: AppColor.white,fontSize: 10),),
              //               )
              //             ],
              //           ));
              //     },
              //     separatorBuilder: (BuildContext context, int index) {
              //       return SizedBox(
              //         height: 8,
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }


/*  Future<void> shareImageAndText(String imagepath) async {
    String imagePath = imagepath;
    String text = eventController.hash_tags.value;

    // Capture the widget as an image
    final boundary = _boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 10.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final uint8List = byteData!.buffer.asUint8List();
    // Share picked image and text using esys_flutter_share_plus
   // await Share.file('Share Image and Text', 'image.png', uint8List, 'image/png', text: text);
    try {
      await Share.file(
        'Image via WhatsApp', // Title of the share dialog
        'image.jpg', // File name that will be shown
        uint8List, // Uint8List from the image file
        'image/jpeg', // Mime type of the image
        text: text, // Text to be shared along with the image
      );
    } catch (e) {
      print('Error: $e');
    }
  }*/

/*  Future<void> shareImageWithText() async {
    if (imagePath != '' && eventController.hash_tags.value.isNotEmpty) {
      // Get bytes of the selected image
      final Uint8List imageBytes = await image!.readAsBytes();

      // Overlay text on the image
      final img.Image image1 = img.decodeImage(imageBytes)!;
      final img.Image resizedImage = img.copyResize(image1, width: 300);
      print('----------${resizedImage.height}');// Resize the image if needed

      // Draw text on the image
      img.drawString(resizedImage, eventController.hash_tags.value, font: img.arial14,x: 0, y: resizedImage.height-50);

      // Convert image back to bytes
      final Uint8List mergedImageBytes = Uint8List.fromList(img.encodePng(resizedImage));
      // Share the image with text to WhatsApp
      await Share.file(
        'Share via WhatsApp',
        'image_with_text.png',
        mergedImageBytes,
        'image/png',
        text: '${eventController.hash_tags.value}',
      );
    }
  }*/




/*  Future<void> shareImageToWhatsApp() async {
    if (image!.path.isNotEmpty) {
      try {
        final appDocDir = await getApplicationDocumentsDirectory();
        final fileName = 'image.jpg'; // Define a name for the image file
        final localFile = File('${appDocDir.path}/$fileName');

        // Copy the picked image to the app's documents directory
        await image!.copy(localFile.path);

        final whatsappUrl = "whatsapp://send?text=${eventController.hash_tags.value}"
            "media=${Uri.file(localFile.path)}";

        if (await canLaunch(whatsappUrl)) {
          await launch(whatsappUrl);
        } else {
          throw 'Could not launch $whatsappUrl';
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }*/



 /* Future<void> shareFileText() async {
    final text = eventController.hash_tags;
    final String filePath = image!.path; // Replace with the actual file path

    print('filePath: $filePath >>> $text');
   // final ByteData byteData = await rootBundle.load(filePath);
    final image1 = await rootBundle.load(filePath);
   // final List<int> bytes = byteData.buffer.asUint8List();
    final buffer = image1.buffer;
   // Share.shareXFiles([XFile.fromData(buffer.asUint8List(image1.offsetInBytes,image1.lengthInBytes),
    Share.shareXFiles([XFile(filePath)],subject: ,text: ,

    name: eventController.hash_tags.value,mimeType: 'image/png'
    );

   *//* await Share.file(
      'Share via WhatsApp',
      'your_file_name.extension',
      bytes,
      'image/png', // Replace with the appropriate MIME type
      text: text.value,
    );*//*
  }*/

  /*Future<void> shareToWhatsApp(String message, String filePath) async{
    String response = await appinioSocialShare.shareToWhatsapp(message,filePath: filePath);
    print(response);
  }*/




  Future<void> setEventVisibility() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int id = pref.getInt('subscription_id') ?? 0;
    setState(() {
      isEvent =  id == 5 ;
    });
    FirebaseFirestore.instance
        .collection(FirestoreConstants.pathUserCollection)
        .doc(GlobalData().userId.toString())
        .update({FirestoreConstants.isOnline: 1});
    // GlobalData().retrieveLoggedInUserDetail();
  }

  Future<void> showImageTextDialog(BuildContext context) async {
    ScreenshotController screenshotController = ScreenshotController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor:AppColor.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(Icons.close, color: AppColor.white,size: 32,),
                  ),
                ),
              ),
              Screenshot(
                controller: screenshotController,
                child: Container(
                  color: AppColor.black,
                  child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 2,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color:AppColor.black,),
                          child: image != null
                              ? Image.file(
                            image!,
                            fit: BoxFit.fitHeight,
                          )
                              : Icon(Icons.image_outlined,color: Colors.white,size: 30,),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          '${eventController.hash_tags ?? ""}',
                          //'sadnasnas dsa csa c ncasn cnas cas   c cc kjasncas cas cjsacsa cs cjsa cjas c asc as cs cs cnsdckjas cc',
                          style: TextStyle(
                            color: AppColor.white, fontSize: 18,fontWeight: FontWeight.w500,),
                        )
                      ]
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 10,),
              GestureDetector(
                onTap: () async {
                  await screenshotController
                      .capture(delay: const Duration(milliseconds: 10))
                      .then((image) async {
                    if (image != null) {
                      final directory = (await getApplicationDocumentsDirectory()).path;

                      File imagePath = await File(
                          '${directory}/capturewidget_${Random().nextInt(1000)}.png')
                          .create();
                      print('File path::::::::${imagePath.path}');
                      await imagePath.writeAsBytes(image);
                      if (imagePath != '') {
                        await Share.file(
                          'Image Sharing',
                          'your_image.png',
                          File(imagePath.path).readAsBytesSync(),
                          'image/png',
                        );
                      }
                    }
                  });
                },
                child: Container(
                  height: 30,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(15),
                      color: AppColor.primarycolor),
                  child: Center(
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Icon(Icons.share,color: AppColor.black,size: 22,),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Share image',
                          style: TextStyle(
                              color: AppColor.black,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
             // SizedBox(height: MediaQuery.of(context).size.height / 30,),
            ],
          ),
        );
      },
    );
  }

  captureWiget() async {
    await screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((image) async {
      if (image != null) {
        final directory = (await getApplicationDocumentsDirectory()).path;

        File imagePath = await File(
            '${directory}/capturewidget_${Random().nextInt(1000)}.png')
            .create();
        print('File path::::::::${imagePath.path}');
        await imagePath.writeAsBytes(image);
        if (imagePath != '') {
          await Share.file(
            'Image Sharing',
            'your_image.png',
            File(imagePath.path).readAsBytesSync(),
            'image/png',
          );
        }
      }
    });
  }
}
