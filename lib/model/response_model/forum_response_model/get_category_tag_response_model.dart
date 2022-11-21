// To parse this JSON data, do
//
//     final getCategoryTagResponseModel = getCategoryTagResponseModelFromJson(jsonString);

import 'dart:convert';

GetCategoryTagResponseModel getCategoryTagResponseModelFromJson(String str) =>
    GetCategoryTagResponseModel.fromJson(json.decode(str));

String getCategoryTagResponseModelToJson(GetCategoryTagResponseModel data) =>
    json.encode(data.toJson());

class GetCategoryTagResponseModel {
  GetCategoryTagResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<Datum>? data;

  factory GetCategoryTagResponseModel.fromJson(Map<String, dynamic> json) =>
      GetCategoryTagResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.tagId,
    this.tagTitle,
  });

  String? tagId;
  String? tagTitle;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        tagId: json["tag_id"],
        tagTitle: json["tag_title"],
      );

  Map<String, dynamic> toJson() => {
        "tag_id": tagId,
        "tag_title": tagTitle,
      };
}
