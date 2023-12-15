import 'mediatypemodel.dart';

class MediaListResponce {
  List<MediaTypeModel>? mediatypeModel;
  bool? status;
  String? message;

  MediaListResponce({this.mediatypeModel, this.status, this.message});

  MediaListResponce.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      mediatypeModel = <MediaTypeModel>[];
      json['data'].forEach((v) {
        mediatypeModel!.add(new MediaTypeModel.fromJson(v)); 
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mediatypeModel != null) {
      data['data'] = this.mediatypeModel!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
