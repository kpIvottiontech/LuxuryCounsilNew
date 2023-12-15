/// data : {}
/// status : true
/// message : "Not Found"

class NotificationListResponse {
  NotificationListResponse({
      dynamic data, 
      bool? status, 
      String? message,}){
    _data = data;
    _status = status;
    _message = message;
}

  NotificationListResponse.fromJson(dynamic json) {
    _data = json['data'];
    _status = json['status'];
    _message = json['message'];
  }
  dynamic _data;
  bool? _status;
  String? _message;
NotificationListResponse copyWith({  dynamic data,
  bool? status,
  String? message,
}) => NotificationListResponse(  data: data ?? _data,
  status: status ?? _status,
  message: message ?? _message,
);
  dynamic get data => _data;
  bool? get status => _status;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['data'] = _data;
    map['status'] = _status;
    map['message'] = _message;
    return map;
  }

}