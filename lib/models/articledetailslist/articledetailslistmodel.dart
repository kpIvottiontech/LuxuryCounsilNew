// class ArticleDetailsListModel {
//   int? articleId;
//   String? articleName;
//   List<String>? image;
//   String? mediaSelection;
//   String? articalShortDesc;
//   String? youtubeUrl;
//   String? audio;
//   String? resource;
//   String? publisher;
//   String? publishDate;
//   String? articalLongDesc;

//   ArticleDetailsListModel(
//       {this.articleId,
//       this.articleName,
//       this.image,
//       this.mediaSelection,
//       this.articalShortDesc,
//       this.youtubeUrl,
//       this.audio,
//       this.resource,
//       this.publisher,
//       this.publishDate,
//       this.articalLongDesc});

//   ArticleDetailsListModel.fromJson(Map<String, dynamic> json) {
//     articleId = json['article_id'];
//     articleName = json['article_name'];
//     image = json['image'].cast<String>();
//     mediaSelection = json['media_selection'];
//     articalShortDesc = json['artical_short_desc'];
//     youtubeUrl = json['youtube_url'];
//     audio = json['audio'];
//     resource = json['resource'];
//     publisher = json['publisher'];
//     publishDate = json['publish_date'];
//     articalLongDesc = json['artical_long_desc'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['article_id'] = this.articleId;
//     data['article_name'] = this.articleName;
//     data['image'] = this.image;
//     data['media_selection'] = this.mediaSelection;
//     data['artical_short_desc'] = this.articalShortDesc;
//     data['youtube_url'] = this.youtubeUrl;
//     data['audio'] = this.audio;
//     data['resource'] = this.resource;
//     data['publisher'] = this.publisher;
//     data['publish_date'] = this.publishDate;
//     data['artical_long_desc'] = this.articalLongDesc;
//     return data;
//   }
// }


