/*


import 'dart:convert';

GetAllCommentsResponseModel getAllCommentsResponseModelFromJson(String str) =>
    GetAllCommentsResponseModel.fromJson(json.decode(str));

String getAllCommentsResponseModelToJson(GetAllCommentsResponseModel data) =>
    json.encode(data.toJson());

class GetAllCommentsResponseModel {
  GetAllCommentsResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<Datum>? data;

  factory GetAllCommentsResponseModel.fromJson(Map<String, dynamic> json) =>
      GetAllCommentsResponseModel(
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
    this.commentId,
    this.comment,
    this.userId,
    this.createdAt,
    this.postDate,
    this.userFirstName,
    this.userLastName,
    this.userFullName,
    this.userProfilePic,
  });

  String? postId;
  String? commentId;
  String? comment;
  String? userId;
  DateTime? createdAt;
  String? postDate;
  String? userFirstName;
  String? userLastName;
  String? userFullName;
  String? userProfilePic;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        postId: json["post_id"],
        commentId: json["comment_id"],
        comment: json["comment"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        postDate: json["post_date"],
        userFirstName: json["user_first_name"],
        userLastName: json["user_last_name"],
        userFullName: json["user_full_name"],
        userProfilePic: json["user_profile_pic"],
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "comment": comment,
        "comment_id": commentId,
        "user_id": userId,
        "created_at": createdAt!.toIso8601String(),
        "post_date": postDate,
        "user_first_name": userFirstName,
        "user_last_name": userLastName,
        "user_full_name": userFullName,
        "user_profile_pic": userProfilePic,
      };
}
*/
// To parse this JSON data, do
//
//     final exerciseByIdResponseModel = exerciseByIdResponseModelFromJson(jsonString);
// To parse this JSON data, do
//
//     final getAllCommentsResponseModel = getAllCommentsResponseModelFromJson(jsonString);

import 'dart:convert';

GetAllCommentsResponseModel getAllCommentsResponseModelFromJson(String str) =>
    GetAllCommentsResponseModel.fromJson(json.decode(str));

String getAllCommentsResponseModelToJson(GetAllCommentsResponseModel data) =>
    json.encode(data.toJson());

class GetAllCommentsResponseModel {
  GetAllCommentsResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<Datum>? data;

  factory GetAllCommentsResponseModel.fromJson(Map<String, dynamic> json) =>
      GetAllCommentsResponseModel(
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
    this.commentId,
    this.postId,
    this.comment,
    this.userId,
    this.createdAt,
    this.postDate,
    this.image,
    this.type,
    this.caption,
    this.userFirstName,
    this.userLastName,
    this.userFullName,
    this.userProfilePic,
  });

  String? commentId;
  String? postId;
  String? comment;
  String? userId;
  DateTime? createdAt;
  String? postDate;
  dynamic image;
  String? type;
  String? caption;
  String? userFirstName;
  String? userLastName;
  String? userFullName;
  String? userProfilePic;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        commentId: json["comment_id"],
        postId: json["post_id"],
        comment: json["comment"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        postDate: json["post_date"],
        image: json["media"],
        type: json["type"],
        caption: json["caption"],
        userFirstName: json["user_first_name"],
        userLastName: json["user_last_name"],
        userFullName: json["user_full_name"],
        userProfilePic: json["user_profile_pic"],
      );

  Map<String, dynamic> toJson() => {
        "comment_id": commentId,
        "post_id": postId,
        "comment": comment,
        "user_id": userId,
        "created_at": createdAt!.toIso8601String(),
        "post_date": postDate,
        "media": image,
        "type": type,
        "caption": caption,
        "user_first_name": userFirstName,
        "user_last_name": userLastName,
        "user_full_name": userFullName,
        "user_profile_pic": userProfilePic,
      };
}
