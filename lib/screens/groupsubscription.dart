
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/controllers/group_subscription_controller.dart';
import 'package:luxury_council/widgets/edittext.dart';
import 'package:intl/intl.dart';

import '../constance/global_data.dart';
import '../widgets/appbars.dart';
import 'bottom_view_widget.dart';

class GroupSubscription extends StatefulWidget {
  const GroupSubscription({super.key});

  @override
  State<GroupSubscription> createState() => _GroupSubscriptionState();
}

class _GroupSubscriptionState extends State<GroupSubscription> {
  final GroupSubscriptionController groupSubscriptionController = Get.put(GroupSubscriptionController());
  TextEditingController companynameCtr = TextEditingController();
  TextEditingController contactnameCtr = TextEditingController();
  TextEditingController titleCtr = TextEditingController();
  TextEditingController emailCtr = TextEditingController();
  TextEditingController phoneCtr = TextEditingController();
  List<String> typeList = ['Monthly', 'Yearly',];
  String? selectedValue ;
  bool onSubmitTap = false;
  int randomNumber = 0;



  final _formKey = GlobalKey<FormState>();
int subscriptionid = GlobalData().subscriptionId;
  @override
  void initState() {
    Random random = new Random();
    randomNumber = random.nextInt(GlobalData().spotlightListing.length);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      backgroundColor: AppColor.grey,
      appBar: AppBarDetails(appBar: AppBar(), text: 'GROUP SUBSCRIPTION', isNotSubscription: subscriptionid==0||subscriptionid==1||subscriptionid==2||subscriptionid==6,screenName: '/GroupSubscription'),
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
      //     'Group Subscription',
      //     style: TextStyle(
      //         color: AppColor.white, fontWeight: FontWeight.bold, fontSize: 14),
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
      //  backgroundColor: Colors.black.withOpacity(0.7),
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
          SafeArea(
            child:Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                    margin:
                    EdgeInsets.only(left: 25, right: 25, top: 25, bottom: 10),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                              child: Text(
                                "Company Name*",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.start,
                              )),
                        ),
                        EditText(
                          hint: "Enter Your Company Name",
                          controller: groupSubscriptionController.companyNameController,
                          inputformtters: [
                            LengthLimitingTextInputFormatter(60),
                           // FilteringTextInputFormatter.deny(" "),
                            FilteringTextInputFormatter.deny("[]"),
                            FilteringTextInputFormatter.deny("["),
                            FilteringTextInputFormatter.deny("]"),
                            FilteringTextInputFormatter.deny("^"),
                            FilteringTextInputFormatter.deny(""),
                            FilteringTextInputFormatter.deny("`"),
                            FilteringTextInputFormatter.deny("/"),
                            // FilteringTextInputFormatter.deny("\"),
                           /* FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9a-zA-z._@]')),
                            FilteringTextInputFormatter.deny(RegExp(r"/"))*/
                          ],
                          validator: (companyname) {
                            if (companyname == null || companyname.isEmpty) {
                              return 'Please enter company name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                              child: Text(
                                "Contact Name*",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.start,
                              )),
                        ),
                        EditText(
                          hint: "Enter Your Contact Name",
                          controller:groupSubscriptionController.nameController,
                          inputformtters: [
                            LengthLimitingTextInputFormatter(60),
                           // FilteringTextInputFormatter.deny(" "),
                            FilteringTextInputFormatter.deny("[]"),
                            FilteringTextInputFormatter.deny("["),
                            FilteringTextInputFormatter.deny("]"),
                            FilteringTextInputFormatter.deny("^"),
                            FilteringTextInputFormatter.deny(""),
                            FilteringTextInputFormatter.deny("`"),
                            FilteringTextInputFormatter.deny("/"),
                            // FilteringTextInputFormatter.deny("\"),
                           /* FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9a-zA-z._@]')),
                            FilteringTextInputFormatter.deny(RegExp(r"/"))*/
                          ],
                          validator: (companyname) {
                            if (companyname == null || companyname.isEmpty) {
                              return 'Please enter contact name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                              child: Text(
                                "Job Title*",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.start,
                              )),
                        ),
                        EditText(
                          hint: "ex: CEO (It should be Master)",
                          controller: groupSubscriptionController.titleController,
                          inputformtters: [
                            LengthLimitingTextInputFormatter(60),
                           // FilteringTextInputFormatter.deny(" "),
                            FilteringTextInputFormatter.deny("[]"),
                            FilteringTextInputFormatter.deny("["),
                            FilteringTextInputFormatter.deny("]"),
                            FilteringTextInputFormatter.deny("^"),
                            FilteringTextInputFormatter.deny(""),
                            FilteringTextInputFormatter.deny("`"),
                            FilteringTextInputFormatter.deny("/"),
                            // FilteringTextInputFormatter.deny("\"),
                           /* FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9a-zA-z._@]')),
                            FilteringTextInputFormatter.deny(RegExp(r"/"))*/
                          ],
                          validator: (value) {
                            if (value?.trim().isEmpty ?? true) {
                              return "Please enter job title";
                            } /*else if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value ?? "")) {
                              return "Enter valid email address";
                            }*/
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                              child: Text(
                                "Email*",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.start,
                              )),
                        ),
                        EditText(
                          hint: "someone@gmail.com",
                          controller: groupSubscriptionController.emailController,
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
                            // FilteringTextInputFormatter.deny("\"),
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9a-zA-z._@]')),
                            FilteringTextInputFormatter.deny(RegExp(r"/"))
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
                        SizedBox(
                          height: 25,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                              child: Text(
                                "Phone*",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.start,
                              )),
                        ),
                        IntlPhoneField(
                           autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: groupSubscriptionController.phoneNumberController,
                          style: TextStyle(fontSize: 14, color: AppColor.white),
                          cursorColor: AppColor.cursorcolor,
                          decoration: InputDecoration(  
                            hintStyle: TextStyle(color: AppColor.lightgrey),
                            hintText: 'Enter your number',
                          ),inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          
                          validator: (phonenum) {
                            if (phonenum == null) {
                              return 'Please enter phone number';
                            }
                            return null;
                          },
                          disableLengthCheck: true,
                          dropdownTextStyle: TextStyle(color: AppColor.white),
                          initialCountryCode: 'US',
                          dropdownIconPosition: IconPosition.trailing,
                          dropdownIcon: Icon(
                            Icons.arrow_drop_down,
                            color: AppColor.white,
                          ),
                        onChanged: (value) {
                            if (value.number.length < 10 &&
                                value.number.length > 10) {
                              // Run anything here
                            }
                          },
                          onCountryChanged: (value) {
                            print("grpCountryCode ${value.code}");
                            groupSubscriptionController.grpCountryCode.value = "${value.code}";
                            //groupSubscriptionController.updateScreen('register');
                          },
                          showCountryFlag: false,
                        ),
                        Visibility(
                          visible: groupSubscriptionController.phoneNumberController.text.isEmpty && onSubmitTap,
                          child: Padding(
                            padding: EdgeInsets.only(top: 7),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Please enter phone number',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12.5
                                ),),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                              child: Text(
                                "Number of subscription*",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.start,
                              )),
                        ),
                        EditText(
                          hint: "Number of subscription",
                          controller:groupSubscriptionController.numOfSubscription,
                          textInputType: TextInputType.number,
                          inputformtters: [
                            LengthLimitingTextInputFormatter(9),
                            FilteringTextInputFormatter.deny(" "),
                            FilteringTextInputFormatter.deny("[]"),
                            FilteringTextInputFormatter.deny("["),
                            FilteringTextInputFormatter.deny("]"),
                            FilteringTextInputFormatter.deny("^"),
                            FilteringTextInputFormatter.deny(""),
                            FilteringTextInputFormatter.deny("`"),
                            FilteringTextInputFormatter.deny("/"),
                            // FilteringTextInputFormatter.deny("\"),
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9]')),
                            FilteringTextInputFormatter.deny(RegExp(r"/"))
                          ],
                          validator: (companyname) {
                            if (companyname == null || companyname.isEmpty) {
                              return 'Please enter number of subscription';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                       /* Container(
                          padding:EdgeInsets.symmetric(horizontal: 10) ,
                          decoration:  BoxDecoration(
                              border: Border.all(color: AppColor.white, width: 1)),
                          child: DropdownButton(
                              borderRadius: BorderRadius.circular(5),
                              dropdownColor: AppColor.appbar,
                              isExpanded: true,
                              underline: Container(),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColor.white,
                                size: 30,
                              ),
                              value: selectedValue,
                              style: TextStyle(color: AppColor.white),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedValue = newValue;
                                });
                              },
                              hint: Text('Subscription type',
                                style: TextStyle(
                                  color: AppColor.white,
                                ),
                              ),
                              items: typeList.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(value,)),
                                );
                              }).toList()),
                        ),
                        Visibility(
                          visible: selectedValue== null && onSubmitTap,
                          child: Padding(
                            padding: EdgeInsets.only(top: 7),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Please select subscription type',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12.5
                                ),),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                              child: Text(
                                "Subscription start date",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.start,
                              )),
                        ),
                        EditText(
                          onTap: (){
                            _pickDateDialog();
                          },
                          hint: "Subscription start date",
                          controller:groupSubscriptionController.startDate,
                          readOnly: true,
                          validator: (date) {
                            if (date == null || date.isEmpty) {
                              return 'Please select date';
                            }
                            return null;
                          },
                        )*/
                        /*Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColor.white, width: 1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text( groupSubscriptionController.numOfSubscription.isNotEmpty ? groupSubscriptionController.numOfSubscription.value:
                                'Number of subscriptions',
                                style: TextStyle(
                                  color: AppColor.white,
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (dialogContex) {
                                          return AlertDialog(
                                              backgroundColor: AppColor.darkgrey,
                                              contentPadding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              insetPadding: EdgeInsets.only(
                                                  right: 25,
                                                  left: 240,
                                                  // top: 500,
                                                  bottom: 15),
                                              alignment: Alignment.bottomRight,
                                              content: ListView.builder(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10, vertical: 6),
                                                shrinkWrap: true,
                                                itemCount: 6,
                                                  itemBuilder: (context, index){
                                                    return GestureDetector(
                                                      onTap: (){
                                                        setState(() {
                                                          groupSubscriptionController.numOfSubscription.value = index.toString();
                                                          Get.back();
                                                        });

                                                      },
                                                      child: Align(
                                                        alignment:
                                                        Alignment.centerLeft,
                                                        child: Text(
                                                          '10 - 50',
                                                          style: TextStyle(
                                                            color: AppColor.black,
                                                            fontSize: 13,
                                                          ),
                                                          textAlign:
                                                          TextAlign.start,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                              ));
                                        });
                                  },
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColor.white,
                                    size: 30,
                                  ))
                            ],
                          ),
                        ),*/
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
                              bool isValidState = _formKey.currentState?.validate() ?? false;
                              if ( isValidState &&  groupSubscriptionController.phoneNumberController.text.isNotEmpty) {
                                groupSubscriptionController.subscriptionType.value = selectedValue == 'Monthly' ? '1':'2';
                                groupSubscriptionController.groupSubscription(context);
                                context.loaderOverlay.show();
                                // Get.toNamed("/Login");
                              }
                              // Get.toNamed("/HomeWithSignUp");
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 60, bottom: 10),
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
            ),
           /* GlobalData().spotlightListing.isNotEmpty ?
            BottomViewWidget(data : GlobalData().spotlightListing[randomNumber]):
            Container()*/
          ],
          )

          ),
        ],
      ),
    );
  }

  void _pickDateDialog() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        //which date will display when user open the picker
        firstDate: DateTime.now(),
        //what will be the previous supported year in picker
        lastDate: DateTime(2050)) //what will be the up to supported date in picker
        .then((pickedDate) {
      //then usually do the future job
      if (pickedDate == null) {
        //if user tap cancel then this function will stop
        return;
      }
      setState(() {
        //for rebuilding the ui
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final String formatted = formatter.format(pickedDate);
        groupSubscriptionController.startDate.text = formatted;
      });
    });
  }
}
