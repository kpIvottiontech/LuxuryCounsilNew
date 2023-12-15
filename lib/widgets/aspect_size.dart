import 'package:flutter/cupertino.dart';

class AspectSize {
  static const int designWidth = 414;
  static double getWidthSize({required BuildContext context,required double sizeConstant}){
    return sizeConstant != 0.0 ? ((MediaQuery.of(context).size.width * sizeConstant) / designWidth) : 0.0;
  }
  static double getScreenWidth({required BuildContext context}){
    return MediaQuery.of(context).size.width;
  }
}
