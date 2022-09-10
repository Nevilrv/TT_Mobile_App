// To parse this JSON data, do
//
//     final getHabitRecordDateResponseModel = getHabitRecordDateResponseModelFromJson(jsonString);

import 'dart:convert';

GetHabitRecordDateResponseModel getHabitRecordDateResponseModelFromJson(
        String str) =>
    GetHabitRecordDateResponseModel.fromJson(json.decode(str));

String getHabitRecordDateResponseModelToJson(
        GetHabitRecordDateResponseModel data) =>
    json.encode(data.toJson());

class GetHabitRecordDateResponseModel {
  GetHabitRecordDateResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<HabitByDate>? data;

  factory GetHabitRecordDateResponseModel.fromJson(Map<String, dynamic> json) =>
      GetHabitRecordDateResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: List<HabitByDate>.from(
            json["data"].map((x) => HabitByDate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class HabitByDate {
  HabitByDate({
    this.habitId,
    this.habitName,
    this.completed,
  });

  String? habitId;
  String? habitName;
  String? completed;

  factory HabitByDate.fromJson(Map<String, dynamic> json) => HabitByDate(
        habitId: json["habit_id"],
        habitName: json["habit_name"],
        completed: json["completed"],
      );

  Map<String, dynamic> toJson() => {
        "habit_id": habitId,
        "habit_name": habitName,
        "completed": completed,
      };
}
