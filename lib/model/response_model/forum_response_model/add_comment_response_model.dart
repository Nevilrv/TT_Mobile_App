// To parse this JSON data, do
//
//     final addCommentResponseModel = addCommentResponseModelFromJson(jsonString);

import 'dart:convert';

AddCommentResponseModel addCommentResponseModelFromJson(String str) =>
    AddCommentResponseModel.fromJson(json.decode(str));

String addCommentResponseModelToJson(AddCommentResponseModel data) =>
    json.encode(data.toJson());

class AddCommentResponseModel {
  AddCommentResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<Datum>? data;

  factory AddCommentResponseModel.fromJson(Map<String, dynamic> json) =>
      AddCommentResponseModel(
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
    this.postId,
    this.userId,
    this.comment,
    this.createdAt,
  });

  String? id;
  String? postId;
  String? userId;
  String? comment;
  DateTime? createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        postId: json["post_id"],
        userId: json["user_id"],
        comment: json["comment"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "post_id": postId,
        "user_id": userId,
        "comment": comment,
        "created_at": createdAt!.toIso8601String(),
      };
}
