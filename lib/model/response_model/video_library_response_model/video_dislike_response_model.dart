// To parse this JSON data, do
//
//     final videoDislikeResponseModel = videoDislikeResponseModelFromJson(jsonString);

import 'dart:convert';

VideoDislikeResponseModel videoDislikeResponseModelFromJson(String str) =>
    VideoDislikeResponseModel.fromJson(json.decode(str));

String videoDislikeResponseModelToJson(VideoDislikeResponseModel data) =>
    json.encode(data.toJson());

class VideoDislikeResponseModel {
  VideoDislikeResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  Data? data;

  factory VideoDislikeResponseModel.fromJson(Map<String, dynamic> json) =>
      VideoDislikeResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.totalDislikes,
  });

  int? totalDislikes;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalDislikes: json["total_dislikes"],
      );

  Map<String, dynamic> toJson() => {
        "total_dislikes": totalDislikes,
      };
}
