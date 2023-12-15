
class CompanyListModel {
  int? companyId;
  String? companyName;
  int? companyStatus;

  CompanyListModel({this.companyId, this.companyName, this.companyStatus});

  CompanyListModel.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    companyName = json['company_name'];
    companyStatus = json['company_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company_id'] = this.companyId;
    data['company_name'] = this.companyName;
    data['company_status'] = this.companyStatus;
    return data;
  }
}
