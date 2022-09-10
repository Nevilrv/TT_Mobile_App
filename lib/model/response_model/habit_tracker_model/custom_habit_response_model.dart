// To parse this JSON data, do
//
//     final customHabitResponseModel = customHabitResponseModelFromJson(jsonString);

import 'dart:convert';

CustomHabitResponseModel customHabitResponseModelFromJson(String str) =>
    CustomHabitResponseModel.fromJson(json.decode(str));

String customHabitResponseModelToJson(CustomHabitResponseModel data) =>
    json.encode(data.toJson());

class CustomHabitResponseModel {
  CustomHabitResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  String? data;

  factory CustomHabitResponseModel.fromJson(Map<String, dynamic> json) =>
      CustomHabitResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": data,
      };
}
