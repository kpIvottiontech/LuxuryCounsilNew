import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../colors.dart';

enum LoaderType {
  activityIndicator,
  circularProgressIndicator,
}

class AppLoader extends StatelessWidget {
  final LoaderType type;
  final Color color;

  const AppLoader({super.key,
    this.type = LoaderType.circularProgressIndicator,
    this.color = AppColor.primarycolor,
  });

  @override
  Widget build(BuildContext context) {
    return type == LoaderType.circularProgressIndicator
        ? WillPopScope(
            onWillPop: () async => false,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          )
        : Center(
            child: Theme(
                data: ThemeData(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: color),),
              child: const CupertinoActivityIndicator(),
            ),
          );
  }
}
