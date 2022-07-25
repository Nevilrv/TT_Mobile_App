// To parse this JSON data, do
//
//     final getAllForumsResponseModel = getAllForumsResponseModelFromJson(jsonString);

import 'dart:convert';

GetAllForumsResponseModel getAllForumsResponseModelFromJson(String str) =>
    GetAllForumsResponseModel.fromJson(json.decode(str));

String getAllForumsResponseModelToJson(GetAllForumsResponseModel data) =>
    json.encode(data.toJson());

class GetAllForumsResponseModel {
  GetAllForumsResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<Datum>? data;

  factory GetAllForumsResponseModel.fromJson(Map<String, dynamic> json) =>
      GetAllForumsResponseModel(
        success: json["success"] == null ? null : json["success"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "msg": msg == null ? null : msg,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum(
      {this.postId,
      this.postTitle,
      this.postDescription,
      this.postTag,
      this.postFeatured,
      this.published,
      this.postDate,
      this.postImage,
      this.tagTitle,
      this.userId,
      this.userName,
      this.profilePic,
      this.totalDislike,
      this.totalLike,
      this.userLiked,
      this.userDisLiked});

  String? postId;
  String? postTitle;
  String? postDescription;
  String? postTag;
  String? postFeatured;
  DateTime? published;
  String? postDate;
  String? postImage;
  String? tagTitle;
  String? userId;
  String? userName;
  String? profilePic;
  int? totalLike;
  int? totalDislike;
  int? userLiked;
  int? userDisLiked;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        postId: json["post_id"] == null ? null : json["post_id"],
        postTitle: json["post_title"] == null ? null : json["post_title"],
        postDescription:
            json["post_description"] == null ? null : json["post_description"],
        postTag: json["post_tag"] == null ? null : json["post_tag"],
        postFeatured:
            json["post_featured"] == null ? null : json["post_featured"],
        published: json["published"] == null
            ? null
            : DateTime.parse(json["published"]),
        postDate: json["post_date"] == null ? null : json["post_date"],
        postImage: json["post_image"] == null ? null : json["post_image"],
        tagTitle: json["tag_title"] == null ? null : json["tag_title"],
        userId: json["user_id"] == null ? null : json["user_id"],
        userName: json["username"] == null ? null : json["username"],
        profilePic: json["profile_pic"] == null ? null : json["profile_pic"],
        totalLike: json["total_likes"] == null ? null : json["total_likes"],
        totalDislike:
            json["total_dislikes"] == null ? null : json["total_dislikes"],
        userLiked: json["user_liked"] == null ? null : json["user_liked"],
        userDisLiked:
            json["user_disliked"] == null ? null : json["user_disliked"],
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId == null ? null : postId,
        "post_title": postTitle == null ? null : postTitle,
        "post_description": postDescription == null ? null : postDescription,
        "post_tag": postTag == null ? null : postTag,
        "post_featured": postFeatured == null ? null : postFeatured,
        "published": published == null ? null : published!.toIso8601String(),
        "post_date": postDate == null ? null : postDate,
        "post_image": postImage == null ? null : postImage,
        "tag_title": tagTitle == null ? null : tagTitle,
        "user_id": userId == null ? null : userId,
        "username": userName == null ? null : userName,
        "profile_pic": profilePic == null ? null : profilePic,
        "total_likes": totalLike == null ? null : totalLike,
        "total_dislikes": totalDislike == null ? null : totalDislike,
        "user_liked": userLiked == null ? null : userLiked,
        "user_disliked": userDisLiked == null ? null : userDisLiked,
      };
}
