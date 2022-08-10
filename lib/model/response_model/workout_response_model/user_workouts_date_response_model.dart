// To parse this JSON data, do
//
//     final userWorkoutsDateResponseModel = userWorkoutsDateResponseModelFromJson(jsonString);

import 'dart:convert';

UserWorkoutsDateResponseModel userWorkoutsDateResponseModelFromJson(
        String str) =>
    UserWorkoutsDateResponseModel.fromJson(json.decode(str));

String userWorkoutsDateResponseModelToJson(
        UserWorkoutsDateResponseModel data) =>
    json.encode(data.toJson());

class UserWorkoutsDateResponseModel {
  UserWorkoutsDateResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<ExeIds>? data;

  factory UserWorkoutsDateResponseModel.fromJson(Map<String, dynamic> json) =>
      UserWorkoutsDateResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: List<ExeIds>.from(json["data"].map((x) => ExeIds.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ExeIds {
  ExeIds({
    this.workoutId,
    this.date,
    this.exercisesIds,
  });

  String? workoutId;
  String? date;
  List<String>? exercisesIds;

  factory ExeIds.fromJson(Map<String, dynamic> json) => ExeIds(
        workoutId: json["workout_id"],
        date: json["date"],
        exercisesIds: List<String>.from(json["exercises_ids"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "workout_id": workoutId,
        "date": date,
        "exercises_ids": List<dynamic>.from(exercisesIds!.map((x) => x)),
      };
}
