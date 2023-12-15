import 'package:luxury_council/models/interest/interestmodel.dart';

class IntersetResponce {
  List<InterestModel>? interestModel;
  bool? status;
  String? message;

  IntersetResponce({this.interestModel, this.status, this.message});

  IntersetResponce.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      interestModel = <InterestModel>[]; 
      json['data'].forEach((v) {
        interestModel!.add(new InterestModel.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.interestModel != null) {
      data['data'] = this.interestModel!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
