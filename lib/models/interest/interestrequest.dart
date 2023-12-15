class InterestRequest {
  int? page;
  int? limit;

  InterestRequest({
    this.page,
    this.limit,
  });

  InterestRequest.fromJson(dynamic json) {
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




