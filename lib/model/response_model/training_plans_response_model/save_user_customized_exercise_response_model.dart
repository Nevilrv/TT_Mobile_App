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
  List<customExe>? data;

  factory SaveUserCustomizedExerciseResponseModel.fromJson(
          Map<String, dynamic> json) =>
      SaveUserCustomizedExerciseResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: List<customExe>.from(
            json["data"].map((x) => customExe.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class customExe {
  customExe({
    this.id,
    this.userId,
    this.exerciseId,
    this.reps,
    this.createdAt,
    this.isCompleted,
  });

  String? id;
  String? userId;
  String? exerciseId;
  String? reps;
  String? createdAt;
  String? isCompleted;

  factory customExe.fromJson(Map<String, dynamic> json) => customExe(
        id: json["id"],
        userId: json["user_id"],
        exerciseId: json["exercise_id"],
        reps: json["reps"],
        createdAt: json["created_at"],
        isCompleted: json["is_completed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "exercise_id": exerciseId,
        "reps": reps,
        "created_at": createdAt,
        "is_completed": isCompleted,
      };
}
