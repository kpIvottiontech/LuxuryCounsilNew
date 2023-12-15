class MediaTypeModel {
  String? mediaId;
  String? mediaName;
  int? mediaStatus;

  MediaTypeModel({this.mediaId, this.mediaName, this.mediaStatus});

  MediaTypeModel.fromJson(Map<String, dynamic> json) {
    mediaId = json['media_id'];
    mediaName = json['media_name'];
    mediaStatus = json['media_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['media_id'] = this.mediaId;
    data['media_name'] = this.mediaName;
    data['media_status'] = this.mediaStatus;
    return data;
  }
}
