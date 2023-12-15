import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:luxury_council/api_config/api_services.dart';
import 'package:luxury_council/api_config/urls.dart';
import 'package:luxury_council/config/prefrance.dart';
import 'package:luxury_council/models/companylist/companylistmodel.dart';
import 'package:luxury_council/models/companylist/companylistrequest.dart';
import 'package:luxury_council/models/companylist/companylistresponce.dart';

class CompanylistController extends GetxController {
  RxList<CompanyListModel> companyList = <CompanyListModel>[].obs;
  RxList<String> companyListing = <String>[].obs;

  RxBool companylistresponce = true.obs;

  void getCompanyList(
    BuildContext context,
    int page,
    int limit,
  ) {
    context.loaderOverlay.show();
    print("COMPANY LIST URL ----> ${Urls.COMPANY_LIST}");
    CompanylistRequest companylistRequest = CompanylistRequest(
      page: page,
      limit: limit,
    );
    print("COMPANY LIST URL ----> ${jsonEncode(companylistRequest)}");
    POST_API(companylistRequest, Urls.COMPANY_LIST, context).then((response) {
      print("COMPANY LIST response ----> $response");
      Map<String, dynamic> map = jsonDecode(response);
      if (map["status"] != true) {
        companylistresponce = false.obs;
      } else {
        CompanylistResponce companylistResponse =
            CompanylistResponce.fromJson(jsonDecode(response));
        //companyList.clear();
        companyList.addAll((companylistResponse.companyListModel ?? []));
      }
      context.loaderOverlay.hide();
    });
  }

  getCompanyListWithoutPagination(
    BuildContext context,) async {
    print("COMPANY LIST URL ----> ${Urls.COMPANY_LIST}");
    CompanylistRequest companylistRequest = CompanylistRequest(
      page: 0,
      limit: 10000,
    );
    print("COMPANY LIST URL ----> ${jsonEncode(companylistRequest)}");
   await POST_API(companylistRequest, Urls.COMPANY_LIST, context).then((response) {
      print("COMPANY LIST response ----> $response");
      Map<String, dynamic> map = jsonDecode(response);
      if (map["status"] != true) {
        companylistresponce = false.obs;
      } else {
        CompanylistResponce companylistResponse =
            CompanylistResponce.fromJson(jsonDecode(response));
        companyListing.clear();
        companylistResponse.companyListModel?.forEach((element) {
          companyListing.add(element.companyName ?? '');
        });

      }
      // context.loaderOverlay.hide();
    });
  }
}
