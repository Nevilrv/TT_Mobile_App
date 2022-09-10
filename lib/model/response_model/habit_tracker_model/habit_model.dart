// To parse this JSON data, do
//
//     final habitResponseModel = habitResponseModelFromJson(jsonString);

import 'dart:convert';

HabitResponseModel habitResponseModelFromJson(String str) =>
    HabitResponseModel.fromJson(json.decode(str));

String habitResponseModelToJson(HabitResponseModel data) =>
    json.encode(data.toJson());

class HabitResponseModel {
  HabitResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<Habit>? data;

  factory HabitResponseModel.fromJson(Map<String, dynamic> json) =>
      HabitResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: List<Habit>.from(json["data"].map((x) => Habit.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Habit {
  Habit({
    this.id,
    this.name,
    this.isCustom,
    this.userId,
    this.userName,
  });

  String? id;
  String? name;
  String? isCustom;
  String? userId;
  String? userName;

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        id: json["id"],
        name: json["name"],
        isCustom: json["is_custom"],
        userId: json["user_id"],
        userName: json["user_name"] == null ? null : json["user_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_custom": isCustom,
        "user_id": userId,
        "user_name": userName == null ? null : userName,
      };
}
