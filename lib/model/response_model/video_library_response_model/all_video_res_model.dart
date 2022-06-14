import 'dart:convert';

AllVideoResponseModel allVideoResponseModelFromJson(String str) =>
    AllVideoResponseModel.fromJson(json.decode(str));

String allVideoResponseModelToJson(AllVideoResponseModel data) =>
    json.encode(data.toJson());

class AllVideoResponseModel {
  AllVideoResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<VideoData>? data;

  factory AllVideoResponseModel.fromJson(Map<String, dynamic> json) =>
      AllVideoResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: List<VideoData>.from(
            json["data"].map((x) => VideoData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class VideoData {
  VideoData({
    this.videoId,
    this.categoryId,
    this.videoTitle,
    this.videoDescription,
    this.videoType,
    this.videoUrl,
    this.videoVisits,
    this.videoLike,
    this.videoDislike,
    this.categoryTitle,
  });

  String? videoId;
  String? categoryId;
  String? videoTitle;
  String? videoDescription;
  String? videoType;
  String? videoUrl;
  String? videoVisits;
  String? videoLike;
  String? videoDislike;
  String? categoryTitle;

  factory VideoData.fromJson(Map<String, dynamic> json) => VideoData(
        videoId: json["video_id"],
        categoryId: json["category_id"],
        videoTitle: json["video_title"],
        videoDescription: json["video_description"],
        videoType: json["video_type"],
        videoUrl: json["video_url"],
        videoVisits: json["video_visits"],
        videoLike: json["video_like"],
        videoDislike: json["video_dislike"],
        categoryTitle: json["category_title"],
      );

  Map<String, dynamic> toJson() => {
        "video_id": videoId,
        "category_id": categoryId,
        "video_title": videoTitle,
        "video_description": videoDescription,
        "video_type": videoType,
        "video_url": videoUrl,
        "video_visits": videoVisits,
        "video_like": videoLike,
        "video_dislike": videoDislike,
        "category_title": categoryTitle,
      };
}
