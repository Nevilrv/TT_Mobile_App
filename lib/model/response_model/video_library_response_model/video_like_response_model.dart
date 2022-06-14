import 'dart:convert';

VideoLikeResponseModel videoLikeResponseModelFromJson(String str) =>
    VideoLikeResponseModel.fromJson(json.decode(str));

String videoLikeResponseModelToJson(VideoLikeResponseModel data) =>
    json.encode(data.toJson());

class VideoLikeResponseModel {
  VideoLikeResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  Data? data;

  factory VideoLikeResponseModel.fromJson(Map<String, dynamic> json) =>
      VideoLikeResponseModel(
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
    this.totalLikes,
  });

  int? totalLikes;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalLikes: json["total_likes"],
      );

  Map<String, dynamic> toJson() => {
        "total_likes": totalLikes,
      };
}
