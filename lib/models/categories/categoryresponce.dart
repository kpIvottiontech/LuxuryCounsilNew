import 'package:luxury_council/models/categories/categorymodel.dart';

class CategorieResponce {
  List<CategorieModel>? categoryModel;
  bool? status;
  String? message;

  CategorieResponce({this.categoryModel, this.status, this.message});

  CategorieResponce.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      categoryModel = <CategorieModel>[];
      json['data'].forEach((v) {
        categoryModel!.add(new CategorieModel.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categoryModel != null) {
      data['data'] = this.categoryModel!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}