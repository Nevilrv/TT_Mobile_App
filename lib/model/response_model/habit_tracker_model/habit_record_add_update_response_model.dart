// To parse this JSON data, do
//
//     final habitRecordAddUpdateResponseModel = habitRecordAddUpdateResponseModelFromJson(jsonString);

import 'dart:convert';

HabitRecordAddUpdateResponseModel habitRecordAddUpdateResponseModelFromJson(
        String str) =>
    HabitRecordAddUpdateResponseModel.fromJson(json.decode(str));

String habitRecordAddUpdateResponseModelToJson(
        HabitRecordAddUpdateResponseModel data) =>
    json.encode(data.toJson());

class HabitRecordAddUpdateResponseModel {
  HabitRecordAddUpdateResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<HabitUpdate>? data;

  factory HabitRecordAddUpdateResponseModel.fromJson(
          Map<String, dynamic> json) =>
      HabitRecordAddUpdateResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: List<HabitUpdate>.from(
            json["data"].map((x) => HabitUpdate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class HabitUpdate {
  HabitUpdate({
    this.habitId,
    this.completed,
  });

  String? habitId;
  String? completed;

  factory HabitUpdate.fromJson(Map<String, dynamic> json) => HabitUpdate(
        habitId: json["habit_id"],
        completed: json["completed"],
      );

  Map<String, dynamic> toJson() => {
        "habit_id": habitId,
        "completed": completed,
      };
}
