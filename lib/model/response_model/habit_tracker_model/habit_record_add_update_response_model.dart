// To parse this JSON data, do
//
//     final habitRecordAddUpdateResponseModel = habitRecordAddUpdateResponseModelFromJson(jsonString);

import 'dart:convert';

HabitRecordAddUpdateResponseModel habitRecordAddUpdateResponseModelFromJson(
        String str) =>
    HabitRecordAddUpdateResponseModel.fromJson(json.decode(str));

String habitRecordAddUpdateResponseModelToJson(
        HabitRecordAddUpdateResponseModel data) =>
    json.encode(data.toJson());

class HabitRecordAddUpdateResponseModel {
  HabitRecordAddUpdateResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<dynamic>? data;

  factory HabitRecordAddUpdateResponseModel.fromJson(
          Map<String, dynamic> json) =>
      HabitRecordAddUpdateResponseModel(
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
