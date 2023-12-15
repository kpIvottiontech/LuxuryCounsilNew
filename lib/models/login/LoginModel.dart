class LoginModel {
  bool? status;
  String? message;
  UserData? user;
  String? token;

  LoginModel({this.status, this.message, this.user, this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    user = json['user'] != null ? new UserData.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class UserData {
  int? appUserId;
  int? groupSubscriptionId;
  int? subscriptionExpired;
  String? firstName;
  String? lastName;
  String? email;
  String? password;

  // int? company;
  Company? company;
  String? title;
  String? phoneNo;
  String? mailingAddress;
  String? assistantName;
  String? assistantEmail;
  String? assistantPhoneNo;
  int? subscriptionId;
  int? subscriptionType;
  String? subscriptionStartDate;
  int? appUserStatus;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? facebookId;
  String? googleId;
  String? linkedinId;

  UserData({this.appUserId,
    this.groupSubscriptionId,
    this.subscriptionExpired,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.company,
    this.title,
    this.phoneNo,
    this.mailingAddress,
    this.assistantName,
    this.assistantEmail,
    this.assistantPhoneNo,
    this.subscriptionId,
    this.subscriptionType,
    this.subscriptionStartDate,
    this.appUserStatus,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.facebookId,
    this.googleId,
    this.linkedinId});

  UserData.fromJson(Map<String, dynamic> json) {
    appUserId = json['app_user_id'];
    groupSubscriptionId = json['group_subscription_id'];
    subscriptionExpired = json['subscription_expired'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    password = json['password'];
    company =
    json['company'] != null ? new Company.fromJson(json['company']) : null;

    title = json['title'];
    phoneNo = json['phone_no'];
    mailingAddress = json['mailing_address'];
    assistantName = json['assistant_name'];
    assistantEmail = json['assistant_email'];
    assistantPhoneNo = json['assistant_phone_no'];
    subscriptionId = json['subscription_id'];
    subscriptionType = json['subscription_type'];
    subscriptionStartDate = json['subscription_start_date'];
    appUserStatus = json['app_user_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    facebookId = json['facebook_id'];
    googleId = json['google_id'];
    linkedinId = json['linkedin_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_user_id'] = this.appUserId;
    data['group_subscription_id'] = this.groupSubscriptionId;
    data['subscription_expired'] = this.subscriptionExpired;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['password'] = this.password;
    if (this.company != null) {
      data['company'] = this.company!.toJson();
    }
    data['title'] = this.title;
    data['phone_no'] = this.phoneNo;
    data['mailing_address'] = this.mailingAddress;
    data['assistant_name'] = this.assistantName;
    data['assistant_email'] = this.assistantEmail;
    data['assistant_phone_no'] = this.assistantPhoneNo;
    data['subscription_id'] = this.subscriptionId;
    data['subscription_type'] = this.subscriptionType;
    data['subscription_start_date'] = this.subscriptionStartDate;
    data['app_user_status'] = this.appUserStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['facebook_id'] = this.facebookId;
    data['google_id'] = this.googleId;
    data['linkedin_id'] = this.linkedinId;
    return data;
  }
}

class Company {
  int? companyId;
  String? companyName;

  Company({this.companyId, this.companyName});

  Company.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    companyName = json['company_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId;
    data['company_name'] = this.companyName;
    return data;
  }
}

