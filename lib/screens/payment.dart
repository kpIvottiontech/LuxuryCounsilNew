import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/config/utils.dart';
import 'package:luxury_council/controllers/editprofileController.dart';
import 'package:luxury_council/controllers/paymentController.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final PaymentController paymentController = Get.put(PaymentController());
  final EditProfileController editProfileController =
      Get.put(EditProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.grey,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              "assets/background.png",
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Center(
                  child: Image.asset(
                    'assets/success.png',
                    scale: 2.9,
                    height:MediaQuery.of(context).size.height / 6,
                    width:MediaQuery.of(context).size.height / 6,
                  ),
                ),
                SizedBox(
                  height: 55,
                ),
                /*Text(
                  "You have done the payment successfully",
                  style: TextStyle(
                      color: AppColor.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      height: 1.2),
                  textAlign: TextAlign.center,
                ),*/

                Text(
                  "Congratulations, your payment was successful.",
                  style: TextStyle(
                      color: AppColor.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      height: 1.2),
                  textAlign: TextAlign.center,
                ),
               /* Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Congratulations, your payment was successful",
                    style: TextStyle(
                        color: AppColor.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        height: 1.2),
                    textAlign: TextAlign.center,
                  ),
                ),*/
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Transaction id: ${paymentController.transactionid}",
                    style: TextStyle(
                        fontSize: 15, color: AppColor.white, height: 1.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    _setDate(),
                    style: TextStyle(
                        fontSize: 15, color: AppColor.white, height: 1.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(_setTime(),
                    style: TextStyle(
                        fontSize: 15, color: AppColor.white, height: 1.0),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 9,
                ),
                GestureDetector(
                  onTap: () {
                    paymentController.idds==0?Get.offAndToNamed("/HomeWithoutSignUp"):
                    Get.offAllNamed("/HomeWithSignUp");
                  },
                  child: Container( 
                    margin: EdgeInsets.symmetric(horizontal: 70),
                    height: MediaQuery.of(context).size.height / 17,
                    width: MediaQuery.of(context).size.width / 2.5,
                    decoration: BoxDecoration(
                      color: AppColor.primarycolor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/leftarrow.png',
                          scale: 2.9,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Back",
                          style: TextStyle(
                              fontSize: 16,
                              color: AppColor.black,
                              height: 1.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _setDate() {
    if(paymentController.datetime.isEmpty){
      var now = new DateTime.now();
      var formatter = new DateFormat('MM/dd/yyyy');
      String formattedDate = formatter.format(now);
      print(formattedDate);
      return "Date: $formattedDate";
    }
    else{
      return "Date: ${Utils.dateFormate(paymentController.datetime.toString())}";
    }

  }

  String _setTime() {
    if(paymentController.datetime.isEmpty){
      var now = new DateTime.now();
      var formatter = new DateFormat('hh:mm');
      String formattedDate = formatter.format(now);
      print(formattedDate);
      return "Time: $formattedDate";
    }
    else{
      return "Time: ${Utils.timeFormate(paymentController.datetime.toString())}";
    }

  }
}
