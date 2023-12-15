class EventListModel {
  int? eventId;
  String? eventName;
  String? eventDate;
  String? eventDetail;
  String? hashTags;
  int? eventStatus;

  EventListModel(
      {this.eventId,
      this.eventName,
      this.eventDate,
      this.eventDetail,
      this.hashTags,
      this.eventStatus});

  EventListModel.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    eventName = json['event_name'];
    eventDate = json['event_date'];
    eventDetail = json['event_detail'];
    hashTags = json['hash_tags'];
    eventStatus = json['event_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_id'] = this.eventId;
    data['event_name'] = this.eventName;
    data['event_date'] = this.eventDate;
    data['event_detail'] = this.eventDetail;
    data['hash_tags'] = this.hashTags;
    data['event_status'] = this.eventStatus;
    return data;
  }
}
