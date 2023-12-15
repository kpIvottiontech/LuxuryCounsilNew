class CategorieRequest {
  int? page;
  int? limit;

  CategorieRequest({
    this.page,
    this.limit,
  });

  CategorieRequest.fromJson(dynamic json) {
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




