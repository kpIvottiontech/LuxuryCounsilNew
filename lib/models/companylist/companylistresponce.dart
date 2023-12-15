import 'package:luxury_council/models/companylist/companylistmodel.dart';

class CompanylistResponce {
  List<CompanyListModel>? companyListModel;
  bool? status;
  String? message;

  CompanylistResponce({this.companyListModel, this.status, this.message});

  CompanylistResponce.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      companyListModel = <CompanyListModel>[];
      json['data'].forEach((v) {
        companyListModel!.add(new CompanyListModel.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.companyListModel != null) {
      data['data'] = this.companyListModel!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}