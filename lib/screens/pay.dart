import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:luxury_council/colors.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:luxury_council/config/prefrance.dart';
import 'package:luxury_council/constance/global_data.dart';
import 'package:luxury_council/controllers/editprofileController.dart';
import 'package:luxury_council/controllers/homeController.dart';
import 'package:luxury_council/controllers/loginController.dart';
import 'package:luxury_council/controllers/notification_controller.dart';
import 'package:luxury_council/controllers/paymentController.dart';
import 'package:luxury_council/widgets/appbars.dart';

import '../widgets/edittext.dart';

class PayScreen extends StatefulWidget {
  final String plan1;
  const PayScreen({super.key, required this.plan1});

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  final PaymentController paymentController = Get.put(PaymentController());
  final NotificationController notificationController =
  Get.put(NotificationController());
  final LoginController loginController = Get.put(LoginController());
  final EditProfileController editProfileController =
      Get.put(EditProfileController());
  final cardnumbercontroller = TextEditingController();
  final expiredatecontroller = TextEditingController();
  final cvvcontroller = TextEditingController();
  final nameController = TextEditingController();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  HomeController homeController = Get.put(HomeController());int subscriptionid = GlobalData().subscriptionId;
  int type = Get.arguments[2] ?? 1;
  @override
  void initState() {
    print('type is ${type.toString()}');
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    deleteNotification();
    super.initState();
  }

  deleteNotification() async {
    List<num> articleList = [];
    if (notificationController.articleData.isNotEmpty) {
      for (var item in notificationController.articleData) {
        articleList.add(item.articleId!);
      }
    }
    if (articleList!.isNotEmpty) {
      String articleListString = articleList.toString().replaceAll('[', '').replaceAll(']', '');
      await notificationController.deleteNotification(context, articleListString);
    }
    notificationController.articleData.clear();
    notificationController.notificationStreamController.sink
        .add(notificationController.articleData);
    notificationController.notificationCount.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColor.grey,
      appBar: AppBarDetails(appBar: AppBar(), text: 'PAYMENT', isNotSubscription: subscriptionid==0||subscriptionid==1||subscriptionid==2||subscriptionid==6,screenName: '/PayScreen',),
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
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  ),

                  CreditCardWidget(
                    labelCardHolder: '',
                    glassmorphismConfig:
                        useGlassMorphism ? Glassmorphism.defaultConfig() : null,
                    cardNumber: cardNumber,
                    expiryDate: expiryDate,
                    cardHolderName: '',
                    cvvCode: cvvCode,

                    //bankName: 'Axis Bank',
                    frontCardBorder: !useGlassMorphism
                        ? Border.all(color: Colors.grey)
                        : null,
                    backCardBorder: !useGlassMorphism
                        ? Border.all(color: Colors.grey)
                        : null,
                    showBackView: isCvvFocused,
                    obscureCardNumber: true,
                    obscureCardCvv: true,
                    isHolderNameVisible: true,
                    cardBgColor: AppColor.grey,
                    // backgroundImage:
                    //     useBackgroundImage ? 'assets/card_bg.png' : null,
                    isSwipeGestureEnabled: true,
                    onCreditCardWidgetChange:
                        (CreditCardBrand creditCardBrand) {},
                    customCardTypeIcons: <CustomCardTypeIcon>[
                      // CustomCardTypeIcon(
                      //   cardType: CardType.mastercard,
                      //   cardImage: Image.asset(
                      //     'assets/mastercard.png',
                      //     height: 48,
                      //     width: 48,
                      //   ),
                      // ),
                    ],
                  ),
                  CreditCardForm(
                    formKey: formKey,
                    obscureCvv: true,
                    obscureNumber: true,
                    cardNumber: paymentController.cardNumber.value.toString(),
                    cvvCode: paymentController.cvvCode.value.toString(),
                    isHolderNameVisible: false,
                    isCardNumberVisible: true,
                    isExpiryDateVisible: true,
                    cardHolderName: '',
                    expiryDate: paymentController.expiryDate.value.toString(),
                    themeColor: Colors.blue,
                    textColor: Colors.white,
                    cardNumberDecoration: InputDecoration(
                      labelText: 'Card Number',
                      hintText: 'XXXX XXXX XXXX XXXX',
                      hintStyle: const TextStyle(color: Colors.white),
                      labelStyle: const TextStyle(color: Colors.white),
                      focusedBorder: border,
                      enabledBorder: border,
                    ),
                    expiryDateDecoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.white),
                      labelStyle: const TextStyle(color: Colors.white,fontSize: 15),
                      focusedBorder: border,
                      enabledBorder: border,
                      labelText: 'Expiration Date',
                      hintText: 'MM/YY',
                    ),
                    cvvCodeDecoration: InputDecoration(
                      hintStyle: const TextStyle(color: Colors.white),
                      labelStyle: const TextStyle(color: Colors.white,fontSize: 15),
                      focusedBorder: border,
                      enabledBorder: border,
                      labelText: 'CVV',
                      hintText: 'XXX',
                    ),
                    onCreditCardModelChange: onCreditCardModelChange,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Amount:",
                        style: TextStyle(color: AppColor.white, fontSize: 16),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "\$ ${widget.plan1}",
                        style: TextStyle(color: AppColor.white,fontSize: 16),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        var cnumber = cardNumber.replaceAll(' ', '');
                        var exp = expiryDate.replaceAll(' ', '');
                        var cv = cvvCode.replaceAll(' ', '');
                        print('cardNumber-----${cnumber}');
                        print('expiryDate-----${exp}');
                        print('cvvCode-----${cv}');
                        print(
                            'subscriptionid-----${loginController.subscriptionid.toString()}');
                        print(
                            'subscriptiontype------${loginController.subscriptiontype.toString()}');

                        String str = widget.plan1;
                        String amount = str.replaceAll(RegExp('[,]'), '');
                        paymentController.getPayment(
                          context,
                          cnumber,
                          exp,
                          cv,
                          amount,
                          int.parse(loginController.subscriptionid.toString()),
                          type,
                        );
                      } else {
                        print('invalid!');
                      }
                      // Get.toNamed("/Payment");
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 10, bottom: 10),
                      height: 45,
                      decoration: BoxDecoration(
                          color: AppColor.black,
                          border: Border.all(
                              color: AppColor.primarycolor, width: 2),
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Text('Payment',
                            style: TextStyle(
                                color: AppColor.primarycolor,
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
        ],
      ),
    );
  }

  // void _onValidate() {
  //   if (formKey.currentState!.validate()) {

  //   } else {
  //     print('invalid!');
  //   }
  // }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
