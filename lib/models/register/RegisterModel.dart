class RegisterModel {
  bool? status;
  String? message;
  User? user;
  String? token;

  RegisterModel({this.status, this.message, this.user, this.token});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
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

class User {
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? company;
  String? title;
  String? phoneNo;
  String? mailingAddress;
  String? assistantName;
  String? assistantEmail;
  String? assistantPhoneNo;
  String? subscriptionId;
  String? subscriptionType;
  String? subscriptionStartDate;
  String? appUserStatus;
  User({
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
    this.appUserStatus
  });

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    password = json['password'];
    company = json['company'];
    title = json['title'];
    phoneNo = json['phone_no'];
    mailingAddress = json['mailing_address'];
    assistantName = json['assistant_name'];
    assistantEmail = json['assistant_email'];
    assistantPhoneNo = json['assistant_phone_no'];
    subscriptionId = json['subscription_id'];
    subscriptionType = json['subscription_type'];
    subscriptionStartDate = json['subscription_start_date'];
    appUserStatus = json['subscription_start_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['company'] = this.company;
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
    return data;
  }
}
