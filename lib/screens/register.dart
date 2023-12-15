import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/controllers/filterController.dart';
import 'package:luxury_council/controllers/loginController.dart';
import 'package:luxury_council/controllers/registerController.dart';
import 'package:luxury_council/social_login.dart';
import 'package:luxury_council/widgets/edittext.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:toast/toast.dart';

import '../controllers/companylistController.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FilterController filterController = Get.put(FilterController());
  RegisterController registerController = Get.put(RegisterController());
  final LoginController loginController = Get.put(LoginController());
  TextEditingController nameCtr = TextEditingController();
  TextEditingController emailCtr = TextEditingController();
  TextEditingController companyCtr = TextEditingController();
  TextEditingController titleCtr = TextEditingController();
  TextEditingController phoneCtr = TextEditingController();
  TextEditingController addressCtr = TextEditingController();
  TextEditingController assistantnameCtr = TextEditingController();
  TextEditingController assistantemailCtr = TextEditingController();
  TextEditingController assistantphoneCtr = TextEditingController();
  final CompanylistController companyController =
      Get.put(CompanylistController());

  bool _obsecureText = true;
  bool _obsecureTextMobile = false;
  bool validate = false;
  bool onSubmitTap = false;
  final _firebaseMessaging = FirebaseMessaging.instance;
  bool checkChildrenName = false;
  String firebaseToken = '';
  UserObject? user = null;

  void _toggleObscured() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  void _toggleObscured2() {
    setState(() {
      _obsecureTextMobile = !_obsecureTextMobile;
    });
  }

  FocusNode focusNode = FocusNode();

  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String interests = '';

  @override
  void initState() {
    checkFirst();
    _firebaseMessaging.getToken().then((value) {
      setState(() {
        firebaseToken = value ?? '';
        print('firebaseToken:: $firebaseToken');
      });
    });
    super.initState();
    filterController.getIntersetList(context, null, 0, 100);
  }

  checkFirst() async {
    await companyController.getCompanyListWithoutPagination(context);
  }

  @override
  Widget build(BuildContext context) {
    print('registe code>>${registerController.assistantCountryCode}');
    return GetBuilder<RegisterController>(
        id: 'register',
        init: RegisterController(),
        builder: (register) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: AppColor.loginappbar.withOpacity(0.99),
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              leading: Container(
                margin: EdgeInsets.only(left: 8),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Image.asset(
                    "assets/back.png",
                    scale: 2.9,
                  ),
                ),
              ),
              title: Text(
                'REGISTER',
                style: TextStyle(
                    color: AppColor.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              actions: [
                Container(
                  margin: EdgeInsets.only(right: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/logo-img.png",
                      scale: 2.9,
                    ),
                  ),
                ),
              ],
              backgroundColor: Colors.black.withOpacity(0.7),
              centerTitle: true,
              bottomOpacity: 1.0,
              elevation: 4,
            ),
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
                    child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 45,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 0),
                          padding: EdgeInsets.only(
                              top: 15, right: 30, left: 30, bottom: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColor.white.withOpacity(0.05)),
                          child: Column(
                            children: [
                              // name
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                    child: Text(
                                  "First Name*",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                )),
                              ),
                              EditText(
                                hint: "First Name",
                                controller:
                                    registerController.firstnameController,
                                inputformtters: [
                                  LengthLimitingTextInputFormatter(20),
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
                                validator: (name) {
                                  if (name == null || name.isEmpty) {
                                    return 'Please enter first name';
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
                                  "Last Name*",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                )),
                              ),
                              EditText(
                                hint: "Last Name",
                                controller:
                                    registerController.lastnameController,
                                inputformtters: [
                                  LengthLimitingTextInputFormatter(20),
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
                                validator: (name) {
                                  if (name == null || name.isEmpty) {
                                    return 'Please enter last name';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              //email
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
                                controller: registerController.emailController,
                                inputformtters: [
                                  LengthLimitingTextInputFormatter(254),
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
                              //password
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                    child: Text(
                                  "Password*",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                )),
                              ),
                              EditText(
                                controller:
                                    registerController.passwordController,
                                hint: "Enter Your Password",
                                obsecureText: _obsecureText,
                                textInputType: TextInputType.visiblePassword,
                                //maxLength: 6,
                                inputformtters: [
                                  FilteringTextInputFormatter.deny(' '),
                                  LengthLimitingTextInputFormatter(20)
                                ],
                                validator: (value) {
                                  /*RegExp regex = RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');*/
                                  RegExp regex = RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,20}$');

                                  if (value!.isEmpty) {
                                    return "Please enter password";
                                  } else if (value!.length < 8) {
                                    print('password length is less than 8');
                                    return "Please enter atleast 8 character password";
                                  } else {
                                    if (!regex.hasMatch(value)) {
                                      return ("Password should contain upper,lower,digit and\nSpecial character ");
                                    } else {
                                      return null;
                                    }
                                  }
                                  //return null;
                                },
                                suffixIcon: GestureDetector(
                                  onTap: _toggleObscured,
                                  child: Transform.scale(
                                    scale: 0.5,
                                    child: ImageIcon(
                                      _obsecureText
                                          ? AssetImage(
                                              "assets/hide.png",
                                            )
                                          : AssetImage(
                                              "assets/view.png",
                                            ),
                                      color: AppColor.white,
                                      size: 12,
                                      // color: AppColors.button_color,
                                    ),
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
                                  "Confirm Password*",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                )),
                              ),
                              EditText(
                                hint: "Enter Your Password",
                                obsecureText: _obsecureText,
                                textInputType: TextInputType.visiblePassword,
                                //maxLength: 6,
                                inputformtters: [
                                  FilteringTextInputFormatter.deny(' '),
                                  LengthLimitingTextInputFormatter(20)
                                ],
                                validator: (value) {
                                  RegExp regex = RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,20}$');

                                  if (value!.isEmpty) {
                                    return "Please enter confirm password";
                                  } else if (value!.length < 8) {
                                    print('password length is less than 8');
                                    return "Please enter atleast 8 character password";
                                  } else if (value !=
                                      registerController
                                          .passwordController.text) {
                                    return "Password and confirmation password not match.";
                                  } else {
                                    if (!regex.hasMatch(value)) {
                                      return ("Password should contain upper,lower,digit and Special character ");
                                    } else {
                                      return null;
                                    }
                                  }
                                  //return null;
                                },
                                suffixIcon: GestureDetector(
                                  onTap: _toggleObscured,
                                  child: Transform.scale(
                                    scale: 0.5,
                                    child: ImageIcon(
                                      _obsecureText
                                          ? AssetImage(
                                              "assets/hide.png",
                                            )
                                          : AssetImage(
                                              "assets/view.png",
                                            ),
                                      color: AppColor.white,
                                      size: 12,
                                      // color: AppColors.button_color,
                                    ),
                                  ),
                                ),
                              ),
                              // SizedBox(
                              //   height: 25,
                              // ),
                              // //confirm password
                              // Align(
                              //   alignment: Alignment.topLeft,
                              //   child: Container(
                              //       child: Text(
                              //     "Confirm Password",
                              //     style: TextStyle(
                              //       color: AppColor.white,
                              //       fontSize: 16,
                              //     ),
                              //     textAlign: TextAlign.start,
                              //   )),
                              // ),
                              // EditText(
                              //   controller: _confirmPass,
                              //   hint: "Enter Your Confirm Password",
                              //   obsecureText: _obsecureText,
                              //   textInputType: TextInputType.visiblePassword,
                              //   inputformtters: [
                              //     FilteringTextInputFormatter.deny(' '),
                              //     LengthLimitingTextInputFormatter(6)
                              //   ],
                              //   validator: (confirmpassword) {
                              //     if (confirmpassword!.isEmpty)
                              //       return 'Please enter your confirm password';
                              //     if (confirmpassword != _pass.text)
                              //       return 'Password Not Match';
                              //     return null;
                              //   },
                              //   suffixIcon: GestureDetector(
                              //     onTap: _toggleObscured,
                              //     child: Transform.scale(
                              //       scale: 0.5,
                              //       child: ImageIcon(
                              //         _obsecureText
                              //             ? AssetImage(
                              //                 "assets/hide.png",
                              //               )
                              //             : AssetImage(
                              //                 "assets/view.png",
                              //               ),
                              //         color: AppColor.white,
                              //         size: 12,
                              //         // color: AppColors.button_color,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              SizedBox(
                                height: 25,
                              ),
                              //company
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                    child: Text(
                                  "Company*",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                )),
                              ),
                              Autocomplete(
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<String>.empty();
                                  } else {
                                    List<String> matches = <String>[];
                                    matches.addAll(
                                        companyController.companyListing.value);

                                    matches.retainWhere((s) {
                                      return s.toLowerCase().contains(
                                          textEditingValue.text.toLowerCase());
                                    });
                                    return matches;
                                  }
                                },
                                onSelected: (String selection) {
                                  registerController.companyontroller.text =
                                      selection;
                                  print('You just selected $selection');
                                },
                                fieldViewBuilder: (BuildContext context,
                                    TextEditingController textEditingController,
                                    FocusNode focusNode,
                                    VoidCallback onFieldSubmitted) {
                                  return TextFormField(
                                    onChanged: (String value) {
                                      registerController.companyontroller.text =
                                          value;
                                    },
                                    decoration: InputDecoration(
                                      errorStyle: Theme.of(context)
                                          .textTheme
                                          .caption
                                          ?.copyWith(color: Colors.red),
                                      helperStyle:
                                          Theme.of(context).textTheme.subtitle1,
                                      hintStyle:
                                          TextStyle(color: AppColor.lightgrey),
                                      hintText: 'Enter your company name',
                                      // filled: true,
                                      contentPadding: EdgeInsets.only(
                                          left: 0, top: 10, right: 0),
                                    ),
                                    style: TextStyle(
                                      color: AppColor.white,
                                      fontSize: 14,
                                    ),
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(60),
                                      FilteringTextInputFormatter.deny("[]"),
                                      FilteringTextInputFormatter.deny("["),
                                      FilteringTextInputFormatter.deny("]"),
                                      FilteringTextInputFormatter.deny("^"),
                                      FilteringTextInputFormatter.deny("`"),
                                      FilteringTextInputFormatter.deny("/"),
                                      // FilteringTextInputFormatter.deny("\"),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9a-zA-z._@ ]')),
                                      FilteringTextInputFormatter.deny(
                                          RegExp(r"/"))
                                    ],
                                    validator: (companyname) {
                                      if (companyname == null ||
                                          companyname.isEmpty) {
                                        return 'Please enter company name';
                                      }
                                      return null;
                                    },
                                  );
                                },
                              ),
                              /* EditText(
                          hint: "Enter Your Company Name",
                          controller: registerController.companyontroller,
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
                          validator: (companyname) {
                            if (companyname == null || companyname.isEmpty) {
                              return 'Please enter company name';
                            }
                            return null;
                          },
                        ),*/
                              SizedBox(
                                height: 25,
                              ),
                              //title
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                    child: Text(
                                  "Title*",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                )),
                              ),
                              EditText(
                                hint: "ex: CEO (It should be Master)",
                                controller: registerController.titleController,
                                inputformtters: [
                                 // FilteringTextInputFormatter.deny(' '),
                                  LengthLimitingTextInputFormatter(60)
                                ],
                                validator: (value) {
                                  if (value?.trim().isEmpty ?? true) {
                                    return "Please enter title";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              //phone
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
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller:
                                    registerController.phonenoController,
                                style: TextStyle(
                                    fontSize: 14, color: AppColor.white),
                                cursorColor: AppColor.cursorcolor,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                decoration: InputDecoration(
                                  hintStyle:
                                      TextStyle(color: AppColor.lightgrey),
                                  hintText: 'Enter your number',
                                ),
                                onCountryChanged: (value) {
                                  print("contactCountryCode ${value.code}");
                                  register.contactCountryCode = "${value.code}";
                                  register.updateScreen('register');
                                },
                                onChanged: (value) {
                                  if (value.number.length < 10 &&
                                      value.number.length > 10) {
                                    // Run anything here
                                  }
                                },
                                focusNode: focusNode,
                                validator: (phonenum) {
                                  if (phonenum == null) {
                                    return 'Please enter phone number';
                                  }
                                  return null;
                                },
                                disableLengthCheck: true,
                                dropdownTextStyle:
                                    TextStyle(color: AppColor.white),
                                initialCountryCode: register.contactCountryCode,
                                dropdownIconPosition: IconPosition.trailing,
                                dropdownIcon: Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColor.white,
                                ),
                                showCountryFlag: false,
                              ),
                              Visibility(
                                visible: registerController
                                        .phonenoController.text.isEmpty &&
                                    onSubmitTap,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 7),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Please enter phone number',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 12.5),
                                    ),
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
                                  "Business interest",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                )),
                              ),

                              Obx(
                                () => filterController.interestList.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          _showInterestSelect(context);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10),
                                          height: 40,
                                          // width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color:
                                                      AppColor.primarycolor)),
                                          child: Center(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Obx(
                                                () => Expanded(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5,
                                                            vertical: 5),
                                                    child: Text(
                                                      filterController
                                                              .selectedIntersetValuesToDisplay
                                                              .value
                                                              .isEmpty
                                                          ? "Interest"
                                                          : filterController
                                                              .selectedIntersetValuesToDisplay
                                                              .value,
                                                      // softWrap: true,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: filterController
                                                                  .selectedIntersetValuesToDisplay
                                                                  .value
                                                                  .isEmpty
                                                              ? AppColor
                                                                  .lightgrey
                                                              : AppColor.white,
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Image.asset(
                                                'assets/dropdown.png',
                                                scale: 2.3,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              )
                                            ],
                                          )),
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                        "No data found",
                                        style: TextStyle(color: AppColor.white),
                                      )),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              //address
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                    child: Text(
                                  "Mailing Address*",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                )),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                controller:
                                    registerController.mailingaddressController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                maxLines: 5,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(200),
                                  /*  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9a-zA-z._@]')),
                                  FilteringTextInputFormatter.deny(RegExp(r"/"))*/
                                ],
                                validator: (name) {
                                  if (name == null || name.isEmpty) {
                                    return 'Please enter mailing address';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.multiline,
                                style: TextStyle(color: AppColor.white),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(8),
                                    hintText: 'Type here...',
                                    hintStyle:
                                        TextStyle(color: AppColor.lightgrey),
                                    border: OutlineInputBorder()),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              //assistant name (optional)
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                    child: Text(
                                  "Assistant name (optional)",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                )),
                              ),
                              EditText(
                                hint: "Enter Assistant Name",
                                controller:
                                    registerController.assistantnameController,
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
                                  /*  FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9a-zA-z._@]')),*/
                                  FilteringTextInputFormatter.deny(RegExp(r"/"))
                                ],
                                // validator: (assistant) {
                                //     if (assistant == null || assistant.isEmpty) {
                                //       return 'Please enter assistant name';
                                //     }
                                //     return null;
                                //   },
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              //assistant email
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                    child: Text(
                                  "Assistant email*",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                )),
                              ),
                              EditText(
                                hint: "Enter Assistant Email",
                                controller:
                                    registerController.assistantemailController,
                                inputformtters: [
                                  LengthLimitingTextInputFormatter(254),
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
                                validator: (value) {
                                  if (value?.trim().isEmpty ?? true) {
                                    return "Please enter assistant email";
                                  } else if (!RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value ?? "")) {
                                    return "Enter valid assistant email";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              //assistant phone
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                    child: Text(
                                  "Assistant phone*",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                )),
                              ),
                              IntlPhoneField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: registerController
                                    .assistantphonenoController,
                                style: TextStyle(
                                    fontSize: 14, color: AppColor.white),
                                cursorColor: AppColor.cursorcolor,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                decoration: InputDecoration(
                                  hintStyle:
                                      TextStyle(color: AppColor.lightgrey),
                                  hintText: 'Enter your Assistant number',
                                ),
                                validator: (asistantnum) {
                                  if (asistantnum == null) {
                                    return 'Please enter assistant number';
                                  }
                                  return null;
                                },
                                disableLengthCheck: true,
                                dropdownTextStyle:
                                    TextStyle(color: AppColor.white),
                                initialCountryCode:
                                    register.assistantCountryCode,
                                dropdownIconPosition: IconPosition.trailing,
                                dropdownIcon: Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColor.white,
                                ),
                                onCountryChanged: (value) {
                                  print("assistantCountryCode ${value.code}");
                                  register.assistantCountryCode =
                                      "${value.code}";
                                  register.updateScreen('register');
                                },
                                onChanged: (phone) {
                                  print(phone.completeNumber);
                                },
                                showCountryFlag: false,
                              ),
                              Visibility(
                                visible: registerController
                                        .assistantphonenoController
                                        .text
                                        .isEmpty &&
                                    onSubmitTap,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 7),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Please enter assistant number',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 12.5),
                                    ),
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
                                  "Birthday",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                )),
                              ),
                              EditText(
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      lastDate: DateTime(2100));

                                  if (pickedDate != null) {
                                    print(pickedDate);
                                    String formattedDate =
                                        DateFormat('dd/MM/yyyy')
                                            .format(pickedDate);
                                    print(formattedDate);
                                    setState(() {
                                      registerController.birthDateCtr.text =
                                          formattedDate;
                                    });
                                  } else {}
                                },
                                hint: "birth date",
                                controller: registerController.birthDateCtr,
                                readOnly: true,
                                // validator: (date) {
                                //   if (date == null || date.isEmpty) {
                                //     return 'Please select birth date';
                                //   }
                                //   return null;
                                // },
                              ),

                              SizedBox(
                                height: 25,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                    child: Text(
                                  "Spouse Name",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                )),
                              ),
                              EditText(
                                hint: "Spouse Name",
                                controller: registerController.spouceNameCtr,
                                inputformtters: [
                                  LengthLimitingTextInputFormatter(60),
                                  FilteringTextInputFormatter.deny("[]"),
                                  FilteringTextInputFormatter.deny("["),
                                  FilteringTextInputFormatter.deny("]"),
                                  FilteringTextInputFormatter.deny("^"),
                                  FilteringTextInputFormatter.deny(""),
                                  FilteringTextInputFormatter.deny("`"),
                                  FilteringTextInputFormatter.deny("/"),
                                  // FilteringTextInputFormatter.deny("\"),
                                  /*FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9a-zA-z._@]')),*/
                                  FilteringTextInputFormatter.deny(RegExp(r"/"))
                                ],
                                // validator: (name) {
                                //   if (name == null || name.isEmpty) {
                                //     return 'Please enter spouce name';
                                //   }
                                //   return null;
                                // },
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                    child: Text(
                                  "Spouse Birthday",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                )),
                              ),
                              EditText(
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      lastDate: DateTime(2100));

                                  if (pickedDate != null) {
                                    print(pickedDate);
                                    String formattedDate =
                                        DateFormat('dd/MM/yyyy')
                                            .format(pickedDate);
                                    print(formattedDate);
                                    setState(() {
                                      registerController.spoucebirthDateCtr
                                          .text = formattedDate;
                                    });
                                  } else {}
                                },

                                hint: "spouse birth date",
                                controller:
                                    registerController.spoucebirthDateCtr,
                                readOnly: true,
                                // validator: (date) {
                                //   if (date == null || date.isEmpty) {
                                //     return 'Please select spouce birth date';
                                //   }
                                //   return null;
                                // },
                              ),
                              SizedBox(
                                height: 25,
                              ),

                              Obx(
                                () => ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        registerController.childrenname.length,
                                    itemBuilder: (context, index) => Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                    child: Text(
                                                  "Children Name",
                                                  style: TextStyle(
                                                    color: AppColor.white,
                                                    fontSize: 16,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                )),
                                              ),
                                              EditText(
                                                hint: "Children Name",
                                                controller: registerController
                                                    .childrenname[index],
                                                inputformtters: [
                                                  LengthLimitingTextInputFormatter(
                                                      60),
                                                  /*    FilteringTextInputFormatter.deny(
                                                " "),*/
                                                  FilteringTextInputFormatter
                                                      .deny("[]"),
                                                  FilteringTextInputFormatter
                                                      .deny("["),
                                                  FilteringTextInputFormatter
                                                      .deny("]"),
                                                  FilteringTextInputFormatter
                                                      .deny("^"),
                                                  FilteringTextInputFormatter
                                                      .deny(""),
                                                  FilteringTextInputFormatter
                                                      .deny("`"),
                                                  FilteringTextInputFormatter
                                                      .deny("/"),
                                                  // FilteringTextInputFormatter.deny("\"),
                                                  /* FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9a-zA-z._@]')),*/
                                                  FilteringTextInputFormatter
                                                      .deny(RegExp(r"/"))
                                                ],
                                                // validator: (name) {
                                                //   if (name == null || name.isEmpty) {
                                                //     return 'Please enter children name';
                                                //   }
                                                //   return null;
                                                // },
                                              ),
                                              SizedBox(
                                                height: 25,
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                    child: Text(
                                                  "Children Birthday",
                                                  style: TextStyle(
                                                    color: AppColor.white,
                                                    fontSize: 16,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                )),
                                              ),
                                              EditText(
                                                onTap: () async {
                                                  DateTime? pickedDate =
                                                      await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(1950),
                                                    lastDate: DateTime(2100),
                                                  );

                                                  if (pickedDate != null) {
                                                    print(
                                                        'pickedDate>>> $pickedDate >>> ${DateFormat('yyyy-MM-dd').format(pickedDate)}');
                                                    String formattedDate =
                                                        DateFormat('dd/MM/yyyy')
                                                            .format(pickedDate);
                                                    print(formattedDate);
                                                    setState(() {
                                                      registerController
                                                          .childrendate[index]
                                                          .text = formattedDate;
                                                    });
                                                  } else {}
                                                },
                                                hint: "children birth date",
                                                controller: registerController
                                                    .childrendate[index],
                                                readOnly: true,
                                                // validator: (date) {
                                                //   if (date == null || date.isEmpty) {
                                                //     return 'Please select children birth date';
                                                //   }
                                                //   return null;
                                                // },
                                              ),
                                            ],
                                          ),
                                        )),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    if (registerController
                                                .childrenname[registerController
                                                        .childrenname.length -
                                                    1]
                                                .text
                                                .trim() !=
                                            '' &&
                                        registerController
                                                .childrendate[registerController
                                                        .childrendate.length -
                                                    1]
                                                .text
                                                .trim() !=
                                            '') {
                                      registerController.childrenname
                                          .add(TextEditingController());
                                      registerController.childrendate
                                          .add(TextEditingController());
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Please enter children name and children birthday"),
                                      ));
                                    }
                                  },
                                  child: Text(
                                    'Add more children',
                                    style:
                                        TextStyle(color: AppColor.primarycolor),
                                  )),

                              SizedBox(
                                height: 60,
                              ),

                              GestureDetector(
                                onTap: () async {
                                  FocusNode? focusNode =
                                      FocusManager.instance.primaryFocus;
                                  if (focusNode != null) {
                                    if (focusNode.hasPrimaryFocus) {
                                      focusNode.unfocus();
                                    }
                                  }
                                  await checkChildrenEntries();
                                  setState(() {
                                    onSubmitTap = true;
                                    bool isValidState =
                                        _formKey.currentState?.validate() ??
                                            false;
                                    if (isValidState &&
                                        registerController.phonenoController
                                            .text.isNotEmpty &&
                                        registerController
                                            .assistantphonenoController
                                            .text
                                            .isNotEmpty) {

                                      if (registerController
                                              .spoucebirthDateCtr.text !=
                                          '') {
                                        if (registerController
                                                .spouceNameCtr.text !=
                                            '' ) {
                                          if(registerController
                                              .childrendate[0].text ==
                                              ''){
                                            setState(() {
                                              checkChildrenName = true;
                                            });
                                          }else{
                                            if (registerController
                                                .childrendate[0].text !=
                                                '') {
                                              print(
                                                  '>>>>>>>>> ${registerController.childrendate[0].text}');
                                              for (int i = 0;
                                              i <
                                                  registerController
                                                      .childrendate.length;
                                              i++) {
                                                print(
                                                    '>>>>>>>>> ${registerController.childrenname[i]}');
                                                if (registerController
                                                    .childrenname[i].text !=
                                                    '') {
                                                  setState(() {
                                                    checkChildrenName = true;
                                                  });
                                                } else {
                                                  setState(() {
                                                    checkChildrenName = false;
                                                  });
                                                  break;
                                                }
                                              }
                                              if (checkChildrenName == false) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Please enter children name first!!"),
                                                ));
                                              }
                                            }
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "Please enter spouse name first!!"),
                                          ));
                                          setState(() {
                                            checkChildrenName = false;
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          checkChildrenName = true;
                                        });
                                      }
                                      print('check >> $checkChildrenName');
                                      if (checkChildrenName == true) {
                                        setState(() {
                                          if (registerController
                                                  .onBtnClick.value ==
                                              false) {
                                            registerController.Register(
                                                context, interests);
                                          }
                                        });
                                      }
                                    }
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: AppColor.primarycolor,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                    child: Text('Register',
                                        style: Theme.of(context)
                                            .textTheme
                                            .button
                                            ?.copyWith(
                                                color: AppColor.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 35,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an Account? ",
                                    style: TextStyle(
                                        color: AppColor.white, fontSize: 12),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.offAndToNamed("/Login");
                                    },
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                          color: AppColor.primarycolor,
                                          fontSize: 12,
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              AppColor.primarycolor,
                                          decorationThickness: 2),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Container(
                                      child: Text(
                                    "or",
                                    style: TextStyle(
                                        color: AppColor.white, fontSize: 12),
                                  )),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Container(
                                      child: Text(
                                    "Login With",
                                    style: TextStyle(
                                        color: AppColor.white, fontSize: 12),
                                  )),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      SocialLogin().googleLogin(context,
                                          callBack: (User? user) {
                                        print('userGoogle::${user}');
                                        if (user != null) {
                                          context.loaderOverlay.show();
                                          loginController.login(context,
                                              firebaseToken, 'social_login',
                                              socialType: 'google', user: user);
                                        }
                                      });
                                    },
                                    child: Image.asset(
                                      "assets/google.png",
                                      scale: 2.5,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),

                                  GestureDetector(
                                    onTap: () {
                                      SocialLogin().initiateFacebookLogin(
                                          callBack: (FacebookUserProfile?
                                                  facebookData,
                                              String? email) {
                                        if (facebookData != null) {
                                          Future.delayed(
                                              Duration(milliseconds: 0),
                                              () async {
                                            context.loaderOverlay.show();
                                            loginController.login(context,
                                                firebaseToken, 'social_login',
                                                facebookData: facebookData,
                                                socialType: 'facebook',
                                                facebookEmail: email);
                                          });
                                        }
                                      });
                                    },
                                    child: Image.asset(
                                      "assets/facebook.png",
                                      scale: 2.5,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  // _setLinkedin()
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder:
                                              (final BuildContext context) =>
                                                  LinkedInUserWidget(
                                            appBar: AppBar(
                                              title: const Text('OAuth User'),
                                            ),
                                            // destroySession: logoutUser,
                                            redirectUrl: redirectUrl,
                                            clientId: clientId,
                                            clientSecret: clientSecret,
                                            projection: const [
                                              // ProjectionParameters.id,
                                              ProjectionParameters
                                                  .localizedFirstName,
                                              ProjectionParameters
                                                  .localizedLastName,
                                              ProjectionParameters.firstName,
                                              ProjectionParameters.lastName,
                                              ProjectionParameters
                                                  .profilePicture,
                                            ],
                                            scope: const [
                                              EmailScope(),
                                              OpenIdScope(),
                                              ProfileScope(),
                                            ],
                                            onError:
                                                (final UserFailedAction e) {
                                              print(
                                                  '___________________________________ Error: ${e.toString()}');
                                              print(
                                                  '_____________________________________Error: ${e.stackTrace.toString()}');
                                            },
                                            onGetUserProfile:
                                                (final UserSucceededAction
                                                    linkedInUser) {
                                              print(
                                                'Access token ${linkedInUser.user.token.accessToken}',
                                              );

                                              print(
                                                  'User id: ${linkedInUser.user.userId}');

                                              user = UserObject(
                                                firstName: linkedInUser
                                                    .user
                                                    .firstName
                                                    ?.localized
                                                    ?.label,
                                                lastName: linkedInUser.user
                                                    .lastName?.localized?.label,
                                                email: linkedInUser
                                                    .user.email?.elements
                                                    ?.elementAt(0)
                                                    .handleDeep
                                                    ?.emailAddress,
                                                profileImageUrl: linkedInUser
                                                    .user
                                                    .profilePicture
                                                    ?.displayImageContent
                                                    ?.elements
                                                    ?.elementAt(0)
                                                    .identifiers
                                                    ?.elementAt(0)
                                                    .identifier,
                                              );

                                              setState(() {
                                                // logoutUser = false;
                                              });

                                              Navigator.pop(context);
                                            },
                                          ),
                                          fullscreenDialog: true,
                                        ),
                                      );
                                    },
                                    child: Image.asset(
                                      "assets/linkedin.png",
                                      scale: 12.1,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          );
        });
  }

  checkChildrenEntries() {
    if (registerController.childrendate.length >
        registerController.childrenname.length) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please enter children name first!!"),
      ));
    }
  }

  void showToast(String msg, {int? duration, int? gravity}) {
    Toast.show('msg', duration: duration, gravity: gravity);
  }

  void _showInterestSelect(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return Container(
          margin: EdgeInsets.only(right: 40, top: 130, bottom: 15),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          alignment: Alignment.topRight,
          child: MultiSelectDialog(
            title: Text(''),
            backgroundColor: AppColor.black,
            //separateSelectedItems: true,
            checkColor: AppColor.black,
            selectedColor: AppColor.primarycolor,
            unselectedColor: AppColor.primarycolor,
            itemsTextStyle: TextStyle(color: AppColor.white),
            selectedItemsTextStyle: TextStyle(color: AppColor.primarycolor),
            items: filterController.IntersetTextList.map(
                (element) => MultiSelectItem(element, element)).toList(),
            initialValue: filterController.IntersetSelectedServices.value,
            onConfirm: (values) {
              filterController.IntersetSelectedServices.value = values;
              filterController.selectedIntersetValuesToDisplay.value = "";
              values.forEach((element) {
                // print("selected interest : ${element['interestName']}");
                filterController.selectedIntersetValuesToDisplay.value +=
                    element + ", ";
              });
              if (filterController
                  .selectedIntersetValuesToDisplay.value.isNotEmpty) {
                print('checkjdfjdfj');
                filterController.selectedIntersetValuesToDisplay.value =
                    filterController.selectedIntersetValuesToDisplay.value
                        .replaceRange(
                  filterController
                          .selectedIntersetValuesToDisplay.value.length -
                      2,
                  filterController.selectedIntersetValuesToDisplay.value.length,
                  "",
                );

                List<String> ids = [];
                filterController.interestList.forEach((element) {
                  filterController.IntersetSelectedServices.forEach(
                      (ownerJobType) {
                    if (ownerJobType == element.interestName) {
                      ids.add(element.interestId.toString());
                    }
                  });
                });
                setState(() {
                  interests = ids.join(',');
                  print('object >>>>>> $interests');
                });
                filterController.selectedIntersetValuesToDisplay.value;
                // homeController.getArticleList(
                //   context,
                //   0,
                //   10,
                //   searchController.text.toString(),
                //   categorys,
                //   mediatypes,
                //   interests,
                // );
                print(
                    'object${filterController.IntersetSelectedServices.value}');
              } else {
                setState(() {
                  interests = '';
                });
                filterController.selectedIntersetValuesToDisplay.value;
                // homeController.getArticleList(
                //   context,
                //   0,
                //   10,
                //   searchController.text.toString(),
                //   categorys,
                //   mediatypes,
                //   interests,
                // );
                print(
                    'object${filterController.IntersetSelectedServices.value}');
              }
            },
          ),
        );
      },
    );
  }
}

class UserObject {
  UserObject({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileImageUrl,
  });

  final String? firstName;
  final String? lastName;
  final String? email;
  final String? profileImageUrl;
}

class LinkedProfileScope extends Scope {
  const LinkedProfileScope() : super('r_basicprofile');
}

class OpenIdScope extends Scope {
  const OpenIdScope() : super('openid');
}

class ProfileScope extends Scope {
  const ProfileScope() : super('profile');
}

class EmailScope extends Scope {
  const EmailScope() : super('email');
}
