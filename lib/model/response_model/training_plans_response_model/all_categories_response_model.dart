// To parse this JSON data, do
//
//     final categoriesResponseModel = categoriesResponseModelFromJson(jsonString);

import 'dart:convert';

CategoriesResponseModel categoriesResponseModelFromJson(String str) =>
    CategoriesResponseModel.fromJson(json.decode(str));

String categoriesResponseModelToJson(CategoriesResponseModel data) =>
    json.encode(data.toJson());

class CategoriesResponseModel {
  CategoriesResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<Categories>? data;

  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) =>
      CategoriesResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: List<Categories>.from(
            json["data"].map((x) => Categories.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Categories {
  Categories({
    this.id,
    this.categoryId,
    this.categoryTitle,
    this.categoryImage,
  });

  int? id;
  String? categoryId;
  String? categoryTitle;
  String? categoryImage;

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
        id: json["id"],
        categoryId: json["category_id"],
        categoryTitle: json["category_title"],
        categoryImage: json["category_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "category_title": categoryTitle,
        "category_image": categoryImage,
      };
}
