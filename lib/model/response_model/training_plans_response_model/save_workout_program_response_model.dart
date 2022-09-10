// To parse this JSON data, do
//
//     final saveWorkoutProgramResponseModel = saveWorkoutProgramResponseModelFromJson(jsonString);

import 'dart:convert';

SaveWorkoutProgramResponseModel saveWorkoutProgramResponseModelFromJson(
        String str) =>
    SaveWorkoutProgramResponseModel.fromJson(json.decode(str));

String saveWorkoutProgramResponseModelToJson(
        SaveWorkoutProgramResponseModel data) =>
    json.encode(data.toJson());

class SaveWorkoutProgramResponseModel {
  SaveWorkoutProgramResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<dynamic>? data;

  factory SaveWorkoutProgramResponseModel.fromJson(Map<String, dynamic> json) =>
      SaveWorkoutProgramResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: List<dynamic>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x)),
      };
}
