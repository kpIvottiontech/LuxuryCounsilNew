
class SpotlightListingModel {
  Data? data;
  bool? status;
  String? message;

  SpotlightListingModel({this.data, this.status, this.message});

  SpotlightListingModel.fromJson(Map<String, dynamic> json) {

    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  List<SpotlightData>? items;
  int? totalPage;

  Data({this.items, this.totalPage});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <SpotlightData>[];
      json['items'].forEach((v) {
        items!.add(new SpotlightData.fromJson(v));
      });
    }
    totalPage = json['total_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['total_page'] = this.totalPage;
    return data;
  }
}

class SpotlightData {
  int? spotlightMemberId;
  String? spotlightMemberCompanyLogo;
  String? spotlightMemberCompanyShortDescription;
  String? spotlightMemberCompanyLongDescription;
  String? spotlightMemberContactEmail;
  String? spotlightMemberContactName;
  int? spotlightMemberStatus;
  String? spotlightMemberCompanyLogoLink;

  SpotlightData(
      {this.spotlightMemberId,
        this.spotlightMemberCompanyLogo,
        this.spotlightMemberCompanyShortDescription,
        this.spotlightMemberCompanyLongDescription,
        this.spotlightMemberContactEmail,
        this.spotlightMemberContactName,
        this.spotlightMemberStatus,
        this.spotlightMemberCompanyLogoLink});

  SpotlightData.fromJson(Map<String, dynamic> json) {
    spotlightMemberId = json['spotlight_member_id'];
    spotlightMemberCompanyLogo = json['spotlight_member_company_logo'];
    spotlightMemberCompanyShortDescription =
    json['spotlight_member_company_short_description'];
    spotlightMemberCompanyLongDescription =
    json['spotlight_member_company_long_description'];
    spotlightMemberContactEmail = json['spotlight_member_contact_email'];
    spotlightMemberContactName = json['spotlight_member_contact_name'];
    spotlightMemberStatus = json['spotlight_member_status'];
    spotlightMemberCompanyLogoLink = json['spotlight_member_company_logo_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spotlight_member_id'] = this.spotlightMemberId;
    data['spotlight_member_company_logo'] = this.spotlightMemberCompanyLogo;
    data['spotlight_member_company_short_description'] =
        this.spotlightMemberCompanyShortDescription;
    data['spotlight_member_company_long_description'] =
        this.spotlightMemberCompanyLongDescription;
    data['spotlight_member_contact_email'] = this.spotlightMemberContactEmail;
    data['spotlight_member_contact_name'] = this.spotlightMemberContactName;
    data['spotlight_member_status'] = this.spotlightMemberStatus;
    data['spotlight_member_company_logo_link'] =
        this.spotlightMemberCompanyLogoLink;
    return data;
  }
}
