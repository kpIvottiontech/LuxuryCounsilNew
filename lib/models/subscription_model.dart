
class SubscriptionModel {
  List<SubscriptionData>? data;
  bool? status;
  String? message;

  SubscriptionModel({this.data, this.status, this.message});

  SubscriptionModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SubscriptionData>[];
      json['data'].forEach((v) {
        data!.add(new SubscriptionData.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class SubscriptionData {
  int? subscriptionId;
  int? subscriptionLevel;
  String? subscriptionName;
  String? subscriptionContent;
  String? subscriptionPricePerMonth;
  String? subscriptionPricePerYear;
  int? subscriptionStatus;

  SubscriptionData(
      {this.subscriptionId,
        this.subscriptionLevel,
        this.subscriptionName,
        this.subscriptionContent,
        this.subscriptionPricePerMonth,
        this.subscriptionPricePerYear,
        this.subscriptionStatus});

  SubscriptionData.fromJson(Map<String, dynamic> json) {
    subscriptionId = json['subscription_id'];
    subscriptionLevel = json['subscription_level'];
    subscriptionName = json['subscription_name'];
    subscriptionContent = json['subscription_content'];
    subscriptionPricePerMonth = json['subscription_price_per_month'];
    subscriptionPricePerYear = json['subscription_price_per_year'];
    subscriptionStatus = json['subscription_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subscription_id'] = this.subscriptionId;
    data['subscription_level'] = this.subscriptionLevel;
    data['subscription_name'] = this.subscriptionName;
    data['subscription_content'] = this.subscriptionContent;
    data['subscription_price_per_month'] = this.subscriptionPricePerMonth;
    data['subscription_price_per_year'] = this.subscriptionPricePerYear;
    data['subscription_status'] = this.subscriptionStatus;
    return data;
  }
}
