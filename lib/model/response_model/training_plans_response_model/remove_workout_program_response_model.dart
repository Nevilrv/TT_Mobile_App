import 'dart:convert';

RemoveWorkoutProgramResponseModel removeWorkoutProgramResponseModelFromJson(
        String str) =>
    RemoveWorkoutProgramResponseModel.fromJson(json.decode(str));

String removeWorkoutProgramResponseModelToJson(
        RemoveWorkoutProgramResponseModel data) =>
    json.encode(data.toJson());

class RemoveWorkoutProgramResponseModel {
  RemoveWorkoutProgramResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<dynamic>? data;

  factory RemoveWorkoutProgramResponseModel.fromJson(
          Map<String, dynamic> json) =>
      RemoveWorkoutProgramResponseModel(
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
