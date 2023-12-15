import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/controllers/ForgotPasswordController.dart';
import 'package:luxury_council/controllers/contact_us_controller.dart';
import 'package:luxury_council/screens/bottom_view_widget.dart';
import 'package:luxury_council/widgets/edittext.dart';

import '../../constance/global_data.dart';
import '../../widgets/appbars.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  /*final ContactUsController contactUsController =
      Get.put(ContactUsController());*/
  final ForgotPasswordController forgotPasswordController = Get.put(ForgotPasswordController());
  TextEditingController emailCtr = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool onSubmitTap = false;
  int randomNumber = 0;

  @override
  void initState() {
    // Random random = new Random();
    // randomNumber = random.nextInt(GlobalData().spotlightListing.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      backgroundColor: AppColor.grey,
      appBar: AppBar(
      backgroundColor: AppColor.appbar,
      bottomOpacity: 1.0,
      elevation: 4,
      leadingWidth: 30,
      title: Text(
        'FORGOT PASSWORD',
        style: TextStyle(
            color: AppColor.white, fontWeight: FontWeight.bold, fontSize: 16),
        textAlign: TextAlign.left,
      ),
      leading: GestureDetector(
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
        ),
      )),
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
          SafeArea(
            child: Column(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      child: Column(
                        children: [
                         SizedBox(height: 50,),
                          EditText1(
                            hint: "Email",
                            controller:
                            forgotPasswordController.EmailController,
                            inputformtters: [
                              LengthLimitingTextInputFormatter(60),
                              FilteringTextInputFormatter.deny(" "),
                              FilteringTextInputFormatter.deny("[]"),
                              FilteringTextInputFormatter.deny("["),
                              FilteringTextInputFormatter.deny("]"),
                              FilteringTextInputFormatter.deny("^"),
                              FilteringTextInputFormatter.deny(""),
                              FilteringTextInputFormatter.deny("`"),
                              FilteringTextInputFormatter.deny("/"),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9a-zA-z._@]')),
                              FilteringTextInputFormatter.deny(
                                  RegExp(r"/"))
                            ],
                            validator: (email) {
                              if (email?.trim().isEmpty ?? true) {
                                return "Please enter email address";
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(email ?? "")) {
                                return "Enter valid email address";
                              }
                              return null;
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              FocusNode? focusNode =
                                  FocusManager.instance.primaryFocus;
                              if (focusNode != null) {
                                if (focusNode.hasPrimaryFocus) {
                                  focusNode.unfocus();
                                }
                              }
                              setState(() {
                                onSubmitTap = true;
                                bool isValidState =
                                    _formKey.currentState?.validate() ??
                                        false;
                                if (isValidState) {
                                  forgotPasswordController.forgotPassword(
                                      context);
                                 /* ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text(
                                      'Reset password link has been sent to your email',
                                      style: TextStyle(color: AppColor.white),
                                    ),
                                  ));*/
                                  // context.loaderOverlay.show();
                                  // contactUsController.contactUs(context);
                                  // Get.toNamed("/Login");
                                }
                                // Get.toNamed("/HomeWithSignUp");
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 50, bottom: 10),
                              height: 45,
                              decoration: BoxDecoration(
                                  color: AppColor.primarycolor,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Center(
                                child: Text('Submit',
                                    style: TextStyle(
                                        color: AppColor.black,
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
                  ),
                ),
                // GlobalData().spotlightListing.isNotEmpty
                //     ? BottomViewWidget(
                //         data: GlobalData().spotlightListing[randomNumber])
                //     : Container()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
