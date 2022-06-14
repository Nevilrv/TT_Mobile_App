// To parse this JSON data, do
//
//     final videoViewsResponseModel = videoViewsResponseModelFromJson(jsonString);

import 'dart:convert';

VideoViewsResponseModel videoViewsResponseModelFromJson(String str) =>
    VideoViewsResponseModel.fromJson(json.decode(str));

String videoViewsResponseModelToJson(VideoViewsResponseModel data) =>
    json.encode(data.toJson());

class VideoViewsResponseModel {
  VideoViewsResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  Data? data;

  factory VideoViewsResponseModel.fromJson(Map<String, dynamic> json) =>
      VideoViewsResponseModel(
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
    this.totalVists,
  });

  int? totalVists;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalVists: json["total_vists"],
      );

  Map<String, dynamic> toJson() => {
        "total_vists": totalVists,
      };
}
