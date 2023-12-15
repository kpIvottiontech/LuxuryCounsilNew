class ArticleListRequest {
  int? page;
  int? limit;
  String? searchText;
  String? searchCategory;
  String? searchMedia;
  String? searchInterest;

  ArticleListRequest(
      {this.page,
      this.limit,
      this.searchText,
      this.searchCategory,
      this.searchMedia,
      this.searchInterest});

  ArticleListRequest.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    searchText = json['search_text'];
    searchCategory = json['search_category'];
    searchMedia = json['search_media'];
    searchInterest = json['search_interest'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['search_text'] = this.searchText;
    data['search_category'] = this.searchCategory;
    data['search_media'] = this.searchMedia;
    data['search_interest'] = this.searchInterest;
    return data;
  }
}
