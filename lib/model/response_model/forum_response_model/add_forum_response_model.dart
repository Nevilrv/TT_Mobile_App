// To parse this JSON data, do
//
//     final addForumResponseModel = addForumResponseModelFromJson(jsonString);

import 'dart:convert';

AddForumResponseModel addForumResponseModelFromJson(String str) =>
    AddForumResponseModel.fromJson(json.decode(str));

String addForumResponseModelToJson(AddForumResponseModel data) =>
    json.encode(data.toJson());

class AddForumResponseModel {
  AddForumResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<dynamic>? data;

  factory AddForumResponseModel.fromJson(Map<String, dynamic> json) =>
      AddForumResponseModel(
        success: json["success"] == null ? null : json["success"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null
            ? null
            : List<dynamic>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : List<dynamic>.from(data!.map((x) => x)),
      };
}
