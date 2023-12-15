class OwnerJobCategories {
  String? jobIdRef;
  String? jobCategoryIdRef;
  String? jobCategoryName;
  dynamic jobCategoryIds;
  String? id;
  String? createdBy;
  dynamic updatedBy;
  String? createdOn;
  dynamic updatedOn;
 
  OwnerJobCategories({
    this.jobIdRef,
    this.jobCategoryIdRef,
    this.jobCategoryName,
    this.jobCategoryIds,
    this.id,
    this.createdBy,
    this.updatedBy,
    this.createdOn,
    this.updatedOn,
  });

  OwnerJobCategories.fromJson(dynamic json) {
    jobIdRef = json['jobIdRef'];
    jobCategoryIdRef = json['jobCategoryIdRef'];
    jobCategoryName = json['jobCategoryName'];
    jobCategoryIds = json['jobCategoryIds'];
    id = json['id'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['jobIdRef'] = jobIdRef;
    map['jobCategoryIdRef'] = jobCategoryIdRef;
    map['jobCategoryName'] = jobCategoryName;
    map['jobCategoryIds'] = jobCategoryIds;
    map['id'] = id;
    map['createdBy'] = createdBy;
    map['updatedBy'] = updatedBy;
    map['createdOn'] = createdOn;
    map['updatedOn'] = updatedOn;
    return map;
  }
}


