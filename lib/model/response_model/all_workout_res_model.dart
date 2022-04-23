import 'dart:convert';

AllWorkOutResponseModel allWorkOutResponseModelFromJson(String str) =>
    AllWorkOutResponseModel.fromJson(json.decode(str));

String allWorkOutResponseModelToJson(AllWorkOutResponseModel data) =>
    json.encode(data.toJson());

class AllWorkOutResponseModel {
  AllWorkOutResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<Datum>? data;

  factory AllWorkOutResponseModel.fromJson(Map<String, dynamic> json) =>
      AllWorkOutResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
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
  String? workoutDuration;
  String? workoutImage;
  String? goalTitle;
  String? levelTitle;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
