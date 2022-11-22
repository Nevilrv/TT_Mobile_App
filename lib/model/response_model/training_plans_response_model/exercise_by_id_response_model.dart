// import 'dart:convert';
//
// ExerciseByIdResponseModel exerciseByIdResponseModelFromJson(String str) =>
//     ExerciseByIdResponseModel.fromJson(json.decode(str));
//
// String exerciseByIdResponseModelToJson(ExerciseByIdResponseModel data) =>
//     json.encode(data.toJson());
//
// class ExerciseByIdResponseModel {
//   ExerciseByIdResponseModel({
//     this.success,
//     this.msg,
//     this.data,
//   });
//
//   bool? success;
//   String? msg;
//   List<ExerciseById>? data;
//
//   factory ExerciseByIdResponseModel.fromJson(Map<String, dynamic> json) =>
//       ExerciseByIdResponseModel(
//         success: json["success"],
//         msg: json["msg"],
//         data: List<ExerciseById>.from(
//             json["data"].map((x) => ExerciseById.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "msg": msg,
//         "data": List<dynamic>.from(data!.map((x) => x.toJson())),
//       };
// }
//
// class ExerciseById {
//   ExerciseById({
//     this.exerciseId,
//     this.exerciseTitle,
//     this.exerciseReps,
//     this.exerciseSets,
//     this.exerciseRest,
//     this.exerciseEquipment,
//     this.exerciseLevel,
//     this.exerciseType,
//     this.exerciseWeight,
//     this.exerciseColor,
//     this.exerciseTime,
//     this.exerciseDistance,
//     this.exerciseMeasurement,
//     this.exerciseImage,
//     this.exerciseVideoType,
//     this.exerciseVideo,
//     this.exerciseTips,
//     this.exerciseInstructions,
//     this.isFavorite,
//     this.bodyPartTitle,
//     this.equipmentTitle,
//     this.levelTitle,
//     this.exercisesBodyPartsBodyPartId,
//   });
//
//   String? exerciseId;
//   String? exerciseTitle;
//   String? exerciseReps;
//   String? exerciseSets;
//   String? exerciseRest;
//   String? exerciseEquipment;
//   String? exerciseLevel;
//   String? exerciseType;
//   String? exerciseWeight;
//   String? exerciseColor;
//   String? exerciseTime;
//   String? exerciseDistance;
//   String? exerciseMeasurement;
//   String? exerciseImage;
//   String? exerciseVideoType;
//   dynamic exerciseVideo;
//   String? exerciseTips;
//   dynamic exerciseInstructions;
//   String? isFavorite;
//   String? bodyPartTitle;
//   String? equipmentTitle;
//   String? levelTitle;
//   String? exercisesBodyPartsBodyPartId;
//
//   factory ExerciseById.fromJson(Map<String, dynamic> json) => ExerciseById(
//         exerciseId: json["exercise_id"],
//         exerciseTitle: json["exercise_title"],
//         exerciseReps: json["exercise_reps"],
//         exerciseSets: json["exercise_sets"],
//         exerciseRest: json["exercise_rest"],
//         exerciseEquipment: json["exercise_equipment"],
//         exerciseLevel: json["exercise_level"],
//         exerciseType: json["exercise_type"],
//         exerciseWeight: json["exercise_weight"],
//         exerciseColor: json["exercise_color"],
//         exerciseTime: json["exercise_time"],
//         exerciseDistance: json["exercise_distance"],
//         exerciseMeasurement: json["exercise_measurement"],
//         exerciseImage: json["exercise_image"],
//         exerciseVideoType: json["exercise_video_type"],
//         exerciseVideo: json["exercise_video"],
//         exerciseTips: json["exercise_tips"],
//         exerciseInstructions: json["exercise_instructions"],
//         isFavorite: json["is_favorite"],
//         bodyPartTitle: json["bodypart_title"],
//         equipmentTitle: json["equipment_title"],
//         levelTitle: json["level_title"],
//         exercisesBodyPartsBodyPartId: json["exercises_bodyparts_bodypart_id"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "exercise_id": exerciseId,
//         "exercise_title": exerciseTitle,
//         "exercise_reps": exerciseReps,
//         "exercise_sets": exerciseSets,
//         "exercise_rest": exerciseRest,
//         "exercise_equipment": exerciseEquipment,
//         "exercise_level": exerciseLevel,
//         "exercise_type": exerciseType,
//         "exercise_weight": exerciseWeight,
//         "exercise_color": exerciseColor,
//         "exercise_time": exerciseTime,
//         "exercise_distance": exerciseDistance,
//         "exercise_measurement": exerciseMeasurement,
//         "exercise_image": exerciseImage,
//         "exercise_video_type": exerciseVideoType,
//         "exercise_video": exerciseVideo,
//         "exercise_tips": exerciseTips,
//         "exercise_instructions": exerciseInstructions,
//         "is_favorite": isFavorite,
//         "bodypart_title": bodyPartTitle,
//         "equipment_title": equipmentTitle,
//         "level_title": levelTitle,
//         "exercises_bodyparts_bodypart_id": exercisesBodyPartsBodyPartId,
//       };
// }

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
        success: json["success"] == null ? null : json["success"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null
            ? null
            : List<ExerciseById>.from(
                json["data"].map((x) => ExerciseById.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "msg": msg == null ? null : msg,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ExerciseById {
  ExerciseById({
    this.exerciseId,
    this.exerciseTitle,
    this.exerciseSubstitute,
    this.exerciseReps,
    this.exerciseSets,
    this.exerciseRest,
    this.exerciseEquipment,
    this.exerciseLevel,
    this.exerciseType,
    this.exerciseWeight,
    this.exerciseColor,
    this.exerciseTime,
    this.exerciseDistance,
    this.exerciseMeasurement,
    this.exerciseImage,
    this.exerciseVideoType,
    this.exerciseVideo,
    this.exerciseTips,
    this.exerciseInstructions,
    this.isFavorite,
    this.categoryType,
    this.exerciseMaxReps,
    this.bodypartTitle,
    this.equipmentTitle,
    this.levelTitle,
    this.exercisesBodypartsBodypartId,
    this.userExercise,
  });

  String? exerciseId;
  String? exerciseTitle;
  dynamic exerciseSubstitute;
  String? exerciseReps;
  String? exerciseSets;
  String? exerciseRest;
  String? exerciseEquipment;
  String? exerciseLevel;
  String? exerciseType;
  String? exerciseWeight;
  String? exerciseColor;
  String? exerciseTime;
  String? exerciseDistance;
  String? exerciseMeasurement;
  String? exerciseImage;
  String? exerciseVideoType;
  dynamic exerciseVideo;
  String? exerciseTips;
  dynamic exerciseInstructions;
  String? isFavorite;
  String? categoryType;
  String? exerciseMaxReps;
  String? bodypartTitle;
  String? equipmentTitle;
  String? levelTitle;
  String? exercisesBodypartsBodypartId;
  UserExercise? userExercise;

  factory ExerciseById.fromJson(Map<String, dynamic> json) => ExerciseById(
        exerciseId: json["exercise_id"] == null ? null : json["exercise_id"],
        exerciseTitle:
            json["exercise_title"] == null ? null : json["exercise_title"],
        exerciseSubstitute: json["exercise_substitute"],
        exerciseReps:
            json["exercise_reps"] == null ? null : json["exercise_reps"],
        exerciseSets:
            json["exercise_sets"] == null ? null : json["exercise_sets"],
        exerciseRest:
            json["exercise_rest"] == null ? null : json["exercise_rest"],
        exerciseEquipment: json["exercise_equipment"] == null
            ? null
            : json["exercise_equipment"],
        exerciseLevel:
            json["exercise_level"] == null ? null : json["exercise_level"],
        exerciseType:
            json["exercise_type"] == null ? null : json["exercise_type"],
        exerciseWeight:
            json["exercise_weight"] == null ? null : json["exercise_weight"],
        exerciseColor:
            json["exercise_color"] == null ? null : json["exercise_color"],
        exerciseTime:
            json["exercise_time"] == null ? null : json["exercise_time"],
        exerciseDistance: json["exercise_distance"] == null
            ? null
            : json["exercise_distance"],
        exerciseMeasurement: json["exercise_measurement"] == null
            ? null
            : json["exercise_measurement"],
        exerciseImage:
            json["exercise_image"] == null ? null : json["exercise_image"],
        exerciseVideoType: json["exercise_video_type"] == null
            ? null
            : json["exercise_video_type"],
        exerciseVideo:
            json["exercise_video"] == null ? null : json["exercise_video"],
        exerciseTips:
            json["exercise_tips"] == null ? null : json["exercise_tips"],
        exerciseInstructions: json["exercise_instructions"],
        isFavorite: json["is_favorite"] == null ? null : json["is_favorite"],
        categoryType:
            json["category_type"] == null ? null : json["category_type"],
        exerciseMaxReps: json["exercise_max_reps"] == null
            ? null
            : json["exercise_max_reps"],
        bodypartTitle:
            json["bodypart_title"] == null ? null : json["bodypart_title"],
        equipmentTitle:
            json["equipment_title"] == null ? null : json["equipment_title"],
        levelTitle: json["level_title"] == null ? null : json["level_title"],
        exercisesBodypartsBodypartId:
            json["exercises_bodyparts_bodypart_id"] == null
                ? null
                : json["exercises_bodyparts_bodypart_id"],
        userExercise: json["user_exercise"] == null
            ? null
            : UserExercise.fromJson(json["user_exercise"]),
      );

  Map<String, dynamic> toJson() => {
        "exercise_id": exerciseId == null ? null : exerciseId,
        "exercise_title": exerciseTitle == null ? null : exerciseTitle,
        "exercise_substitute": exerciseSubstitute,
        "exercise_reps": exerciseReps == null ? null : exerciseReps,
        "exercise_sets": exerciseSets == null ? null : exerciseSets,
        "exercise_rest": exerciseRest == null ? null : exerciseRest,
        "exercise_equipment":
            exerciseEquipment == null ? null : exerciseEquipment,
        "exercise_level": exerciseLevel == null ? null : exerciseLevel,
        "exercise_type": exerciseType == null ? null : exerciseType,
        "exercise_weight": exerciseWeight == null ? null : exerciseWeight,
        "exercise_color": exerciseColor == null ? null : exerciseColor,
        "exercise_time": exerciseTime == null ? null : exerciseTime,
        "exercise_distance": exerciseDistance == null ? null : exerciseDistance,
        "exercise_measurement":
            exerciseMeasurement == null ? null : exerciseMeasurement,
        "exercise_image": exerciseImage == null ? null : exerciseImage,
        "exercise_video_type":
            exerciseVideoType == null ? null : exerciseVideoType,
        "exercise_video": exerciseVideo == null ? null : exerciseVideo,
        "exercise_tips": exerciseTips == null ? null : exerciseTips,
        "exercise_instructions": exerciseInstructions,
        "is_favorite": isFavorite == null ? null : isFavorite,
        "category_type": categoryType == null ? null : categoryType,
        "exercise_max_reps": exerciseMaxReps == null ? null : exerciseMaxReps,
        "bodypart_title": bodypartTitle == null ? null : bodypartTitle,
        "equipment_title": equipmentTitle == null ? null : equipmentTitle,
        "level_title": levelTitle == null ? null : levelTitle,
        "exercises_bodyparts_bodypart_id": exercisesBodypartsBodypartId == null
            ? null
            : exercisesBodypartsBodypartId,
        "user_exercise": userExercise == null ? null : userExercise!.toJson(),
      };
}

class UserExercise {
  UserExercise({
    this.id,
    this.userId,
    this.exerciseId,
    this.exerciseType,
    this.repsData,
    this.weightData,
    this.createdAt,
  });

  String? id;
  String? userId;
  String? exerciseId;
  String? exerciseType;
  String? repsData;
  String? weightData;
  String? createdAt;

  factory UserExercise.fromJson(Map<String, dynamic> json) => UserExercise(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        exerciseId: json["exercise_id"] == null ? null : json["exercise_id"],
        exerciseType:
            json["exercise_type"] == null ? null : json["exercise_type"],
        repsData: json["reps_data"] == null ? null : json["reps_data"],
        weightData: json["weight_data"] == null ? null : json["weight_data"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "exercise_id": exerciseId == null ? null : exerciseId,
        "exercise_type": exerciseType == null ? null : exerciseType,
        "reps_data": repsData == null ? null : repsData,
        "weight_data": weightData == null ? null : weightData,
        "created_at": createdAt == null ? null : createdAt,
      };
}
