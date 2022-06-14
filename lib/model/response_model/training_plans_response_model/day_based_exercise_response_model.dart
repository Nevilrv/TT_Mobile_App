// To parse this JSON data, do
//
//     final dayBasedExerciseResponseModel = dayBasedExerciseResponseModelFromJson(jsonString);

import 'dart:convert';

DayBasedExerciseResponseModel dayBasedExerciseResponseModelFromJson(
        String str) =>
    DayBasedExerciseResponseModel.fromJson(json.decode(str));

String dayBasedExerciseResponseModelToJson(
        DayBasedExerciseResponseModel data) =>
    json.encode(data.toJson());

class DayBasedExerciseResponseModel {
  DayBasedExerciseResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<DayBasedExercise>? data;

  factory DayBasedExerciseResponseModel.fromJson(Map<String, dynamic> json) =>
      DayBasedExerciseResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: List<DayBasedExercise>.from(
            json["data"].map((x) => DayBasedExercise.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DayBasedExercise {
  DayBasedExercise({
    this.dayName,
    this.exercises,
  });

  String? dayName;
  List<Exercise>? exercises;

  factory DayBasedExercise.fromJson(Map<String, dynamic> json) =>
      DayBasedExercise(
        dayName: json["day_name"],
        exercises: List<Exercise>.from(
            json["exercises"].map((x) => Exercise.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "day_name": dayName,
        "exercises": List<dynamic>.from(exercises!.map((x) => x.toJson())),
      };
}

class Exercise {
  Exercise({
    this.exerciseId,
    this.exerciseTitle,
    this.exerciseReps,
    this.exerciseSets,
    this.exerciseRest,
    this.exerciseEquipment,
    this.exerciseLevel,
    this.exerciseWeight,
    this.exerciseTime,
    this.exerciseDistance,
    this.exerciseMeasurement,
    this.exerciseImage,
    this.exerciseVideoType,
    this.exerciseVideo,
    this.exerciseTips,
    this.exerciseInstructions,
    this.isFavorite,
  });

  String? exerciseId;
  String? exerciseTitle;
  String? exerciseReps;
  String? exerciseSets;
  String? exerciseRest;
  String? exerciseEquipment;
  String? exerciseLevel;
  String? exerciseWeight;
  String? exerciseTime;
  String? exerciseDistance;
  String? exerciseMeasurement;
  String? exerciseImage;
  String? exerciseVideoType;
  String? exerciseVideo;
  String? exerciseTips;
  String? exerciseInstructions;
  String? isFavorite;

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        exerciseId: json["exercise_id"],
        exerciseTitle: json["exercise_title"],
        exerciseReps: json["exercise_reps"],
        exerciseSets: json["exercise_sets"],
        exerciseRest: json["exercise_rest"],
        exerciseEquipment: json["exercise_equipment"],
        exerciseLevel: json["exercise_level"],
        exerciseWeight: json["exercise_weight"],
        exerciseTime: json["exercise_time"],
        exerciseDistance: json["exercise_distance"],
        exerciseMeasurement: json["exercise_measurement"],
        exerciseImage: json["exercise_image"],
        exerciseVideoType: json["exercise_video_type"],
        exerciseVideo: json["exercise_video"],
        exerciseTips: json["exercise_tips"],
        exerciseInstructions: json["exercise_instructions"],
        isFavorite: json["is_favorite"],
      );

  Map<String, dynamic> toJson() => {
        "exercise_id": exerciseId,
        "exercise_title": exerciseTitle,
        "exercise_reps": exerciseReps,
        "exercise_sets": exerciseSets,
        "exercise_rest": exerciseRest,
        "exercise_equipment": exerciseEquipment,
        "exercise_level": exerciseLevel,
        "exercise_weight": exerciseWeight,
        "exercise_time": exerciseTime,
        "exercise_distance": exerciseDistance,
        "exercise_measurement": exerciseMeasurement,
        "exercise_image": exerciseImage,
        "exercise_video_type": exerciseVideoType,
        "exercise_video": exerciseVideo,
        "exercise_tips": exerciseTips,
        "exercise_instructions": exerciseInstructions,
        "is_favorite": isFavorite,
      };
}
