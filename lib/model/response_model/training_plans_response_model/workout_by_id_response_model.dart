// To parse this JSON data, do
//
//     final workoutByIdResponseModel = workoutByIdResponseModelFromJson(jsonString);

import 'dart:convert';

WorkoutByIdResponseModel workoutByIdResponseModelFromJson(String str) =>
    WorkoutByIdResponseModel.fromJson(json.decode(str));

String workoutByIdResponseModelToJson(WorkoutByIdResponseModel data) =>
    json.encode(data.toJson());

class WorkoutByIdResponseModel {
  WorkoutByIdResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<WorkoutById>? data;

  factory WorkoutByIdResponseModel.fromJson(Map<String, dynamic> json) =>
      WorkoutByIdResponseModel(
        success: json["success"] == null ? null : json["success"],
        msg: json["msg"] == null ? null : json["msg"],
        data: json["data"] == null
            ? null
            : List<WorkoutById>.from(
                json["data"].map((x) => WorkoutById.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "msg": msg == null ? null : msg,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class WorkoutById {
  WorkoutById({
    this.workoutId,
    this.workoutTitle,
    this.workoutDescription,
    this.workoutGoal,
    this.workoutLevel,
    this.workoutDuration,
    this.workoutImage,
    this.workoutVideo,
    this.goalTitle,
    this.levelTitle,
    this.selectedDays,
    this.dayNames,
    this.daysAllData,
    this.availableEquipments,
  });

  String? workoutId;
  String? workoutTitle;
  String? workoutDescription;
  String? workoutGoal;
  String? workoutLevel;
  int? workoutDuration;
  String? workoutImage;
  String? workoutVideo;
  String? goalTitle;
  String? levelTitle;
  String? selectedDays;
  List<String>? dayNames;
  List<DaysAllDatum>? daysAllData;
  List<String>? availableEquipments;

  factory WorkoutById.fromJson(Map<String, dynamic> json) => WorkoutById(
        workoutId: json["workout_id"] == null ? null : json["workout_id"],
        workoutTitle:
            json["workout_title"] == null ? null : json["workout_title"],
        workoutDescription: json["workout_description"] == null
            ? null
            : json["workout_description"],
        workoutGoal: json["workout_goal"] == null ? null : json["workout_goal"],
        workoutLevel:
            json["workout_level"] == null ? null : json["workout_level"],
        workoutDuration:
            json["workout_duration"] == null ? null : json["workout_duration"],
        workoutImage:
            json["workout_image"] == null ? null : json["workout_image"],
        workoutVideo:
            json["workout_video"] == null ? null : json["workout_video"],
        goalTitle: json["goal_title"] == null ? null : json["goal_title"],
        levelTitle: json["level_title"] == null ? null : json["level_title"],
        selectedDays:
            json["selected_days"] == null ? null : json["selected_days"],
        dayNames: json["day_names"] == null
            ? null
            : List<String>.from(json["day_names"].map((x) => x)),
        daysAllData: json["days_all_data"] == null
            ? null
            : List<DaysAllDatum>.from(
                json["days_all_data"].map((x) => DaysAllDatum.fromJson(x))),
        availableEquipments: json["available_equipments"] == null
            ? null
            : List<String>.from(json["available_equipments"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "workout_id": workoutId == null ? null : workoutId,
        "workout_title": workoutTitle == null ? null : workoutTitle,
        "workout_description":
            workoutDescription == null ? null : workoutDescription,
        "workout_goal": workoutGoal == null ? null : workoutGoal,
        "workout_level": workoutLevel == null ? null : workoutLevel,
        "workout_duration": workoutDuration == null ? null : workoutDuration,
        "workout_image": workoutImage == null ? null : workoutImage,
        "workout_video": workoutVideo == null ? null : workoutVideo,
        "goal_title": goalTitle == null ? null : goalTitle,
        "level_title": levelTitle == null ? null : levelTitle,
        "selected_days": selectedDays == null ? null : selectedDays,
        "day_names": dayNames == null
            ? null
            : List<dynamic>.from(dayNames!.map((x) => x)),
        "days_all_data": daysAllData == null
            ? null
            : List<dynamic>.from(daysAllData!.map((x) => x.toJson())),
        "available_equipments": availableEquipments == null
            ? null
            : List<dynamic>.from(availableEquipments!.map((x) => x)),
      };
}

class DaysAllDatum {
  DaysAllDatum({
    this.days,
  });

  List<Day>? days;

  factory DaysAllDatum.fromJson(Map<String, dynamic> json) => DaysAllDatum(
        days: json["days"] == null
            ? null
            : List<Day>.from(json["days"].map((x) => Day.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "days": days == null
            ? null
            : List<dynamic>.from(days!.map((x) => x.toJson())),
      };
}

class Day {
  Day({
    this.selectedExercises,
    this.selectedWarmup,
    this.categoryType,
    this.favorite,
    this.day,
    this.dayName,
    this.dayIndex,
    this.groups,
  });

  List<String>? selectedExercises;
  List<dynamic>? selectedWarmup;
  String? categoryType;
  dynamic favorite;
  String? day;
  String? dayName;
  String? dayIndex;
  dynamic groups;

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        selectedExercises: json["selected_exercises"] == null
            ? null
            : List<String>.from(json["selected_exercises"].map((x) => x)),
        selectedWarmup: json["selected_warmup"] == null
            ? null
            : List<dynamic>.from(json["selected_warmup"].map((x) => x)),
        categoryType:
            json["category_type"] == null ? null : json["category_type"],
        favorite: json["favorite"],
        day: json["day"] == null ? null : json["day"],
        dayName: json["day_name"] == null ? null : json["day_name"],
        dayIndex: json["day_index"] == null ? null : json["day_index"],
        groups: json["groups"],
      );

  Map<String, dynamic> toJson() => {
        "selected_exercises": selectedExercises == null
            ? null
            : List<dynamic>.from(selectedExercises!.map((x) => x)),
        "selected_warmup": selectedWarmup == null
            ? null
            : List<dynamic>.from(selectedWarmup!.map((x) => x)),
        "category_type": categoryType == null ? null : categoryType,
        "favorite": favorite,
        "day": day == null ? null : day,
        "day_name": dayName == null ? null : dayName,
        "day_index": dayIndex == null ? null : dayIndex,
        "groups": groups,
      };
}

class GroupsClass {
  GroupsClass({
    this.the7,
  });

  The7? the7;

  factory GroupsClass.fromJson(Map<String, dynamic> json) => GroupsClass(
        the7: json["7"] == null ? null : The7.fromJson(json["7"]),
      );

  Map<String, dynamic> toJson() => {
        "7": the7 == null ? null : the7!.toJson(),
      };
}

class The7 {
  The7({
    this.parentId,
    this.groupId,
  });

  String? parentId;
  String? groupId;

  factory The7.fromJson(Map<String, dynamic> json) => The7(
        parentId: json["parent_id"] == null ? null : json["parent_id"],
        groupId: json["group_id"] == null ? null : json["group_id"],
      );

  Map<String, dynamic> toJson() => {
        "parent_id": parentId == null ? null : parentId,
        "group_id": groupId == null ? null : groupId,
      };
}
