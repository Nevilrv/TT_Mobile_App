// To parse this JSON data, do
//
//     final workoutByFilterResponseModel = workoutByFilterResponseModelFromJson(jsonString);

import 'dart:convert';

WorkoutByFilterResponseModel workoutByFilterResponseModelFromJson(String str) =>
    WorkoutByFilterResponseModel.fromJson(json.decode(str));

String workoutByFilterResponseModelToJson(WorkoutByFilterResponseModel data) =>
    json.encode(data.toJson());

class WorkoutByFilterResponseModel {
  WorkoutByFilterResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<WorkoutByFilter>? data;

  factory WorkoutByFilterResponseModel.fromJson(Map<String, dynamic> json) =>
      WorkoutByFilterResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: List<WorkoutByFilter>.from(
            json["data"].map((x) => WorkoutByFilter.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class WorkoutByFilter {
  WorkoutByFilter({
    this.workoutId,
    this.workoutTitle,
    this.workoutDescription,
    this.workoutGoal,
    this.workoutLevel,
    this.workoutDuration,
    this.workoutImage,
    this.goalTitle,
    this.levelTitle,
  });

  String? workoutId;
  String? workoutTitle;
  String? workoutDescription;
  String? workoutGoal;
  String? workoutLevel;
  dynamic workoutDuration;
  String? workoutImage;
  String? goalTitle;
  String? levelTitle;

  factory WorkoutByFilter.fromJson(Map<String, dynamic> json) =>
      WorkoutByFilter(
        workoutId: json["workout_id"],
        workoutTitle: json["workout_title"],
        workoutDescription: json["workout_description"],
        workoutGoal: json["workout_goal"],
        workoutLevel: json["workout_level"],
        workoutDuration: json["workout_duration"],
        workoutImage: json["workout_image"],
        goalTitle: json["goal_title"],
        levelTitle: json["level_title"],
      );

  Map<String, dynamic> toJson() => {
        "workout_id": workoutId,
        "workout_title": workoutTitle,
        "workout_description": workoutDescription,
        "workout_goal": workoutGoal,
        "workout_level": workoutLevel,
        "workout_duration": workoutDuration,
        "workout_image": workoutImage,
        "goal_title": goalTitle,
        "level_title": levelTitle,
      };
}
