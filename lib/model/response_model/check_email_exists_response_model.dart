// To parse this JSON data, do
//
//     final checkEmailExistsResponseModel = checkEmailExistsResponseModelFromJson(jsonString);

import 'dart:convert';

CheckEmailExistsResponseModel checkEmailExistsResponseModelFromJson(
        String str) =>
    CheckEmailExistsResponseModel.fromJson(json.decode(str));

String checkEmailExistsResponseModelToJson(
        CheckEmailExistsResponseModel data) =>
    json.encode(data.toJson());

class CheckEmailExistsResponseModel {
  CheckEmailExistsResponseModel({
    this.success,
    this.msg,
  });

  bool? success;
  String? msg;

  factory CheckEmailExistsResponseModel.fromJson(Map<String, dynamic> json) =>
      CheckEmailExistsResponseModel(
        success: json["success"],
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
      };
}
