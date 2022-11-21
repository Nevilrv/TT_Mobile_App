// To parse this JSON data, do
//
//     final getAllForumCategoryResponseModel = getAllForumCategoryResponseModelFromJson(jsonString);

import 'dart:convert';

GetAllForumCategoryResponseModel getAllForumCategoryResponseModelFromJson(
        String str) =>
    GetAllForumCategoryResponseModel.fromJson(json.decode(str));

String getAllForumCategoryResponseModelToJson(
        GetAllForumCategoryResponseModel data) =>
    json.encode(data.toJson());

class GetAllForumCategoryResponseModel {
  GetAllForumCategoryResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<Category>? data;

  factory GetAllForumCategoryResponseModel.fromJson(
          Map<String, dynamic> json) =>
      GetAllForumCategoryResponseModel(
        success: json["success"],
        msg: json["msg"],
        data:
            List<Category>.from(json["data"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Category {
  Category({
    this.categoryId,
    this.categoryTitle,
    this.categoryImage,
  });

  String? categoryId;
  String? categoryTitle;
  dynamic categoryImage;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json["category_id"],
        categoryTitle: json["category_title"],
        categoryImage: json["category_image"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "category_title": categoryTitle,
        "category_image": categoryImage,
      };
}

class CategoryImageClass {
  CategoryImageClass({
    this.categoryImage,
  });

  List<String>? categoryImage;

  factory CategoryImageClass.fromJson(Map<String, dynamic> json) =>
      CategoryImageClass(
        categoryImage: List<String>.from(json["category_image"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "category_image": List<dynamic>.from(categoryImage!.map((x) => x)),
      };
}
