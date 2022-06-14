// To parse this JSON data, do
//
//     final goalsResModel = goalsResModelFromJson(jsonString);

import 'dart:convert';

GoalsResModel goalsResModelFromJson(String str) =>
    GoalsResModel.fromJson(json.decode(str));

String goalsResModelToJson(GoalsResModel data) => json.encode(data.toJson());

class GoalsResModel {
  GoalsResModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<Datum>? data;

  factory GoalsResModel.fromJson(Map<String, dynamic> json) => GoalsResModel(
        success: json["success"],
        msg: json["msg"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.goalId,
    this.goalTitle,
    this.goalDescription,
    this.goalImage,
  });

  String? goalId;
  String? goalTitle;
  String? goalDescription;
  String? goalImage;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        goalId: json["goal_id"],
        goalTitle: json["goal_title"],
        goalDescription: json["goal_description"],
        goalImage: json["goal_image"],
      );

  Map<String, dynamic> toJson() => {
        "goal_id": goalId,
        "goal_title": goalTitle,
        "goal_description": goalDescription,
        "goal_image": goalImage,
      };
}
