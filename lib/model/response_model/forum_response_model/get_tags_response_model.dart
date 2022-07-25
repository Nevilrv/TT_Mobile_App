// To parse this JSON data, do
//
//     final getTagsResponseModel = getTagsResponseModelFromJson(jsonString);

import 'dart:convert';

GetTagsResponseModel getTagsResponseModelFromJson(String str) =>
    GetTagsResponseModel.fromJson(json.decode(str));

String getTagsResponseModelToJson(GetTagsResponseModel data) =>
    json.encode(data.toJson());

class GetTagsResponseModel {
  GetTagsResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<Datum>? data;

  factory GetTagsResponseModel.fromJson(Map<String, dynamic> json) =>
      GetTagsResponseModel(
        success: json["success"] == null ? null : json["success"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "msg": msg == null ? null : msg,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
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
        tagId: json["tag_id"] == null ? null : json["tag_id"],
        tagTitle: json["tag_title"] == null ? null : json["tag_title"],
      );

  Map<String, dynamic> toJson() => {
        "tag_id": tagId == null ? null : tagId,
        "tag_title": tagTitle == null ? null : tagTitle,
      };
}
