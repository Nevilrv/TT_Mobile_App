// To parse this JSON data, do
//
//     final getHabitRecordResponseModel = getHabitRecordResponseModelFromJson(jsonString);

import 'dart:convert';

GetHabitRecordResponseModel getHabitRecordResponseModelFromJson(String str) =>
    GetHabitRecordResponseModel.fromJson(json.decode(str));

String getHabitRecordResponseModelToJson(GetHabitRecordResponseModel data) =>
    json.encode(data.toJson());

class GetHabitRecordResponseModel {
  GetHabitRecordResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  Data? data;

  factory GetHabitRecordResponseModel.fromJson(Map<String, dynamic> json) =>
      GetHabitRecordResponseModel(
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
    this.id,
    this.userId,
    this.habitIds,
    this.createdAt,
    this.percentage,
    this.habits,
  });

  String? id;
  String? userId;
  String? habitIds;
  String? createdAt;
  String? percentage;
  List<Habit>? habits;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["user_id"],
        habitIds: json["habit_ids"],
        createdAt: json["created_at"],
        percentage: json["percentage"],
        habits: List<Habit>.from(json["habits"].map((x) => Habit.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "habit_ids": habitIds,
        "created_at": createdAt,
        "percentage": percentage,
        "habits": List<dynamic>.from(habits!.map((x) => x.toJson())),
      };
}

class Habit {
  Habit({
    this.name,
  });

  String? name;

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
