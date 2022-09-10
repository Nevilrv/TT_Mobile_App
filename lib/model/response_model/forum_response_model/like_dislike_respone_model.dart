// To parse this JSON data, do
//
//     final likeDisLikeResponseModel = likeDisLikeResponseModelFromJson(jsonString);

import 'dart:convert';

LikeDisLikeResponseModel likeDisLikeResponseModelFromJson(String str) =>
    LikeDisLikeResponseModel.fromJson(json.decode(str));

String likeDisLikeResponseModelToJson(LikeDisLikeResponseModel data) =>
    json.encode(data.toJson());

class LikeDisLikeResponseModel {
  LikeDisLikeResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  Data? data;

  factory LikeDisLikeResponseModel.fromJson(Map<String, dynamic> json) =>
      LikeDisLikeResponseModel(
        success: json["success"] == null ? null : json["success"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "msg": msg == null ? null : msg,
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.likes,
    this.dislikes,
  });

  int? likes;
  int? dislikes;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        likes: json["likes"] == null ? null : json["likes"],
        dislikes: json["dislikes"] == null ? null : json["dislikes"],
      );

  Map<String, dynamic> toJson() => {
        "likes": likes == null ? null : likes,
        "dislikes": dislikes == null ? null : dislikes,
      };
}
