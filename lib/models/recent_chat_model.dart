/// data : [{"app_user_id":229,"profile_img":"1702038427.png","first_name":"Test","last_name":"sarjen","subscription_expired":1,"profile_img_url":"https://shopsecured.com/luxury_app/public/profile_image/1702038427.png"}]
/// status : true
/// message : "Profile Images."

class RecentChatModel {
  RecentChatModel({
      List<RecentChatData>? data,
      bool? status, 
      String? message,}){
    _data = data;
    _status = status;
    _message = message;
}

  RecentChatModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(RecentChatData.fromJson(v));
      });
    }
    _status = json['status'];
    _message = json['message'];
  }
  List<RecentChatData>? _data;
  bool? _status;
  String? _message;
RecentChatModel copyWith({  List<RecentChatData>? data,
  bool? status,
  String? message,
}) => RecentChatModel(  data: data ?? _data,
  status: status ?? _status,
  message: message ?? _message,
);
  List<RecentChatData>? get data => _data;
  bool? get status => _status;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['status'] = _status;
    map['message'] = _message;
    return map;
  }

}

/// app_user_id : 229
/// profile_img : "1702038427.png"
/// first_name : "Test"
/// last_name : "sarjen"
/// subscription_expired : 1
/// profile_img_url : "https://shopsecured.com/luxury_app/public/profile_image/1702038427.png"

class RecentChatData {
  RecentChatData({
      num? appUserId, 
      String? profileImg, 
      String? firstName, 
      String? lastName, 
      num? subscriptionExpired, 
      String? profileImgUrl,}){
    _appUserId = appUserId;
    _profileImg = profileImg;
    _firstName = firstName;
    _lastName = lastName;
    _subscriptionExpired = subscriptionExpired;
    _profileImgUrl = profileImgUrl;
}

  RecentChatData.fromJson(dynamic json) {
    _appUserId = json['app_user_id'];
    _profileImg = json['profile_img'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _subscriptionExpired = json['subscription_expired'];
    _profileImgUrl = json['profile_img_url'];
  }
  num? _appUserId;
  String? _profileImg;
  String? _firstName;
  String? _lastName;
  num? _subscriptionExpired;
  String? _profileImgUrl;
RecentChatData copyWith({  num? appUserId,
  String? profileImg,
  String? firstName,
  String? lastName,
  num? subscriptionExpired,
  String? profileImgUrl,
}) => RecentChatData(  appUserId: appUserId ?? _appUserId,
  profileImg: profileImg ?? _profileImg,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  subscriptionExpired: subscriptionExpired ?? _subscriptionExpired,
  profileImgUrl: profileImgUrl ?? _profileImgUrl,
);
  num? get appUserId => _appUserId;
  String? get profileImg => _profileImg;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  num? get subscriptionExpired => _subscriptionExpired;
  String? get profileImgUrl => _profileImgUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['app_user_id'] = _appUserId;
    map['profile_img'] = _profileImg;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['subscription_expired'] = _subscriptionExpired;
    map['profile_img_url'] = _profileImgUrl;
    return map;
  }

}