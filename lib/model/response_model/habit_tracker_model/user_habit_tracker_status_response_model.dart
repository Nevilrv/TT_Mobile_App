// To parse this JSON data, do
//
//     final userHabitTrackStatusResponseModel = userHabitTrackStatusResponseModelFromJson(jsonString);

import 'dart:convert';

UserHabitTrackStatusResponseModel userHabitTrackStatusResponseModelFromJson(
        String str) =>
    UserHabitTrackStatusResponseModel.fromJson(json.decode(str));

String userHabitTrackStatusResponseModelToJson(
        UserHabitTrackStatusResponseModel data) =>
    json.encode(data.toJson());

class UserHabitTrackStatusResponseModel {
  UserHabitTrackStatusResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  String? data;

  factory UserHabitTrackStatusResponseModel.fromJson(
          Map<String, dynamic> json) =>
      UserHabitTrackStatusResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": data,
      };
}
