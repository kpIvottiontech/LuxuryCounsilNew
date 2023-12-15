import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/controllers/companylistController.dart';
import 'package:luxury_council/strings.dart';

class CompanyList extends StatefulWidget {
  const CompanyList({super.key});

  @override
  State<CompanyList> createState() => _CompanyListState();
}

class _CompanyListState extends State<CompanyList> {
  final CompanylistController companyListController =
      Get.put(CompanylistController());
  late ScrollController _scrollController;
  int _pageNumber = 10;
  @override
  void initState() {
    companyListController.getCompanyList(
      context,
      0,
      10,
    );
    _scrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() async {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          setState(() {
            _pageNumber = _pageNumber + 10;
          });
          if (companyListController.companylistresponce.isTrue) {
            print('object = ' + _pageNumber.toString());
            companyListController.getCompanyList(
              context,
              _pageNumber,
              10,
            );
          }
        }
      }
    });
    return Scaffold(
      backgroundColor: AppColor.loginappbar,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.only(top: 30),
                child: Text(
                  "Company List",
                  style: TextStyle(fontSize: 20, color: AppColor.primarycolor),
                ),
              ),
              Obx(
                () => Container(
                  child: companyListController.companyList.isNotEmpty
                      ? ListView.separated(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: companyListController.companyList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border:
                                      Border.all(color: AppColor.textlight)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Company Name : ",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: AppColor.primarycolor),
                                      ),
                                      Text(
                                        "${companyListController.companyList[index].companyName}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: AppColor.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Company Status : ",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: AppColor.primarycolor),
                                      ),
                                      Text(
                                      companyListController.companyList[index].companyStatus==0?  "Inactive":"Active",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:companyListController.companyList[index].companyStatus==0?  Colors.green:Colors.red),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Company Id : ",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: AppColor.primarycolor),
                                      ),
                                      Text(
                                        "${companyListController.companyList[index].companyId}",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.white),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 20,
                            );
                          },
                        )
                      : Center(child: Text(noCompanyFound)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
