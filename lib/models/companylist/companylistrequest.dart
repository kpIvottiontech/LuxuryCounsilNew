class CompanylistRequest {
  int? page;
  int? limit;

  CompanylistRequest({
    this.page,
    this.limit,
  });

  CompanylistRequest.fromJson(dynamic json) {
    page = json['page'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['page'] = page;
    map['limit'] = limit;

    return map;
  }
}




