// To parse this JSON data, do
//
//     final experienceLevelResModel = experienceLevelResModelFromJson(jsonString);

import 'dart:convert';

ExperienceLevelResModel experienceLevelResModelFromJson(String str) =>
    ExperienceLevelResModel.fromJson(json.decode(str));

String experienceLevelResModelToJson(ExperienceLevelResModel data) =>
    json.encode(data.toJson());

class ExperienceLevelResModel {
  ExperienceLevelResModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<Datum>? data;

  factory ExperienceLevelResModel.fromJson(Map<String, dynamic> json) =>
      ExperienceLevelResModel(
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
    this.title,
    this.slug,
    this.description,
  });

  String? title;
  String? slug;
  String? description;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        title: json["title"],
        slug: json["slug"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "slug": slug,
        "description": description,
      };
}
