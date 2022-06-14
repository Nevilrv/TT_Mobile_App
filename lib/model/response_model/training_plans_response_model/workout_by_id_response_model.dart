// To parse this JSON data, do
//
//     final workoutByIdResponseModel = workoutByIdResponseModelFromJson(jsonString);

import 'dart:convert';

WorkoutByIdResponseModel workoutByIdResponseModelFromJson(String str) =>
    WorkoutByIdResponseModel.fromJson(json.decode(str));

String workoutByIdResponseModelToJson(WorkoutByIdResponseModel data) =>
    json.encode(data.toJson());

class WorkoutByIdResponseModel {
  WorkoutByIdResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<WorkoutById>? data;

  factory WorkoutByIdResponseModel.fromJson(Map<String, dynamic> json) =>
      WorkoutByIdResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: List<WorkoutById>.from(
            json["data"].map((x) => WorkoutById.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class WorkoutById {
  WorkoutById({
    this.workoutId,
    this.workoutTitle,
    this.workoutDescription,
    this.workoutGoal,
    this.workoutLevel,
    this.workoutDuration,
    this.workoutImage,
    this.goalTitle,
    this.levelTitle,
    this.dayNames,
  });

  String? workoutId;
  String? workoutTitle;
  String? workoutDescription;
  String? workoutGoal;
  String? workoutLevel;
  int? workoutDuration;
  String? workoutImage;
  String? goalTitle;
  String? levelTitle;
  List<String>? dayNames;

  factory WorkoutById.fromJson(Map<String, dynamic> json) => WorkoutById(
        workoutId: json["workout_id"],
        workoutTitle: json["workout_title"],
        workoutDescription: json["workout_description"],
        workoutGoal: json["workout_goal"],
        workoutLevel: json["workout_level"],
        workoutDuration: json["workout_duration"],
        workoutImage: json["workout_image"],
        goalTitle: json["goal_title"],
        levelTitle: json["level_title"],
        dayNames: List<String>.from(json["day_names"].map((x) => x)),
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
        "day_names": List<dynamic>.from(dayNames!.map((x) => x)),
      };
}
