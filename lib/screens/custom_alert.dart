
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_council/colors.dart';


class CustomAlert {
  static void showAlert(
      BuildContext context,
    String message, {
    String? title,
    String btnFirst = 'Ok',
    String? btnSecond,
        Function(int)? handler,
  }) {
    Get.generalDialog(
      barrierDismissible: false,
      barrierLabel: 'barrierLabel',
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return SafeArea(
          child: Center(
            child: Container(
              width: Get.width - 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          _titleWidget(title: title),
                          _messageWidget(message: message),
                          _buttonWidget(
                            context: context,
                            ok: btnFirst,
                            cancel: btnSecond ?? '',
                            handler: handler,
                            title: message
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return ScaleTransition(
          scale: anim,
          child: child,
        );
      },
    );
  }

  static Widget _titleWidget({String? title}) {
    if (title == null) {
      return Container(height: 10);
    } else {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: AppColor.black,
            fontWeight:
            FontWeight.bold,
            decoration: TextDecoration.none,
          ),
        ),
      );
    }
  }

  static Widget _messageWidget({String? message}) {

    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: Get.height - 200
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            message ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.0,
              color: AppColor.black,
              fontWeight:
              FontWeight.normal,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buttonWidget({String? ok,
    String? cancel, Function(int)? handler, required BuildContext context, String? title}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(Get.context!);

                if (handler != null) {
                  handler(0);
                }

              },
              child: Container(
                height: 40,
                color: AppColor.primarycolor,
                child: Center(
                  child: Text(
                    ok ?? '',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style:TextStyle(
                        color: AppColor.white,
                        fontSize: 18.00,
                        fontWeight:
                        FontWeight.bold,
                        decoration:TextDecoration.none
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: AppColor.white,
            width: (cancel == null || cancel == '') ? 0 : 1,
            height: 40,
          ),
          if (cancel == null || cancel == '') Container() else Expanded(
            child: GestureDetector(
              onTap: () {
                if (handler != null) {
                  handler(1);
                }

                Navigator.pop(Get.context!);
              },
              child: Container(
                height: 40,
                color: AppColor.primarycolor,
                child: Center(
                  child: Text(
                    cancel,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                        color: AppColor.white,
                        fontSize: 18.00,
                        fontWeight:
                        FontWeight.bold,
                        decoration:TextDecoration.none
                    ),
                    // style: AppFontStyle.customAlertButtonOk,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
