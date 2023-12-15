

class CategorieModel {
  int? categoryId;
  String? categoryName;
  int? categoryStatus;

  CategorieModel({this.categoryId, this.categoryName, this.categoryStatus});

  CategorieModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    categoryStatus = json['category_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['category_status'] = this.categoryStatus;
    return data;
  }
}
