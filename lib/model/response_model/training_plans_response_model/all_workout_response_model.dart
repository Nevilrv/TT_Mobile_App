// To parse this JSON data, do
//
//     final allWorkoutResponseModel = allWorkoutResponseModelFromJson(jsonString);

import 'dart:convert';

AllWorkoutResponseModel allWorkoutResponseModelFromJson(String str) =>
    AllWorkoutResponseModel.fromJson(json.decode(str));

String allWorkoutResponseModelToJson(AllWorkoutResponseModel data) =>
    json.encode(data.toJson());

class AllWorkoutResponseModel {
  AllWorkoutResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<Workouts>? data;

  factory AllWorkoutResponseModel.fromJson(Map<String, dynamic> json) =>
      AllWorkoutResponseModel(
        success: json["success"],
        msg: json["msg"],
        data:
            List<Workouts>.from(json["data"].map((x) => Workouts.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Workouts {
  Workouts({
    this.workoutId,
    this.workoutTitle,
    this.workoutDescription,
    this.workoutGoal,
    this.workoutLevel,
    this.workoutDuration,
    this.workoutImage,
    this.workoutVideo,
    this.workoutVideoType,
    this.goalTitle,
    this.levelTitle,
  });

  String? workoutId;
  String? workoutTitle;
  String? workoutDescription;
  String? workoutGoal;
  String? workoutLevel;
  int? workoutDuration;
  String? workoutImage;
  String? workoutVideo;
  String? workoutVideoType;
  String? goalTitle;
  String? levelTitle;

  factory Workouts.fromJson(Map<String, dynamic> json) => Workouts(
        workoutId: json["workout_id"],
        workoutTitle: json["workout_title"],
        workoutDescription: json["workout_description"],
        workoutGoal: json["workout_goal"],
        workoutLevel: json["workout_level"],
        workoutDuration: json["workout_duration"],
        workoutImage: json["workout_image"],
        workoutVideo: json["workout_video"],
        workoutVideoType: json["workout_video_type"],
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
        "workout_video": workoutVideo,
        "workout_video_type": workoutVideoType,
        "goal_title": goalTitle,
        "level_title": levelTitle,
      };
}
