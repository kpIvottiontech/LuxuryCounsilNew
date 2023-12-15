// import 'package:luxury_council/models/articledetailslist/articledetailslistmodel.dart';

// class ArticleDetailsListResponce {
//   List<ArticleDetailsListModel>? articleDetailsListModel;
//   bool? status;
//   String? message;

//   ArticleDetailsListResponce(
//       {this.articleDetailsListModel, this.status, this.message});

//   ArticleDetailsListResponce.fromJson(Map<String, dynamic> json) {
//     articleDetailsListModel =  <ArticleDetailsListModel>[];
//     status = json['status'];
//     message = json['message'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//      if (data['data'] != null) {
//       articleDetailsListModel = <ArticleDetailsListModel>[];
//       data['data'].forEach((v) {
//         articleDetailsListModel!.add(new ArticleDetailsListModel.fromJson(v));
//       });
//     } 
//     data['status'] = this.status;
//     data['message'] = this.message;
//     return data;
//   }
// }
// // class ArticleDetailsListResponce {
// //   ArticleDetailsListModel? articleDetailsListModel;
// //   bool? status;
// //   String? message;

// //   ArticleDetailsListResponce({this.articleDetailsListModel, this.status, this.message});

// //   ArticleDetailsListResponce.fromJson(Map<String, dynamic> json) {
// //     articleDetailsListModel = json['data'] != null ? new ArticleDetailsListModel.fromJson(json['data']) : null;
// //     status = json['status'];
// //     message = json['message'];
// //   }

// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     if (this.articleDetailsListModel != null) {
// //       data['data'] = this.articleDetailsListModel!.toJson();
// //     }
// //     data['status'] = this.status;
// //     data['message'] = this.message;
// //     return data;
// //   }
// // }
