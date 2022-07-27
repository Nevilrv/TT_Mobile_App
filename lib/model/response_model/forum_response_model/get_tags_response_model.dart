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
    this.id,
    this.title,
  });

  String? id;
  String? title;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}
