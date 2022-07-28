// To parse this JSON data, do
//
//     final exerciseByIdResponseModel = exerciseByIdResponseModelFromJson(jsonString);

import 'dart:convert';

ExerciseByIdResponseModel exerciseByIdResponseModelFromJson(String str) =>
    ExerciseByIdResponseModel.fromJson(json.decode(str));

String exerciseByIdResponseModelToJson(ExerciseByIdResponseModel data) =>
    json.encode(data.toJson());

class ExerciseByIdResponseModel {
  ExerciseByIdResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<ExerciseById>? data;

  factory ExerciseByIdResponseModel.fromJson(Map<String, dynamic> json) =>
      ExerciseByIdResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: List<ExerciseById>.from(
            json["data"].map((x) => ExerciseById.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ExerciseById {
  ExerciseById({
    this.exerciseId,
    this.exerciseTitle,
    this.exerciseReps,
    this.exerciseSets,
    this.exerciseRest,
    this.exerciseEquipment,
    this.exerciseLevel,
    this.exerciseType,
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
    this.bodypartTitle,
    this.equipmentTitle,
    this.levelTitle,
    this.exercisesBodypartsBodypartId,
  });

  String? exerciseId;
  String? exerciseTitle;
  String? exerciseReps;
  String? exerciseSets;
  String? exerciseRest;
  String? exerciseEquipment;
  String? exerciseLevel;
  String? exerciseType;
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
  String? bodypartTitle;
  String? equipmentTitle;
  String? levelTitle;
  String? exercisesBodypartsBodypartId;

  factory ExerciseById.fromJson(Map<String, dynamic> json) => ExerciseById(
        exerciseId: json["exercise_id"],
        exerciseTitle: json["exercise_title"],
        exerciseReps: json["exercise_reps"],
        exerciseSets: json["exercise_sets"],
        exerciseRest: json["exercise_rest"],
        exerciseEquipment: json["exercise_equipment"],
        exerciseLevel: json["exercise_level"],
        exerciseType: json["exercise_type"],
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
        bodypartTitle: json["bodypart_title"],
        equipmentTitle: json["equipment_title"],
        levelTitle: json["level_title"],
        exercisesBodypartsBodypartId: json["exercises_bodyparts_bodypart_id"],
      );

  Map<String, dynamic> toJson() => {
        "exercise_id": exerciseId,
        "exercise_title": exerciseTitle,
        "exercise_reps": exerciseReps,
        "exercise_sets": exerciseSets,
        "exercise_rest": exerciseRest,
        "exercise_equipment": exerciseEquipment,
        "exercise_level": exerciseLevel,
        "exercise_type": exerciseType,
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
        "bodypart_title": bodypartTitle,
        "equipment_title": equipmentTitle,
        "level_title": levelTitle,
        "exercises_bodyparts_bodypart_id": exercisesBodypartsBodypartId,
      };
}
