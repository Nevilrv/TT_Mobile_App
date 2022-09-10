// To parse this JSON data, do
//
//     final recentVideoResponseModel = recentVideoResponseModelFromJson(jsonString);

import 'dart:convert';

RecentVideoResponseModel recentVideoResponseModelFromJson(String str) =>
    RecentVideoResponseModel.fromJson(json.decode(str));

String recentVideoResponseModelToJson(RecentVideoResponseModel data) =>
    json.encode(data.toJson());

class RecentVideoResponseModel {
  RecentVideoResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<RecentVideo>? data;

  factory RecentVideoResponseModel.fromJson(Map<String, dynamic> json) =>
      RecentVideoResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: List<RecentVideo>.from(
            json["data"].map((x) => RecentVideo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class RecentVideo {
  RecentVideo({
    this.videoId,
    this.categoryId,
    this.videoTitle,
    this.videoDescription,
    this.videoType,
    this.videoUrl,
    this.videoThumbnail,
    this.videoVisits,
    this.videoLike,
    this.videoDislike,
    this.createdAt,
    this.categoryTitle,
  });

  String? videoId;
  String? categoryId;
  String? videoTitle;
  String? videoDescription;
  String? videoType;
  String? videoUrl;
  String? videoThumbnail;
  String? videoVisits;
  String? videoLike;
  String? videoDislike;
  String? createdAt;
  String? categoryTitle;

  factory RecentVideo.fromJson(Map<String, dynamic> json) => RecentVideo(
        videoId: json["video_id"],
        categoryId: json["category_id"],
        videoTitle: json["video_title"],
        videoDescription: json["video_description"],
        videoType: json["video_type"],
        videoUrl: json["video_url"],
        videoThumbnail: json["video_thumbnail"],
        videoVisits: json["video_visits"],
        videoLike: json["video_like"],
        videoDislike: json["video_dislike"],
        createdAt: json["created_at"],
        categoryTitle: json["category_title"],
      );

  Map<String, dynamic> toJson() => {
        "video_id": videoId,
        "category_id": categoryId,
        "video_title": videoTitle,
        "video_description": videoDescription,
        "video_type": videoType,
        "video_url": videoUrl,
        "video_thumbnail": videoThumbnail,
        "video_visits": videoVisits,
        "video_like": videoLike,
        "video_dislike": videoDislike,
        "created_at": createdAt,
        "category_title": categoryTitle,
      };
}
