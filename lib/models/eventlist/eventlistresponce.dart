import 'package:luxury_council/models/eventlist/eventlistmodel.dart';

class EventListResponce {
  List<EventListModel>? eventlistModel;
  bool? status;
  String? message;

  EventListResponce({this.eventlistModel, this.status, this.message});

  EventListResponce.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      eventlistModel = <EventListModel>[];
      json['data'].forEach((v) {
        eventlistModel!.add(new EventListModel.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.eventlistModel != null) {
      data['data'] = this.eventlistModel!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}