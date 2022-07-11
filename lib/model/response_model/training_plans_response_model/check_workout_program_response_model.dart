import 'dart:convert';

CheckWorkoutProgramResponseModel checkWorkoutProgramResponseModelFromJson(
        String str) =>
    CheckWorkoutProgramResponseModel.fromJson(json.decode(str));

String checkWorkoutProgramResponseModelToJson(
        CheckWorkoutProgramResponseModel data) =>
    json.encode(data.toJson());

class CheckWorkoutProgramResponseModel {
  CheckWorkoutProgramResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<dynamic>? data;

  factory CheckWorkoutProgramResponseModel.fromJson(
          Map<String, dynamic> json) =>
      CheckWorkoutProgramResponseModel(
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
