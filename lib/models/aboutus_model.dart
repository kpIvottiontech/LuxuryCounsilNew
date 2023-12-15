class AboutUsModel {
  AboutUsData? data;
  bool? status;
  String? message;

  AboutUsModel({this.data, this.status, this.message});

  AboutUsModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new AboutUsData.fromJson(json['data']) : null;
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

class AboutUsData {
  String? header;
  String? headerShortDesc;
  String? headerLongDesc;
  String? image;
  int? aboutId;
  List<Testimonials>? testimonials;

  AboutUsData(
      {this.header,
        this.headerShortDesc,
        this.headerLongDesc,
        this.image,
        this.aboutId,
        this.testimonials});

  AboutUsData.fromJson(Map<String, dynamic> json) {
    header = json['header'];
    headerShortDesc = json['header_short_desc'];
    headerLongDesc = json['header_long_desc'];
    image = json['image'];
    aboutId = json['about_id'];
    if (json['testimonials'] != null) {
      testimonials = <Testimonials>[];
      json['testimonials'].forEach((v) {
        testimonials!.add(new Testimonials.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['header'] = this.header;
    data['header_short_desc'] = this.headerShortDesc;
    data['header_long_desc'] = this.headerLongDesc;
    data['image'] = this.image;
    data['about_id'] = this.aboutId;
    if (this.testimonials != null) {
      data['testimonials'] = this.testimonials!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Testimonials {
  String? testimonialsName;
  String? testimonialsTitle;
  String? testimonialsDesc;

  Testimonials(
      {this.testimonialsName, this.testimonialsTitle, this.testimonialsDesc});

  Testimonials.fromJson(Map<String, dynamic> json) {
    testimonialsName = json['testimonials_name'];
    testimonialsTitle = json['testimonials_title'];
    testimonialsDesc = json['testimonials_desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['testimonials_name'] = this.testimonialsName;
    data['testimonials_title'] = this.testimonialsTitle;
    data['testimonials_desc'] = this.testimonialsDesc;
    return data;
  }
}
