class EventDetailsListRequest {
  int? eventid;

  EventDetailsListRequest(
      {
      this.eventid,
      });

  EventDetailsListRequest.fromJson(Map<String, dynamic> json) {
    eventid = json['event_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_id'] = this.eventid;
    return data;
  }
}
