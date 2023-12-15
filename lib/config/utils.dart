import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
    static String yyyymmdddateFormate(String date) {
      DateTime parseDate =
      new DateFormat("dd/MM/yyyy").parse(date);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputFormat = DateFormat('yyyy-MM-dd');
      var outputDate = outputFormat.format(inputDate);
      print(outputDate);
      return outputDate;

  }
  static String dateFormate(String date) {
    var sDate = DateTime.parse(date ?? "");

    String fSDate = DateFormat(
      'dd/MM/yyyy',
    ).format(sDate);
    return fSDate;
  }

  static String timeFormate(String time) {
    DateTime parseDate =
        new DateFormat("yyyy-MM-dd HH:mm:ss").parse(time);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('hh:mm a');
    var outputDate = outputFormat.format(inputDate);
    print(outputDate);
    return outputDate;
  }
  
}

class AspectSize {
  static const int designWidth = 414;
  static double getWidthSize(
      {required BuildContext context, required double sizeConstant}) {
    return sizeConstant != 0.0
        ? ((MediaQuery.of(context).size.width * sizeConstant) / designWidth)
        : 0.0;
  }

  static double getScreenWidth({required BuildContext context}) {
    return MediaQuery.of(context).size.width;
  }
}


