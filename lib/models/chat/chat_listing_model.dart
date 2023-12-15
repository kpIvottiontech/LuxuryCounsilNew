/// data : {"items":[{"app_user_id":45,"first_name":"a1@a1.com","last_name":"a1@a1.com","email":"a1@a1.com","subscription_id":5,"profile_img":"","subscription_expired":1,"profile_img_url":""},{"app_user_id":180,"first_name":"aditya","last_name":"qa","email":"shrtsg22677772@e.com","subscription_id":3,"profile_img":"","subscription_expired":1,"profile_img_url":""},{"app_user_id":27,"first_name":"Christopher","last_name":"Olshan","email":"colshan@luxurycouncil.com","subscription_id":5,"profile_img":"","subscription_expired":1,"profile_img_url":""},{"app_user_id":125,"first_name":"dd","last_name":"ff","email":"df@gmail.com","subscription_id":3,"profile_img":"","subscription_expired":1,"profile_img_url":""},{"app_user_id":48,"first_name":"first","last_name":"sec","email":"q1@q1.com","subscription_id":5,"profile_img":"","subscription_expired":1,"profile_img_url":""},{"app_user_id":170,"first_name":"four","last_name":"user","email":"four.user@mailinator.com","subscription_id":5,"profile_img":"","subscription_expired":1,"profile_img_url":""},{"app_user_id":207,"first_name":"hh","last_name":"jj","email":"hj@gmail.com","subscription_id":5,"profile_img":"","subscription_expired":1,"profile_img_url":""},{"app_user_id":55,"first_name":"I","last_name":"V","email":"I@V1.com","subscription_id":3,"profile_img":"","subscription_expired":1,"profile_img_url":""},{"app_user_id":57,"first_name":"I1","last_name":"V1","email":"I1@V1.com1","subscription_id":3,"profile_img":"","subscription_expired":1,"profile_img_url":""},{"app_user_id":153,"first_name":"Import user","last_name":"Import user Last name","email":"k1@k1.com","subscription_id":4,"profile_img":"","subscription_expired":1,"profile_img_url":""}],"total_page":4,"total":37}
/// status : true
/// message : "Chat User List"

class ChatListingModel {
  ChatListingModel({
      Data? data,
      bool? status,
      String? message,}){
    _data = data;
    _status = status;
    _message = message;
}

  ChatListingModel.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _status = json['status'];
    _message = json['message'];
  }
  Data? _data;
  bool? _status;
  String? _message;
ChatListingModel copyWith({  Data? data,
  bool? status,
  String? message,
}) => ChatListingModel(  data: data ?? _data,
  status: status ?? _status,
  message: message ?? _message,
);
  Data? get data => _data;
  bool? get status => _status;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['status'] = _status;
    map['message'] = _message;
    return map;
  }

}

/// items : [{"app_user_id":45,"first_name":"a1@a1.com","last_name":"a1@a1.com","email":"a1@a1.com","subscription_id":5,"profile_img":"","subscription_expired":1,"profile_img_url":""},{"app_user_id":180,"first_name":"aditya","last_name":"qa","email":"shrtsg22677772@e.com","subscription_id":3,"profile_img":"","subscription_expired":1,"profile_img_url":""},{"app_user_id":27,"first_name":"Christopher","last_name":"Olshan","email":"colshan@luxurycouncil.com","subscription_id":5,"profile_img":"","subscription_expired":1,"profile_img_url":""},{"app_user_id":125,"first_name":"dd","last_name":"ff","email":"df@gmail.com","subscription_id":3,"profile_img":"","subscription_expired":1,"profile_img_url":""},{"app_user_id":48,"first_name":"first","last_name":"sec","email":"q1@q1.com","subscription_id":5,"profile_img":"","subscription_expired":1,"profile_img_url":""},{"app_user_id":170,"first_name":"four","last_name":"user","email":"four.user@mailinator.com","subscription_id":5,"profile_img":"","subscription_expired":1,"profile_img_url":""},{"app_user_id":207,"first_name":"hh","last_name":"jj","email":"hj@gmail.com","subscription_id":5,"profile_img":"","subscription_expired":1,"profile_img_url":""},{"app_user_id":55,"first_name":"I","last_name":"V","email":"I@V1.com","subscription_id":3,"profile_img":"","subscription_expired":1,"profile_img_url":""},{"app_user_id":57,"first_name":"I1","last_name":"V1","email":"I1@V1.com1","subscription_id":3,"profile_img":"","subscription_expired":1,"profile_img_url":""},{"app_user_id":153,"first_name":"Import user","last_name":"Import user Last name","email":"k1@k1.com","subscription_id":4,"profile_img":"","subscription_expired":1,"profile_img_url":""}]
/// total_page : 4
/// total : 37

class Data {
  Data({
      List<ChatItems>? items,
      num? totalPage,
      num? total,}){
    _items = items;
    _totalPage = totalPage;
    _total = total;
}

  Data.fromJson(dynamic json) {
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(ChatItems.fromJson(v));
      });
    }
    _totalPage = json['total_page'];
    _total = json['total'];
  }
  List<ChatItems>? _items;
  num? _totalPage;
  num? _total;
Data copyWith({  List<ChatItems>? items,
  num? totalPage,
  num? total,
}) => Data(  items: items ?? _items,
  totalPage: totalPage ?? _totalPage,
  total: total ?? _total,
);
  List<ChatItems>? get items => _items;
  num? get totalPage => _totalPage;
  num? get total => _total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    map['total_page'] = _totalPage;
    map['total'] = _total;
    return map;
  }

}

/// app_user_id : 45
/// first_name : "a1@a1.com"
/// last_name : "a1@a1.com"
/// email : "a1@a1.com"
/// subscription_id : 5
/// profile_img : ""
/// subscription_expired : 1
/// profile_img_url : ""

class ChatItems {
  ChatItems({
      num? appUserId,
      String? firstName,
      String? lastName,
      String? email,
      num? subscriptionId,
      String? profileImg,
      num? subscriptionExpired,
      String? profileImgUrl,}){
    _appUserId = appUserId;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _subscriptionId = subscriptionId;
    _profileImg = profileImg;
    _subscriptionExpired = subscriptionExpired;
    _profileImgUrl = profileImgUrl;
}

  ChatItems.fromJson(dynamic json) {
    _appUserId = json['app_user_id'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _email = json['email'];
    _subscriptionId = json['subscription_id'];
    _profileImg = json['profile_img'];
    _subscriptionExpired = json['subscription_expired'];
    _profileImgUrl = json['profile_img_url'];
  }
  num? _appUserId;
  String? _firstName;
  String? _lastName;
  String? _email;
  num? _subscriptionId;
  String? _profileImg;
  num? _subscriptionExpired;
  String? _profileImgUrl;
ChatItems copyWith({  num? appUserId,
  String? firstName,
  String? lastName,
  String? email,
  num? subscriptionId,
  String? profileImg,
  num? subscriptionExpired,
  String? profileImgUrl,
}) => ChatItems(  appUserId: appUserId ?? _appUserId,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  email: email ?? _email,
  subscriptionId: subscriptionId ?? _subscriptionId,
  profileImg: profileImg ?? _profileImg,
  subscriptionExpired: subscriptionExpired ?? _subscriptionExpired,
  profileImgUrl: profileImgUrl ?? _profileImgUrl,
);
  num? get appUserId => _appUserId;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  num? get subscriptionId => _subscriptionId;
  String? get profileImg => _profileImg;
  num? get subscriptionExpired => _subscriptionExpired;
  String? get profileImgUrl => _profileImgUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['app_user_id'] = _appUserId;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['email'] = _email;
    map['subscription_id'] = _subscriptionId;
    map['profile_img'] = _profileImg;
    map['subscription_expired'] = _subscriptionExpired;
    map['profile_img_url'] = _profileImgUrl;
    return map;
  }

}