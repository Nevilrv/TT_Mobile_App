// To parse this JSON data, do
//
//     final addUserHabitIdResponseModel = addUserHabitIdResponseModelFromJson(jsonString);

import 'dart:convert';

AddUserHabitIdResponseModel addUserHabitIdResponseModelFromJson(String str) =>
    AddUserHabitIdResponseModel.fromJson(json.decode(str));

String addUserHabitIdResponseModelToJson(AddUserHabitIdResponseModel data) =>
    json.encode(data.toJson());

class AddUserHabitIdResponseModel {
  AddUserHabitIdResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  Data? data;

  factory AddUserHabitIdResponseModel.fromJson(Map<String, dynamic> json) =>
      AddUserHabitIdResponseModel(
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
    this.userHabitsId,
    this.habitIds,
  });

  dynamic userHabitsId;
  List<String>? habitIds;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userHabitsId: json["user_habits_id"],
        habitIds: List<String>.from(json["habit_ids"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "user_habits_id": userHabitsId,
        "habit_ids": List<dynamic>.from(habitIds!.map((x) => x)),
      };
}
