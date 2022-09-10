// To parse this JSON data, do
//
//     final deleteForumResponseModel = deleteForumResponseModelFromJson(jsonString);

import 'dart:convert';

DeleteForumResponseModel deleteForumResponseModelFromJson(String str) =>
    DeleteForumResponseModel.fromJson(json.decode(str));

String deleteForumResponseModelToJson(DeleteForumResponseModel data) =>
    json.encode(data.toJson());

class DeleteForumResponseModel {
  DeleteForumResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<dynamic>? data;

  factory DeleteForumResponseModel.fromJson(Map<String, dynamic> json) =>
      DeleteForumResponseModel(
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
