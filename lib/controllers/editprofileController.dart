import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:luxury_council/api_config/api_services.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/config/prefrance.dart';
import 'package:luxury_council/config/utils.dart';
import 'package:luxury_council/constance/global_data.dart';
import 'package:luxury_council/controllers/filterController.dart';
import 'package:luxury_council/controllers/loginController.dart';
import 'package:luxury_council/controllers/registerController.dart';
import 'package:luxury_council/models/OwnerJobCategories.dart';
import 'package:luxury_council/models/interest/interestmodel.dart';
import 'package:luxury_council/models/interest/interestrequest.dart';
import 'package:luxury_council/models/interest/interestresponce.dart';
import 'package:http/http.dart' as http;
import '../api_config/urls.dart';

class EditProfileController extends GetxController {
  final FilterController filterController = Get.put(FilterController());
  final registercontroller = Get.put(RegisterController());
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController phonenoController = TextEditingController();
  TextEditingController mailingaddressController = TextEditingController();
  TextEditingController assistantnameController = TextEditingController();
  TextEditingController assistantemailController = TextEditingController();
  TextEditingController assistantphonenoController = TextEditingController();
  TextEditingController birthDateCtr = TextEditingController();
  TextEditingController spouceNameCtr = TextEditingController();
  TextEditingController spoucebirthDateCtr = TextEditingController();
  var childrenname = [TextEditingController()].obs;
  var childrendate = [TextEditingController()].obs;
  var firstname = ''.obs;
  var lastname = ''.obs;
  var title = ''.obs;
  var subscriptionid = ''.obs;
  var subscriptionyear = ''.obs;
  var subscriptiontype = ''.obs;
  var subscriptionmonth = ''.obs;
  var subscriptionname = ''.obs;
  var startdate = ''.obs;
  var enddate = ''.obs;
  List<dynamic> children = [];
  String interestID = '';
  RxBool onBtnClick = false.obs;
  String contactCountryCode = 'US';
  String assistantCountryCode = 'US';

  RxList<InterestModel> profileinterestList = <InterestModel>[].obs;
  RxList<String> profileIntersetTextList = <String>[].obs;
  RxList<String> profileIntersetSelectedServices = <String>[].obs;
  RxString profileselectedIntersetValuesToDisplay = "".obs;
  RxString profileselectedId = "".obs;
  RxBool profileintersetresponce = true.obs;
  RxString imagePath = "".obs;

  Future<void> checkdata() async {
    int subsId = await GetIntData("subscription_id");
    print("objectobjectobjectobject------${subsId}");

    if (subsId == 0) {
      Get.offAndToNamed("/HomeWithoutSignUp");
    } else {
      Get.offAndToNamed("/HomeWithSignUp");
    }
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }


  LoginController loginController = Get.put(LoginController());
  FilterController filterControoller = Get.put(FilterController());

  Future<void> checkdata1() async {
    int subsId =
    await GetIntData("subscription_id");
    print(
        "objectobjectobjectobject------${subsId}");

    if (subsId == 0) {
      Get.offAndToNamed("/HomeWithoutSignUp");
    } else {
      Get.offAndToNamed("/HomeWithSignUp");
    }
  }
  Future<String?> networkImageToBase64(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    final bytes = response?.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : null);
  }

  editprofile(BuildContext context,String interest,{String? image,bool? type}) async {
    print('type>1> ${type}');
    late File _imageFile;
    String? _base64Image = '';
    onBtnClick.value = true;
    for (int i = 0; i < childrenname.length; i++) {
      if (childrenname[i].text.isNotEmpty && childrendate[i].text.isNotEmpty) {
        children.add({
          "name": childrenname[i].text.toString(),
          "birthday":childrendate[i].text.toString()!= ''? Utils.yyyymmdddateFormate(childrendate[i].text.toString(),):'',

        });
      }
    }
    if (image != null && type == true) {
      print('type>3> ${type}');
      _imageFile = File(image);
      _base64Image = await base64Encode(_imageFile.readAsBytesSync());
      print('fileName $_base64Image');
    }
    if(type == false){
      _base64Image = imagePath.value== '' ? '' :await  networkImageToBase64(imagePath.value);
      print('fileName $_base64Image');
    }
   await POST_API({
      "first_name": firstnameController.text.toString(),
      "last_name": lastnameController.text.toString(),
      "email": emailController.text.toString(),
      "company": companyController.text.toString(),
      "title": titleController.text.toString(),
      "country_code": contactCountryCode,
      "phone_no": phonenoController.text.toString(),
      "mailing_address": mailingaddressController.text.toString(),
      "assistant_name": assistantnameController.text.toString(),
      "assistant_email": assistantemailController.text.toString(),
      "assistant_country_code": assistantCountryCode,
      "assistant_phone_no": assistantphonenoController.text.toString(),
      "business_interests": interest.toString(),
      "birthday":birthDateCtr.text.toString()!= ''? Utils.yyyymmdddateFormate(birthDateCtr.text.toString(),):'',
      "profile_img": _base64Image ,
      "spouse_name": spouceNameCtr.text.toString(),
      "spouse_birthday":spoucebirthDateCtr.text.toString()!= ''? Utils.yyyymmdddateFormate(spoucebirthDateCtr.text.toString(),):'',
      "children": children
    }, Urls.Edit_Profile, context)
        .then((response){
      Map<String, dynamic> editprofileResponse = jsonDecode(response);
      if (editprofileResponse['status'] != true) {
        onBtnClick.value = false;
       // context.loaderOverlay.hide();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(editprofileResponse['message'])));
      } else {
        onBtnClick.value = false;
       // context.loaderOverlay.hide();
        if (type == false) {
          checkdata();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Profile Updated Successfully',
              style: TextStyle(color: AppColor.white),
            ),
          ));
        }else{
        }

        print(
            'business interest--------- ${filterControoller.selectedIntersetValuesToDisplay.value}');
        firstnameController.clear();
        lastnameController.clear();
        emailController.clear();
        companyController.clear();
        titleController.clear();
        phonenoController.clear();
        mailingaddressController.clear();
        assistantnameController.clear();
        assistantemailController.clear();
        assistantphonenoController.clear();
        birthDateCtr.clear();
        spouceNameCtr.clear();
        spoucebirthDateCtr.clear();
        children.clear();
        onBtnClick.value = false;
      }
    }, onError: (e) {
      onBtnClick.value = false;
     // context.loaderOverlay.hide();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
  }

  void showProgressIndicator(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from dismissing the dialog
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('uploading image...'),
              ],
            ),
          ),
        );
      },
    );

    Future.delayed(Duration(seconds: 10), () {
      Navigator.of(context).pop();
    });
  }
  updateScreen(String value) {
    update([value]);
  }

  getprofile(BuildContext context,{bool? type}) async {
   await GET_API(Urls.GET_Profile, context).then((response) {
     print('=========================${response}');
      Map<String, dynamic> getprofileResponse = jsonDecode(response);
      print("=========================${getprofileResponse}");
      if (getprofileResponse['status'] != true) {
        /*if(type ?? false == true){
          MyUploadDialog.hide(context);
        }*/
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(getprofileResponse['message'])));
      } else {
        firstnameController.text =
            getprofileResponse["data"]["first_name"].toString();
        lastnameController.text =
            getprofileResponse["data"]["last_name"].toString();
        emailController.text = getprofileResponse["data"]["email"].toString();
        if (getprofileResponse["data"]["company"] != null) {
          print('company text>>>${getprofileResponse["data"]["company"]["company_name"].toString()}');
          companyController.text =
              getprofileResponse["data"]["company"]["company_name"].toString();
        }
        if (getprofileResponse["data"]["title"] != null) {
          titleController.text = getprofileResponse["data"]["title"].toString();
        } else {
          titleController.text = '';
        }
        if (getprofileResponse["data"]["business_interests"] != null && getprofileResponse["data"]["business_interests"] != '') {
          print('get>>${getprofileResponse["data"]["business_interests"].toString()}');
          profileselectedId.value = getprofileResponse["data"]["business_interests"].toString();

          List<int> values = getprofileResponse["data"]["business_interests"].toString().split(",").map((x) => int.parse(x)).toList();
          print('values>>${values.length}>>>${profileinterestList.length}');
          List<String> name = [];
          profileinterestList.forEach((element) {
            print('element>>${element.interestId}');
            values.forEach(
                    (ownerJobType) {
                  if (ownerJobType == element.interestId) {
                    name.add(element.interestName.toString());
                  }
                });
          });
          print('name is >>${name}');
          profileIntersetSelectedServices.value.addAll(name);
          profileselectedIntersetValuesToDisplay.value = name.join(',');
            print('object >>>>>> ${name.join(',')}');
          updateScreen('editProfile');
        } else {
          profileselectedIntersetValuesToDisplay.value = '';
        }
        if (getprofileResponse["data"]["country_code"] != null) {
          contactCountryCode = getprofileResponse["data"]["country_code"].toString();
        } else {
          contactCountryCode ='US';
        }
       // contactCountryCode = getprofileResponse["data"]["country_code"].toString() != ''?getprofileResponse["data"]["country_code"].toString() ?? 'U':'+1'
        print('contactCountryCode ${contactCountryCode}');
        phonenoController.text =
            getprofileResponse["data"]["phone_no"].toString();
        if (getprofileResponse["data"]["mailing_address"] != null) {
          mailingaddressController.text =
              getprofileResponse["data"]["mailing_address"].toString();
        }

        if (getprofileResponse["data"]["assistant_name"] != null) {
          assistantnameController.text =
              getprofileResponse["data"]["assistant_name"].toString();
        } else {
          assistantnameController.text = "";
        }

        if (getprofileResponse["data"]["assistant_email"] != null) {
          assistantemailController.text =
              getprofileResponse["data"]["assistant_email"].toString();
        } else {
          assistantemailController.text = "";
        }
        if (getprofileResponse["data"]["assistant_country_code"] != null) {
          assistantCountryCode = getprofileResponse["data"]["assistant_country_code"].toString();
        } else {
          assistantCountryCode ='US';
        }
        //assistantCountryCode = getprofileResponse["data"]["assistant_country_code"].toString() != ''?getprofileResponse["data"]["assistant_country_code"].toString() ?? 'US':'US';
        print('assistantCountryCode ${assistantCountryCode}');

        if (getprofileResponse["data"]["assistant_phone_no"] != null) {
          assistantphonenoController.text =
              getprofileResponse["data"]["assistant_phone_no"].toString();
        } else {
          assistantphonenoController.text = "";
        }
        firstname.value = getprofileResponse["data"]["first_name"].toString();
        lastname.value = getprofileResponse["data"]["last_name"].toString();
        title.value = getprofileResponse["data"]["title"].toString();
        subscriptionid.value =
            getprofileResponse["data"]["subscription_id"].toString() ?? '';
        subscriptiontype.value = getprofileResponse["data"]["subscription_type"].toString() ?? '';
        if (getprofileResponse["data"]["subscription"].isNotEmpty) {
          subscriptionname.value = getprofileResponse["data"]["subscription"]['subscription_name'].toString() ?? '';
          subscriptionyear.value = getprofileResponse["data"]["subscription"]
                  ["subscription_price_per_year"]
              .toString();
          subscriptionmonth.value = getprofileResponse["data"]["subscription"]
                  ["subscription_price_per_month"]
              .toString();
        }
        if (getprofileResponse["data"]["subscription_start_date"] != null) {
          startdate.value =
              getprofileResponse["data"]["subscription_start_date"].toString();
          enddate.value =
              getprofileResponse["data"]["subscription_end_date"].toString();

          print('enddate ${enddate.value}');
        } else {
          startdate.value = "";
          enddate.value = "";
        }
        if (getprofileResponse["data"]["birthday"] != null) {
          birthDateCtr.text = '${DateFormat('dd/MM/yyyy').format(DateTime.parse(getprofileResponse["data"]["birthday"].toString()))}';

             // getprofileResponse["data"]["birthday"].toString();
        } else {
          birthDateCtr.text = "";
        }
        if(getprofileResponse["data"]["profile_img_url"] != null){
          if ((imagePath.value) != getprofileResponse["data"]["profile_img_url"].toString()) {
            imagePath.value = getprofileResponse["data"]["profile_img_url"].toString();
            print('diff string>>>${imagePath.value}');
          }
        }else{
          imagePath.value = '';
        }
        updateScreen('profile');
        if (getprofileResponse["data"]["spouse_name"] != null) {
          spouceNameCtr.text =
              getprofileResponse["data"]["spouse_name"].toString();
        } else {
          spouceNameCtr.text = "";
        }
        if (getprofileResponse["data"]["spouse_birthday"] != null) {
          spoucebirthDateCtr.text ='${DateFormat('dd/MM/yyyy').format(DateTime.parse(  getprofileResponse["data"]["spouse_birthday"].toString()))}';
              // getprofileResponse["data"]["spouse_birthday"].toString();
        } else {
          spoucebirthDateCtr.text = "";
        }
        if (getprofileResponse["data"]["children"].isNotEmpty) {
          childrenname.clear();
          childrendate.clear();
        }
        for (int i = 0;
            i < getprofileResponse["data"]["children"].length;
            i++) {
          TextEditingController nameController = TextEditingController();
          TextEditingController birthController = TextEditingController();
          nameController.text =
              getprofileResponse["data"]["children"][i]["name"].toString();
          childrenname.add(nameController);
          birthController.text = '${DateFormat('dd/MM/yyyy').format(DateTime.parse(getprofileResponse["data"]["children"][i]["birthday"].toString()))}';
              // getprofileResponse["data"]["children"][i]["birthday"].toString();
          childrendate.add(birthController);
          /* childrenname[i].text =
              getprofileResponse["data"]["children"][i]["name"].toString();
          childrendate[i].text =
              getprofileResponse["data"]["children"][i]["birthday"].toString();
          print("childrenname ${childrenname[i].text}");
          print("childrendate ${childrendate[i].text}");*/
        }
        updateScreen('editProfile');
        print('type>5> ${type}');
       /* if(type ?? false == true){
          MyUploadDialog.hide(context);
        }*/
      }
      }, onError: (e) {
     /*if(type ?? false == true){
       MyUploadDialog.hide(context);
     }*/
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
  }

  getProfileIntersetList(
      BuildContext context,
      List<OwnerJobCategories>? ownerJobCategories,
      int page,
      int limit,
      ) {
    // context.loaderOverlay.show();
    print("PROFILE INTEREST LIST URL ----> ${Urls.INTEREST_LIST}");
    InterestRequest interestlistRequest = InterestRequest(
      page: page,
      limit: limit,
    );
    print("PROFILE INTEREST LIST URL ----> ${jsonEncode(interestlistRequest)}");
    POST_API(interestlistRequest, Urls.INTEREST_LIST, context).then((response) {
      print("PROFILE INTEREST LIST response ----> $response");
      IntersetResponce profileinterestlistResponse =
      IntersetResponce.fromJson(jsonDecode(response));
      Map<String, dynamic> map = jsonDecode(response);
      if (map["status"] != true) {
        profileintersetresponce = false.obs;
      } else {
        profileinterestList.clear();
        profileIntersetTextList.clear();
        profileIntersetSelectedServices.clear();
        profileselectedIntersetValuesToDisplay.value = "";
        profileinterestList.value = profileinterestlistResponse.interestModel ?? [];
        print('profileinterestList.value >>> ${profileinterestList.value.length}');
        profileinterestList.value.forEach((element) {
          profileIntersetTextList.add(element.interestName ?? "");
        });
        print('check it here>> ${profileselectedIntersetValuesToDisplay.value}');
        var listSelected = profileselectedIntersetValuesToDisplay.value.split(',');
        print('listSelected >>> ${listSelected}');
        List<dynamic> list = [];
        profileIntersetTextList.forEach((element1) {
          print('element1 >>> ${element1}');
          listSelected.forEach((element) {
            print('element >>> ${element}');
            if(element1==element){
              list.add(element1);
            }
          });
        });
        print('list >>> ${list}');

       // profileIntersetSelectedServices.value = list;
        profileIntersetSelectedServices.value =  List<String>.from(list.map((item) => '$item'));
        if (ownerJobCategories != null) {
          ownerJobCategories.forEach((element) {
            profileIntersetSelectedServices.add(element.jobCategoryName!);
            profileselectedIntersetValuesToDisplay.value +=
                element.jobCategoryName! + ", ";
          });
          profileselectedIntersetValuesToDisplay.value =
              profileselectedIntersetValuesToDisplay.value.replaceRange(
                profileselectedIntersetValuesToDisplay.value.length - 2,
                profileselectedIntersetValuesToDisplay.value.length,
                "",
              );
        }
        // context.loaderOverlay.hide();

        // interestList.addAll((interestlistResponse.interestModel ?? []));
      }
      // context.loaderOverlay.hide();
    });
  }

  void cancelsub(BuildContext context) {
    context.loaderOverlay.show();
    GET_API(Urls.cancel_subscription, context).then((response) async {
      Map<String, dynamic> getprofileResponse = jsonDecode(response);
      print("=========================${getprofileResponse}");
      context.loaderOverlay.hide();
      GlobalData().subscriptionId = 0;
      SetIntData("subscription_id",0);
      Get.offAllNamed('/HomeWithoutSignUp');
    }, onError: (e) {
      context.loaderOverlay.hide();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
  }
}
