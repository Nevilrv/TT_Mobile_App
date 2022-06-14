import 'dart:convert';

HabitResponseModel habitResponseModelFromJson(String str) =>
    HabitResponseModel.fromJson(json.decode(str));

String habitResponseModelToJson(HabitResponseModel data) =>
    json.encode(data.toJson());

class HabitResponseModel {
  HabitResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<Habit>? data;

  factory HabitResponseModel.fromJson(Map<String, dynamic> json) =>
      HabitResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: List<Habit>.from(json["data"].map((x) => Habit.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Habit {
  Habit({
    this.id,
    this.name,
    this.isCustom,
  });

  String? id;
  String? name;
  String? isCustom;

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        id: json["id"],
        name: json["name"],
        isCustom: json["is_custom"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_custom": isCustom,
      };
}
