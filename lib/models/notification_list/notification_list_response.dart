/// data : [{"notification_history_id":447,"article_id":880,"app_user_id":42,"artical":{"article_id":880,"subscription_level":"[\"3\"]","company_id":"[]","category_id":"[\"10\"]","industry_id":"[]","article_name":"qa_1231","search_text":"qa_1231","artical_short_desc":"asdasdasdsad","artical_long_desc":"<p>sadsadsadd</p>","visiable_after_days":null,"media_selection":"Article","image":[{"imageurl":"https://shopsecured.com/luxury_app/public/image/887127.png"}],"youtube_url":"","audio":"","resource":"","interest_id":"[\"0\"]","publisher":"Artnet","publish_date":"2023-10-31","thumbnail_image":"https://shopsecured.com/luxury_app/public/thumbnail_image/727913.png","deleted_at":null,"is_favorite":0}},{"notification_history_id":439,"article_id":879,"app_user_id":42,"artical":{"article_id":879,"subscription_level":"[\"3\"]","company_id":"[]","category_id":"[\"10\"]","industry_id":"[]","article_name":"qa_11111","search_text":"qa_11111","artical_short_desc":"adads","artical_long_desc":"<p>sasdsfd</p>","visiable_after_days":null,"media_selection":"Article","image":[{"imageurl":"https://shopsecured.com/luxury_app/public/image/591798.png"}],"youtube_url":"","audio":"","resource":"","interest_id":"[\"0\"]","publisher":"Artnet","publish_date":"2023-10-31","thumbnail_image":"https://shopsecured.com/luxury_app/public/thumbnail_image/591242.png","deleted_at":null,"is_favorite":0}}]
/// status : true
/// message : "Notification Histories List"

class NotificationListResponse {
  NotificationListResponse({
      List<Data>? data, 
      bool? status, 
      String? message,}){
    _data = data;
    _status = status;
    _message = message;
}

  NotificationListResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _status = json['status'];
    _message = json['message'];
  }
  List<Data>? _data;
  bool? _status;
  String? _message;
NotificationListResponse copyWith({  List<Data>? data,
  bool? status,
  String? message,
}) => NotificationListResponse(  data: data ?? _data,
  status: status ?? _status,
  message: message ?? _message,
);
  List<Data>? get data => _data;
  bool? get status => _status;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['status'] = _status;
    map['message'] = _message;
    return map;
  }

}

/// notification_history_id : 447
/// article_id : 880
/// app_user_id : 42
/// artical : {"article_id":880,"subscription_level":"[\"3\"]","company_id":"[]","category_id":"[\"10\"]","industry_id":"[]","article_name":"qa_1231","search_text":"qa_1231","artical_short_desc":"asdasdasdsad","artical_long_desc":"<p>sadsadsadd</p>","visiable_after_days":null,"media_selection":"Article","image":[{"imageurl":"https://shopsecured.com/luxury_app/public/image/887127.png"}],"youtube_url":"","audio":"","resource":"","interest_id":"[\"0\"]","publisher":"Artnet","publish_date":"2023-10-31","thumbnail_image":"https://shopsecured.com/luxury_app/public/thumbnail_image/727913.png","deleted_at":null,"is_favorite":0}

class Data {
  Data({
      num? notificationHistoryId, 
      num? articleId, 
      num? appUserId, 
      Artical? artical,}){
    _notificationHistoryId = notificationHistoryId;
    _articleId = articleId;
    _appUserId = appUserId;
    _artical = artical;
}

  Data.fromJson(dynamic json) {
    _notificationHistoryId = json['notification_history_id'];
    _articleId = json['article_id'];
    _appUserId = json['app_user_id'];
    _artical = json['artical'] != null ? Artical.fromJson(json['artical']) : null;
  }
  num? _notificationHistoryId;
  num? _articleId;
  num? _appUserId;
  Artical? _artical;
Data copyWith({  num? notificationHistoryId,
  num? articleId,
  num? appUserId,
  Artical? artical,
}) => Data(  notificationHistoryId: notificationHistoryId ?? _notificationHistoryId,
  articleId: articleId ?? _articleId,
  appUserId: appUserId ?? _appUserId,
  artical: artical ?? _artical,
);
  num? get notificationHistoryId => _notificationHistoryId;
  num? get articleId => _articleId;
  num? get appUserId => _appUserId;
  Artical? get artical => _artical;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['notification_history_id'] = _notificationHistoryId;
    map['article_id'] = _articleId;
    map['app_user_id'] = _appUserId;
    if (_artical != null) {
      map['artical'] = _artical?.toJson();
    }
    return map;
  }

}

/// article_id : 880
/// subscription_level : "[\"3\"]"
/// company_id : "[]"
/// category_id : "[\"10\"]"
/// industry_id : "[]"
/// article_name : "qa_1231"
/// search_text : "qa_1231"
/// artical_short_desc : "asdasdasdsad"
/// artical_long_desc : "<p>sadsadsadd</p>"
/// visiable_after_days : null
/// media_selection : "Article"
/// image : [{"imageurl":"https://shopsecured.com/luxury_app/public/image/887127.png"}]
/// youtube_url : ""
/// audio : ""
/// resource : ""
/// interest_id : "[\"0\"]"
/// publisher : "Artnet"
/// publish_date : "2023-10-31"
/// thumbnail_image : "https://shopsecured.com/luxury_app/public/thumbnail_image/727913.png"
/// deleted_at : null
/// is_favorite : 0

class Artical {
  Artical({
      num? articleId, 
      String? subscriptionLevel, 
      String? companyId, 
      String? categoryId, 
      String? industryId, 
      String? articleName, 
      String? searchText, 
      String? articalShortDesc, 
      String? articalLongDesc, 
      dynamic visiableAfterDays, 
      String? mediaSelection, 
      List<Image>? image, 
      String? youtubeUrl, 
      String? audio, 
      String? resource, 
      String? interestId, 
      String? publisher, 
      String? publishDate, 
      String? thumbnailImage, 
      dynamic deletedAt, 
      num? isFavorite,}){
    _articleId = articleId;
    _subscriptionLevel = subscriptionLevel;
    _companyId = companyId;
    _categoryId = categoryId;
    _industryId = industryId;
    _articleName = articleName;
    _searchText = searchText;
    _articalShortDesc = articalShortDesc;
    _articalLongDesc = articalLongDesc;
    _visiableAfterDays = visiableAfterDays;
    _mediaSelection = mediaSelection;
    _image = image;
    _youtubeUrl = youtubeUrl;
    _audio = audio;
    _resource = resource;
    _interestId = interestId;
    _publisher = publisher;
    _publishDate = publishDate;
    _thumbnailImage = thumbnailImage;
    _deletedAt = deletedAt;
    _isFavorite = isFavorite;
}

  Artical.fromJson(dynamic json) {
    _articleId = json['article_id'];
    _subscriptionLevel = json['subscription_level'];
    _companyId = json['company_id'];
    _categoryId = json['category_id'];
    _industryId = json['industry_id'];
    _articleName = json['article_name'];
    _searchText = json['search_text'];
    _articalShortDesc = json['artical_short_desc'];
    _articalLongDesc = json['artical_long_desc'];
    _visiableAfterDays = json['visiable_after_days'];
    _mediaSelection = json['media_selection'];
    if (json['image'] != null) {
      _image = [];
      json['image'].forEach((v) {
        _image?.add(Image.fromJson(v));
      });
    }
    _youtubeUrl = json['youtube_url'];
    _audio = json['audio'];
    _resource = json['resource'];
    _interestId = json['interest_id'];
    _publisher = json['publisher'];
    _publishDate = json['publish_date'];
    _thumbnailImage = json['thumbnail_image'];
    _deletedAt = json['deleted_at'];
    _isFavorite = json['is_favorite'];
  }
  num? _articleId;
  String? _subscriptionLevel;
  String? _companyId;
  String? _categoryId;
  String? _industryId;
  String? _articleName;
  String? _searchText;
  String? _articalShortDesc;
  String? _articalLongDesc;
  dynamic _visiableAfterDays;
  String? _mediaSelection;
  List<Image>? _image;
  String? _youtubeUrl;
  String? _audio;
  String? _resource;
  String? _interestId;
  String? _publisher;
  String? _publishDate;
  String? _thumbnailImage;
  dynamic _deletedAt;
  num? _isFavorite;
Artical copyWith({  num? articleId,
  String? subscriptionLevel,
  String? companyId,
  String? categoryId,
  String? industryId,
  String? articleName,
  String? searchText,
  String? articalShortDesc,
  String? articalLongDesc,
  dynamic visiableAfterDays,
  String? mediaSelection,
  List<Image>? image,
  String? youtubeUrl,
  String? audio,
  String? resource,
  String? interestId,
  String? publisher,
  String? publishDate,
  String? thumbnailImage,
  dynamic deletedAt,
  num? isFavorite,
}) => Artical(  articleId: articleId ?? _articleId,
  subscriptionLevel: subscriptionLevel ?? _subscriptionLevel,
  companyId: companyId ?? _companyId,
  categoryId: categoryId ?? _categoryId,
  industryId: industryId ?? _industryId,
  articleName: articleName ?? _articleName,
  searchText: searchText ?? _searchText,
  articalShortDesc: articalShortDesc ?? _articalShortDesc,
  articalLongDesc: articalLongDesc ?? _articalLongDesc,
  visiableAfterDays: visiableAfterDays ?? _visiableAfterDays,
  mediaSelection: mediaSelection ?? _mediaSelection,
  image: image ?? _image,
  youtubeUrl: youtubeUrl ?? _youtubeUrl,
  audio: audio ?? _audio,
  resource: resource ?? _resource,
  interestId: interestId ?? _interestId,
  publisher: publisher ?? _publisher,
  publishDate: publishDate ?? _publishDate,
  thumbnailImage: thumbnailImage ?? _thumbnailImage,
  deletedAt: deletedAt ?? _deletedAt,
  isFavorite: isFavorite ?? _isFavorite,
);
  num? get articleId => _articleId;
  String? get subscriptionLevel => _subscriptionLevel;
  String? get companyId => _companyId;
  String? get categoryId => _categoryId;
  String? get industryId => _industryId;
  String? get articleName => _articleName;
  String? get searchText => _searchText;
  String? get articalShortDesc => _articalShortDesc;
  String? get articalLongDesc => _articalLongDesc;
  dynamic get visiableAfterDays => _visiableAfterDays;
  String? get mediaSelection => _mediaSelection;
  List<Image>? get image => _image;
  String? get youtubeUrl => _youtubeUrl;
  String? get audio => _audio;
  String? get resource => _resource;
  String? get interestId => _interestId;
  String? get publisher => _publisher;
  String? get publishDate => _publishDate;
  String? get thumbnailImage => _thumbnailImage;
  dynamic get deletedAt => _deletedAt;
  num? get isFavorite => _isFavorite;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['article_id'] = _articleId;
    map['subscription_level'] = _subscriptionLevel;
    map['company_id'] = _companyId;
    map['category_id'] = _categoryId;
    map['industry_id'] = _industryId;
    map['article_name'] = _articleName;
    map['search_text'] = _searchText;
    map['artical_short_desc'] = _articalShortDesc;
    map['artical_long_desc'] = _articalLongDesc;
    map['visiable_after_days'] = _visiableAfterDays;
    map['media_selection'] = _mediaSelection;
    if (_image != null) {
      map['image'] = _image?.map((v) => v.toJson()).toList();
    }
    map['youtube_url'] = _youtubeUrl;
    map['audio'] = _audio;
    map['resource'] = _resource;
    map['interest_id'] = _interestId;
    map['publisher'] = _publisher;
    map['publish_date'] = _publishDate;
    map['thumbnail_image'] = _thumbnailImage;
    map['deleted_at'] = _deletedAt;
    map['is_favorite'] = _isFavorite;
    return map;
  }

}

/// imageurl : "https://shopsecured.com/luxury_app/public/image/887127.png"

class Image {
  Image({
      String? imageurl,}){
    _imageurl = imageurl;
}

  Image.fromJson(dynamic json) {
    _imageurl = json['imageurl'];
  }
  String? _imageurl;
Image copyWith({  String? imageurl,
}) => Image(  imageurl: imageurl ?? _imageurl,
);
  String? get imageurl => _imageurl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['imageurl'] = _imageurl;
    return map;
  }

}