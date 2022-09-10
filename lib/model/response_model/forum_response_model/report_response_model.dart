// To parse this JSON data, do
//
//     final repostForumResponseModel = repostForumResponseModelFromJson(jsonString);

import 'dart:convert';

ReportForumResponseModel repostForumResponseModelFromJson(String str) =>
    ReportForumResponseModel.fromJson(json.decode(str));

String repostForumResponseModelToJson(ReportForumResponseModel data) =>
    json.encode(data.toJson());

class ReportForumResponseModel {
  ReportForumResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<dynamic>? data;

  factory ReportForumResponseModel.fromJson(Map<String, dynamic> json) =>
      ReportForumResponseModel(
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
