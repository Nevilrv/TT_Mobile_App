// To parse this JSON data, do
//
//     final saveUserCustomizedExerciseResponseModel = saveUserCustomizedExerciseResponseModelFromJson(jsonString);

import 'dart:convert';

SaveUserCustomizedExerciseResponseModel
    saveUserCustomizedExerciseResponseModelFromJson(String str) =>
        SaveUserCustomizedExerciseResponseModel.fromJson(json.decode(str));

String saveUserCustomizedExerciseResponseModelToJson(
        SaveUserCustomizedExerciseResponseModel data) =>
    json.encode(data.toJson());

class SaveUserCustomizedExerciseResponseModel {
  SaveUserCustomizedExerciseResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<CustomData>? data;

  factory SaveUserCustomizedExerciseResponseModel.fromJson(
          Map<String, dynamic> json) =>
      SaveUserCustomizedExerciseResponseModel(
        success: json["success"] == null ? null : json["success"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null
            ? null
            : List<CustomData>.from(
                json["data"].map((x) => CustomData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "msg": msg == null ? null : msg,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CustomData {
  CustomData({
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

  factory CustomData.fromJson(Map<String, dynamic> json) => CustomData(
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
