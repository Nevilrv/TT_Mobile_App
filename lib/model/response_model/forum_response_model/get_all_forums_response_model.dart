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
    this.postId,
    this.postTitle,
    this.postDescription,
    this.postTag,
    this.postFeatured,
    this.published,
    this.postDate,
    this.postImage,
    this.tagTitle,
    this.userId,
    this.username,
    this.profilePic,
    this.totalLikes,
    this.totalDislikes,
    this.userLiked,
    this.userDisliked,
    this.totalComments,
  });

  String? postId;
  String? postTitle;
  String? postDescription;
  String? postTag;
  String? postFeatured;
  DateTime? published;
  String? postDate;

  List<String>? postImage;
  List<String>? tagTitle;
  String? userId;
  String? username;
  String? profilePic;
  int? totalLikes;
  int? totalDislikes;
  int? userLiked;
  int? userDisliked;
  int? totalComments;

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
        postImage: json["post_image"] == ""
            ? null
            : List<String>.from(json["post_image"].map((x) => x)),
        tagTitle: json["tag_title"] == null
            ? null
            : List<String>.from(json["tag_title"].map((x) => x)),
        userId: json["user_id"] == null ? null : json["user_id"],
        username: json["username"] == null ? null : json["username"],
        profilePic: json["profile_pic"] == null ? null : json["profile_pic"],
        totalLikes: json["total_likes"] == null ? null : json["total_likes"],
        totalDislikes:
            json["total_dislikes"] == null ? null : json["total_dislikes"],
        userLiked: json["user_liked"] == null ? null : json["user_liked"],
        userDisliked:
            json["user_disliked"] == null ? null : json["user_disliked"],
        totalComments:
            json["total_comments"] == null ? null : json["total_comments"],
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId == null ? null : postId,
        "post_title": postTitle == null ? null : postTitle,
        "post_description": postDescription == null ? null : postDescription,
        "post_tag": postTag == null ? null : postTag,
        "post_featured": postFeatured == null ? null : postFeatured,
        "published": published == null ? null : published!.toIso8601String(),
        "post_date": postDate == null ? null : postDate,
        "post_image": postImage == ""
            ? null
            : List<dynamic>.from(postImage!.map((x) => x)),
        "tag_title": tagTitle == null
            ? null
            : List<dynamic>.from(tagTitle!.map((x) => x)),
        "user_id": userId == null ? null : userId,
        "username": username == null ? null : username,
        "profile_pic": profilePic == null ? null : profilePic,
        "total_likes": totalLikes == null ? null : totalLikes,
        "total_dislikes": totalDislikes == null ? null : totalDislikes,
        "user_liked": userLiked == null ? null : userLiked,
        "user_disliked": userDisliked == null ? null : userDisliked,
        "total_comments": totalComments == null ? null : totalComments,
      };
}
