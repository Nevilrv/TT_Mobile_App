// To parse this JSON data, do
//
//     final updateStatusUserProgramResponseModel = updateStatusUserProgramResponseModelFromJson(jsonString);

import 'dart:convert';

UpdateStatusUserProgramResponseModel
    updateStatusUserProgramResponseModelFromJson(String str) =>
        UpdateStatusUserProgramResponseModel.fromJson(json.decode(str));

String updateStatusUserProgramResponseModelToJson(
        UpdateStatusUserProgramResponseModel data) =>
    json.encode(data.toJson());

class UpdateStatusUserProgramResponseModel {
  UpdateStatusUserProgramResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<dynamic>? data;

  factory UpdateStatusUserProgramResponseModel.fromJson(
          Map<String, dynamic> json) =>
      UpdateStatusUserProgramResponseModel(
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
