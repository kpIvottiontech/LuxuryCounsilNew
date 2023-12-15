class InterestModel {
  int? interestId;
  String? interestName;
  int? interestStatus;

  InterestModel({this.interestId, this.interestName, this.interestStatus});

  InterestModel.fromJson(Map<String, dynamic> json) {
    interestId = json['interest_id'];
    interestName = json['interest_name'];
    interestStatus = json['interest_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['interest_id'] = this.interestId;
    data['interest_name'] = this.interestName;
    data['interest_status'] = this.interestStatus;
    return data;
  }
}
