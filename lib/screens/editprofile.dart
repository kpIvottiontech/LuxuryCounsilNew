import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/controllers/companylistController.dart';
import 'package:luxury_council/controllers/editprofileController.dart';
import 'package:luxury_council/widgets/edittext.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:toast/toast.dart';

import '../config/prefrance.dart';
import '../controllers/filterController.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  EditProfileController editProfileController =
      Get.put(EditProfileController());
  final FilterController filterController = Get.put(FilterController());
  final CompanylistController companyController =
      Get.put(CompanylistController());
  TextEditingController nameCtr = TextEditingController();
  TextEditingController emailCtr = TextEditingController();
  TextEditingController companyCtr = TextEditingController();
  TextEditingController titleCtr = TextEditingController();
  TextEditingController phoneCtr = TextEditingController();
  TextEditingController addressCtr = TextEditingController();
  TextEditingController assistantnameCtr = TextEditingController();
  TextEditingController assistantemailCtr = TextEditingController();
  TextEditingController assistantphoneCtr = TextEditingController();
  TextEditingController birthDateCtr = TextEditingController();
  TextEditingController spouceNameCtr = TextEditingController();
  TextEditingController spoucebirthDateCtr = TextEditingController();
  TextEditingController childrenNameCtr = TextEditingController();
  TextEditingController childrenbirthDateCtr = TextEditingController();
  String interests = '';
  bool validate = false;
  bool checkChildrenName = false;
  FocusNode focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool onSubmitTap = false;

  @override
  void initState() {
    checkFirst();
    super.initState();
  }

  checkFirst() async {
    await editProfileController.getProfileIntersetList(context, null, 0, 100);
    await editProfileController.getprofile(context);
    await companyController.getCompanyListWithoutPagination(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //filterController.profileselectedIntersetValuesToDisplay.value = '';
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(
        id: 'editProfile',
        init: EditProfileController(),
        builder: (editProfile) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
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
                'EDIT PROFILE',
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
                                controller: editProfile.firstnameController,
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
                                controller: editProfile.lastnameController,
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
                                controller: editProfile.emailController,
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
                                  editProfile.companyController.text =
                                      selection;
                                  print('You just selected $selection');
                                },
                                fieldViewBuilder: (BuildContext context,
                                    TextEditingController textEditingController,
                                    FocusNode focusNode,
                                    VoidCallback onFieldSubmitted) {
                                  print(
                                      'text here>> ${editProfile.companyController.text}');
                                  textEditingController.text =
                                      editProfile.companyController.text;
                                  return TextFormField(
                                    onChanged: (String value) {
                                      editProfile.companyController.text =
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
                                          TextStyle(color: AppColor.textlight),
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
                                controller: editProfile.titleController,
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
                                editProfile.phonenoController,
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
                                  editProfile.contactCountryCode = "${value.code}";
                                  editProfile.updateScreen('register');
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
                                initialCountryCode: editProfile.contactCountryCode,
                                dropdownIconPosition: IconPosition.trailing,
                                dropdownIcon: Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColor.white,
                                ),
                                showCountryFlag: false,
                              ),
                             /* IntlPhoneField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: editProfile.phonenoController,
                                style: TextStyle(
                                    fontSize: 14, color: AppColor.white),
                                cursorColor: AppColor.black,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                decoration: InputDecoration(
                                  hintStyle:
                                      TextStyle(color: AppColor.hintcolor),
                                  hintText: 'Enter your number',
                                ),
                                onCountryChanged: (value) {
                                  print("contactCountryCode ${value.code}");
                                  editProfile.contactCountryCode =
                                      "${value.code}";
                                  editProfile.updateScreen('editProfile');
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
                                initialCountryCode:
                                    editProfile.contactCountryCode,
                                dropdownIconPosition: IconPosition.trailing,
                                dropdownIcon: Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColor.white,
                                ),
                                // onChanged: (phone) {
                                //   print(phone.completeNumber);
                                // },
                                showCountryFlag: false,
                              ),*/
                              Visibility(
                                visible: editProfile
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
                                    editProfile.mailingaddressController,
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
                                controller: editProfile.assistantnameController,
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
                                    editProfile.assistantemailController,
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
                                controller:
                                    editProfile.assistantphonenoController,
                                style: TextStyle(
                                    fontSize: 14, color: AppColor.white),
                                cursorColor: AppColor.black,
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
                                    editProfile.assistantCountryCode,
                                dropdownIconPosition: IconPosition.trailing,
                                dropdownIcon: Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColor.white,
                                ),
                                onCountryChanged: (value) {
                                  print("assistantCountryCode ${value.code}");
                                  editProfile.assistantCountryCode =
                                      "${value.code}";
                                  editProfile.updateScreen('editProfile');
                                },
                                onChanged: (phone) {
                                  print(phone.completeNumber);
                                },
                                showCountryFlag: false,
                              ),
                              Visibility(
                                visible: editProfile
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
                                  "Business interest",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.start,
                                )),
                              ),
                              Obx(
                                () => editProfile.profileinterestList.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          _showInterestSelect(
                                              context, editProfile);
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
                                                      editProfile
                                                              .profileselectedIntersetValuesToDisplay
                                                              .value
                                                              .isEmpty
                                                          ? "Interest"
                                                          : editProfile
                                                              .profileselectedIntersetValuesToDisplay
                                                              .value,
                                                      // softWrap: true,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: AppColor.white,
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
                                    : Center(child: Text("No data found")),
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
                                      lastDate: DateTime.now());

                                  if (pickedDate != null) {
                                    print(pickedDate);
                                    String formattedDate =
                                        DateFormat('dd/MM/yyyy')
                                            .format(pickedDate);
                                    print(formattedDate);
                                    setState(() {
                                      editProfile.birthDateCtr.text =
                                          formattedDate;
                                    });
                                  } else {}
                                },
                                hint: "birth date",
                                controller: editProfile.birthDateCtr,
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
                                controller: editProfile.spouceNameCtr,
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
                                      lastDate: DateTime.now());

                                  if (pickedDate != null) {
                                    print(pickedDate);
                                    String formattedDate =
                                        DateFormat('dd/MM/yyyy')
                                            .format(pickedDate);
                                    print(formattedDate);
                                    setState(() {
                                      editProfile.spoucebirthDateCtr.text =
                                          formattedDate;
                                    });
                                  } else {}
                                },

                                hint: "spouse birth date",
                                controller: editProfile.spoucebirthDateCtr,
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
                                    itemCount: editProfile.childrenname.length,
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
                                                controller: editProfile
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
                                                    lastDate: DateTime.now(),
                                                  );

                                                  if (pickedDate != null) {
                                                    print(pickedDate);
                                                    String formattedDate =
                                                        DateFormat('dd/MM/yyyy')
                                                            .format(pickedDate);
                                                    print(formattedDate);
                                                    setState(() {
                                                      editProfile
                                                          .childrendate[index]
                                                          .text = formattedDate;
                                                    });
                                                  } else {}
                                                },
                                                hint: "children birth date",
                                                controller: editProfile
                                                    .childrendate[index],
                                                readOnly: true,
                                                // validator: (date) {
                                                //   if (date == null || date.isEmpty) {
                                                //     return 'Please select children birth date';
                                                //   }
                                                //   return null;
                                                // },
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Visibility(
                                                visible: editProfile
                                                        .childrenname.length >
                                                    1,
                                                child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        editProfile.childrenname
                                                            .removeAt(index);
                                                        editProfile.childrendate
                                                            .removeAt(index);
                                                      });
                                                    },
                                                    child: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          color: AppColor
                                                              .primarycolor),
                                                    )),
                                              )
                                            ],
                                          ),
                                        )),
                              ),
                              // EditText(
                              //   hint: "Children Name",
                              //   controller: childrenNameCtr,
                              //   inputformtters: [
                              //     LengthLimitingTextInputFormatter(60),
                              //     FilteringTextInputFormatter.deny(" "),
                              //     FilteringTextInputFormatter.deny("[]"),
                              //     FilteringTextInputFormatter.deny("["),
                              //     FilteringTextInputFormatter.deny("]"),
                              //     FilteringTextInputFormatter.deny("^"),
                              //     FilteringTextInputFormatter.deny(""),
                              //     FilteringTextInputFormatter.deny("`"),
                              //     FilteringTextInputFormatter.deny("/"),
                              //     // FilteringTextInputFormatter.deny("\"),
                              //     FilteringTextInputFormatter.allow(
                              //         RegExp(r'[0-9a-zA-z._@]')),
                              //     FilteringTextInputFormatter.deny(RegExp(r"/"))
                              //   ],
                              //   // validator: (name) {
                              //   //   if (name == null || name.isEmpty) {
                              //   //     return 'Please enter children name';
                              //   //   }
                              //   //   return null;
                              //   // },
                              // ),
                              // SizedBox(
                              //   height: 25,
                              // ),
                              // Align(
                              //   alignment: Alignment.topLeft,
                              //   child: Container(
                              //       child: Text(
                              //     "Children Birthday",
                              //     style: TextStyle(
                              //       color: AppColor.white,
                              //       fontSize: 16,
                              //     ),
                              //     textAlign: TextAlign.start,
                              //   )),
                              // ),
                              // EditText(
                              //   onTap: () {
                              //     _childrenbirthdayDialog();
                              //   },
                              //   hint: "children birth date",
                              //   controller: childrenbirthDateCtr,
                              //   readOnly: true,
                              //   // validator: (date) {
                              //   //   if (date == null || date.isEmpty) {
                              //   //     return 'Please select children birth date';
                              //   //   }
                              //   //   return null;
                              //   // },
                              // ),
                              GestureDetector(
                                  onTap: () {
                                    if (editProfile
                                                .childrenname[editProfile
                                                        .childrenname.length -
                                                    1]
                                                .text
                                                .trim() !=
                                            '' &&
                                        editProfile
                                                .childrendate[editProfile
                                                        .childrenname.length -
                                                    1]
                                                .text
                                                .trim() !=
                                            '') {
                                      editProfile.childrenname
                                          .add(TextEditingController());
                                      editProfile.childrendate
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
                                    if (isValidState && editProfileController.phonenoController.text.isNotEmpty &&
                                        editProfileController
                                            .assistantphonenoController
                                            .text
                                            .isNotEmpty) {

                                      if (editProfileController
                                          .spoucebirthDateCtr.text !=
                                          '') {
                                        if (editProfileController
                                            .spouceNameCtr.text !=
                                            '' ) {
                                          if(editProfileController
                                              .childrendate[0].text ==
                                              ''){
                                            setState(() {
                                              checkChildrenName = true;
                                            });
                                          }else{
                                            if (editProfileController
                                                .childrendate[0].text !=
                                                '') {
                                              print(
                                                  '>>>>>>>>> ${editProfileController.childrendate[0].text}');
                                              for (int i = 0;
                                              i <
                                                  editProfileController
                                                      .childrendate.length;
                                              i++) {
                                                print(
                                                    '>>>>>>>>> ${editProfileController.childrenname[i]}');
                                                if (editProfileController
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
                                          editProfile.profileselectedId.value;
                                          if (editProfile.onBtnClick.value == false) {
                                            editProfile.editprofile(context, editProfile.profileselectedId.value,
                                                image: editProfileController
                                                    .imagePath.value,
                                                type: false);
                                          }
                                        });
                                      }
                                    }
                                  });
                                },
                              /*  onTap: () async {
                                  FocusNode? focusNode =
                                      FocusManager.instance.primaryFocus;
                                  if (focusNode != null) {
                                    if (focusNode.hasPrimaryFocus) {
                                      focusNode.unfocus();
                                    }
                                  }










                                  print(
                                      'length >> ${editProfile.childrenname.length} ${editProfile.childrendate.length}');
                                  if(editProfileController.childrendate[0].text != '' ){
                                    print('>>>>>>>>> ${editProfileController.childrendate[0].text}');
                                    for (int i = 0; i < editProfileController.childrendate.length; i++) {
                                      print('>>>>>>>>> ${editProfileController.childrenname[i]}');
                                      if (editProfileController.childrenname[i].text != '') {
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
                                  } else{
                                    setState(() {
                                      checkChildrenName = true;
                                    });
                                  }
                                  print('check >> $checkChildrenName');
                                  if (checkChildrenName == false) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          "Please enter children name first!!"),
                                    ));
                                  } else {
                                    setState(() {
                                      if (_formKey.currentState?.validate() ??
                                          false) {

                                      }
                                    });
                                  }

                                },*/
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: AppColor.primarycolor,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                    child: Text('Submit',
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
    if (editProfileController.childrendate.length >
        editProfileController.childrenname.length) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please enter children name first!!"),
      ));
    }
  }

  void _showInterestSelect(BuildContext context, editProfile) async {
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
            items: editProfileController.profileIntersetTextList
                .map((element) => MultiSelectItem(element, element))
                .toList(),
            initialValue: editProfile.profileIntersetSelectedServices.value,
            onConfirm: (values) {
              editProfile.profileIntersetSelectedServices.value = values;
              editProfile.profileselectedIntersetValuesToDisplay.value = "";
              values.forEach((element) {
                print("selected interest : $element");
                editProfile.profileselectedIntersetValuesToDisplay.value +=
                    '$element, ';
              });
              print(
                  'object${editProfile.profileIntersetSelectedServices.value}');
              // filterController.selectedIntersetValuesToDisplay.value =
              //     filterController.selectedIntersetValuesToDisplay.value
              //         .replaceRange(
              //   filterController.selectedIntersetValuesToDisplay.value.length -
              //       2,
              //   filterController.selectedIntersetValuesToDisplay.value.length,
              //   "",
              // );
              if (editProfile
                  .profileselectedIntersetValuesToDisplay.value.isNotEmpty) {
                editProfile.profileselectedIntersetValuesToDisplay.value =
                    editProfile.profileselectedIntersetValuesToDisplay.value
                        .replaceRange(
                  editProfile
                          .profileselectedIntersetValuesToDisplay.value.length -
                      2,
                  editProfile
                      .profileselectedIntersetValuesToDisplay.value.length,
                  "",
                );

                List<String> ids = [];
                editProfile.profileinterestList.forEach((element) {
                  editProfile.profileIntersetSelectedServices
                      .forEach((ownerJobType) {
                    if (ownerJobType == element.interestName) {
                      ids.add(element.interestId.toString());
                    }
                  });
                });
                setState(() {
                  editProfile.profileselectedId.value = ids.join(',');
                });
                editProfile.profileselectedIntersetValuesToDisplay.value;
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
                    'object${editProfile.profileIntersetSelectedServices.value}');
              } else {
                setState(() {
                  editProfile.profileselectedId.value = '';
                });
                editProfile.profileselectedIntersetValuesToDisplay.value;
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
                    'object${editProfile.profileIntersetSelectedServices.value}');
              }
            },
          ),
        );
      },
    );
  }

  void _birthdayDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime.now(),
            //what will be the previous supported year in picker
            lastDate: DateTime(
                2050)) //what will be the up to supported date in picker
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
        birthDateCtr.text = formatted;
      });
    });
  }

  void _spoucebirthdayDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime.now(),
            //what will be the previous supported year in picker
            lastDate: DateTime(
                2050)) //what will be the up to supported date in picker
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
        spoucebirthDateCtr.text = formatted;
      });
    });
  }

  void _childrenbirthdayDialog() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            //which date will display when user open the picker
            firstDate: DateTime.now(),
            //what will be the previous supported year in picker
            lastDate: DateTime(
                2050)) //what will be the up to supported date in picker
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
        childrenbirthDateCtr.text = formatted;
      });
    });
  }

  void showToast(String msg, {int? duration, int? gravity}) {
    Toast.show('msg', duration: duration, gravity: gravity);
  }
}
