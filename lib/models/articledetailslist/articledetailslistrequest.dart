class ArticleDetailsListRequest {
  int? articleid;

  ArticleDetailsListRequest(
      {
      this.articleid,
      });

  ArticleDetailsListRequest.fromJson(Map<String, dynamic> json) {
    articleid = json['article_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['article_id'] = this.articleid;
    return data;
  }
}
