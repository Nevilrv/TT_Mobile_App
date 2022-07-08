// To parse this JSON data, do
//
//     final workoutByIdResponseModel = workoutByIdResponseModelFromJson(jsonString);
//
// import 'dart:convert';
//
// WorkoutByIdResponseModel workoutByIdResponseModelFromJson(String str) =>
//     WorkoutByIdResponseModel.fromJson(json.decode(str));
//
// String workoutByIdResponseModelToJson(WorkoutByIdResponseModel data) =>
//     json.encode(data.toJson());
//
// class WorkoutByIdResponseModel {
//   WorkoutByIdResponseModel({
//     this.success,
//     this.msg,
//     this.data,
//   });
//
//   bool? success;
//   String? msg;
//   List<WorkoutById>? data;
//
//   factory WorkoutByIdResponseModel.fromJson(Map<String, dynamic> json) =>
//       WorkoutByIdResponseModel(
//         success: json["success"],
//         msg: json["msg"],
//         data: List<WorkoutById>.from(
//             json["data"].map((x) => WorkoutById.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "msg": msg,
//         "data": List<dynamic>.from(data!.map((x) => x.toJson())),
//       };
// }
//
// class WorkoutById {
//   WorkoutById({
//     this.workoutId,
//     this.workoutTitle,
//     this.workoutDescription,
//     this.workoutGoal,
//     this.workoutLevel,
//     this.workoutDuration,
//     this.workoutImage,
//     this.workoutVideo,
//     this.goalTitle,
//     this.levelTitle,
//     this.dayNames,
//     this.daysAllData,
//   });
//
//   String? workoutId;
//   String? workoutTitle;
//   String? workoutDescription;
//   String? workoutGoal;
//   String? workoutLevel;
//   int? workoutDuration;
//   String? workoutImage;
//   dynamic workoutVideo;
//   String? goalTitle;
//   String? levelTitle;
//   List<dynamic>? dayNames;
//   List<dynamic>? daysAllData;
//
//   factory WorkoutById.fromJson(Map<String, dynamic> json) => WorkoutById(
//         workoutId: json["workout_id"],
//         workoutTitle: json["workout_title"],
//         workoutDescription: json["workout_description"],
//         workoutGoal: json["workout_goal"],
//         workoutLevel: json["workout_level"],
//         workoutDuration: json["workout_duration"],
//         workoutImage: json["workout_image"],
//         workoutVideo: json["workout_video"],
//         goalTitle: json["goal_title"],
//         levelTitle: json["level_title"],
//         dayNames: List<dynamic>.from(json["day_names"].map((x) => x)),
//         daysAllData: json["days_all_data"] == null
//             ? []
//             : List<DaysAllWorkoutById>.from(json["days_all_data"]
//                 .map((x) => DaysAllWorkoutById.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "workout_id": workoutId,
//         "workout_title": workoutTitle,
//         "workout_description": workoutDescription,
//         "workout_goal": workoutGoal,
//         "workout_level": workoutLevel,
//         "workout_duration": workoutDuration,
//         "workout_image": workoutImage,
//         "workout_video": workoutVideo,
//         "goal_title": goalTitle,
//         "level_title": levelTitle,
//         "day_names": List<dynamic>.from(dayNames!.map((x) => x)),
//         "days_all_data":
//             List<dynamic>.from(daysAllData!.map((x) => x.toJson())),
//       };
// }
//
// class DaysAllWorkoutById {
//   DaysAllWorkoutById({
//     this.days,
//   });
//
//   List<Day>? days;
//
//   factory DaysAllWorkoutById.fromJson(Map<String, dynamic> json) =>
//       DaysAllWorkoutById(
//         days: List<Day>.from(json["days"].map((x) => Day.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "days": List<dynamic>.from(days!.map((x) => x.toJson())),
//       };
// }
//
// class Day {
//   Day({
//     this.selectedExercises,
//     this.favorite,
//     this.day,
//     this.dayName,
//   });
//
//   List<String>? selectedExercises;
//   List<dynamic>? favorite;
//   String? day;
//   String? dayName;
//
//   factory Day.fromJson(Map<String, dynamic> json) => Day(
//         selectedExercises:
//             List<String>.from(json["selected_exercises"].map((x) => x)),
//         favorite: List<dynamic>.from(json["favorite"].map((x) => x)),
//         day: json["day"],
//         dayName: json["day_name"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "selected_exercises":
//             List<dynamic>.from(selectedExercises!.map((x) => x)),
//         "favorite": List<dynamic>.from(favorite!.map((x) => x)),
//         "day": day,
//         "day_name": dayName,
//       };
// }

/// 2

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
        success: json["success"],
        msg: json["msg"],
        data: List<WorkoutById>.from(
            json["data"].map((x) => WorkoutById.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
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
  dynamic workoutVideo;
  String? goalTitle;
  String? levelTitle;
  String? selectedDays;
  List<dynamic>? dayNames;
  List<dynamic>? daysAllData;
  List<String>? availableEquipments;

  factory WorkoutById.fromJson(Map<String, dynamic> json) => WorkoutById(
        workoutId: json["workout_id"],
        workoutTitle: json["workout_title"],
        workoutDescription: json["workout_description"],
        workoutGoal: json["workout_goal"],
        workoutLevel: json["workout_level"],
        workoutDuration: json["workout_duration"],
        workoutImage: json["workout_image"],
        workoutVideo: json["workout_video"],
        goalTitle: json["goal_title"],
        levelTitle: json["level_title"],
        selectedDays: json["selected_days"],
        dayNames: json["days_all_data"] == null
            ? []
            : List<dynamic>.from(json["day_names"].map((x) => x)),
        daysAllData: json["days_all_data"] == null
            ? []
            : List<DaysAllWorkoutById>.from(json["days_all_data"]
                .map((x) => DaysAllWorkoutById.fromJson(x))),
        availableEquipments:
            List<String>.from(json["available_equipments"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "workout_id": workoutId,
        "workout_title": workoutTitle,
        "workout_description": workoutDescription,
        "workout_goal": workoutGoal,
        "workout_level": workoutLevel,
        "workout_duration": workoutDuration,
        "workout_image": workoutImage,
        "workout_video": workoutVideo,
        "goal_title": goalTitle,
        "level_title": levelTitle,
        "selected_days": selectedDays,
        "day_names": List<dynamic>.from(dayNames!.map((x) => x)),
        "days_all_data":
            List<dynamic>.from(daysAllData!.map((x) => x.toJson())),
        "available_equipments":
            List<dynamic>.from(availableEquipments!.map((x) => x)),
      };
}

class DaysAllWorkoutById {
  DaysAllWorkoutById({
    this.days,
  });

  List<Day>? days;

  factory DaysAllWorkoutById.fromJson(Map<String, dynamic> json) =>
      DaysAllWorkoutById(
        days: List<Day>.from(json["days"].map((x) => Day.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "days": List<dynamic>.from(days!.map((x) => x.toJson())),
      };
}

class Day {
  Day({
    this.selectedExercises,
    this.favorite,
    this.day,
    this.dayName,
    this.dayIndex,
  });

  List<String>? selectedExercises;
  List<dynamic>? favorite;
  String? day;
  String? dayName;
  String? dayIndex;

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        selectedExercises:
            List<String>.from(json["selected_exercises"].map((x) => x)),
        favorite: json["favorite"] == null
            ? null
            : List<dynamic>.from(json["favorite"].map((x) => x)),
        day: json["day"],
        dayName: json["day_name"],
        dayIndex: json["day_index"],
      );

  Map<String, dynamic> toJson() => {
        "selected_exercises":
            List<dynamic>.from(selectedExercises!.map((x) => x)),
        "favorite": favorite == null
            ? null
            : List<dynamic>.from(favorite!.map((x) => x)),
        "day": day,
        "day_name": dayName,
        "day_index": dayIndex,
      };
}

// // To parse this JSON data, do
// //
// //     final scheduleByDateResponseModel = scheduleByDateResponseModelFromJson(jsonString);
//
// import 'dart:convert';
//
// ScheduleByDateResponseModel scheduleByDateResponseModelFromJson(String str) => ScheduleByDateResponseModel.fromJson(json.decode(str));
//
// String scheduleByDateResponseModelToJson(ScheduleByDateResponseModel data) => json.encode(data.toJson());
//
// class ScheduleByDateResponseModel {
//   ScheduleByDateResponseModel({
//     this.success,
//     this.msg,
//     this.data,
//   });
//
//   bool success;
//   String msg;
//   List<Datum> data;
//
//   factory ScheduleByDateResponseModel.fromJson(Map<String, dynamic> json) => ScheduleByDateResponseModel(
//     success: json["success"],
//     msg: json["msg"],
//     data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "success": success,
//     "msg": msg,
//     "data": List<dynamic>.from(data.map((x) => x.toJson())),
//   };
// }
//
// class Datum {
//   Datum({
//     this.workoutId,
//     this.workoutTitle,
//     this.workoutDescription,
//     this.workoutGoal,
//     this.workoutLevel,
//     this.workoutDuration,
//     this.workoutImage,
//     this.workoutVideo,
//     this.goalTitle,
//     this.levelTitle,
//     this.selectedDays,
//     this.dayNames,
//     this.daysAllData,
//     this.availableEquipments,
//   });
//
//   String workoutId;
//   String workoutTitle;
//   String workoutDescription;
//   String workoutGoal;
//   String workoutLevel;
//   int workoutDuration;
//   dynamic workoutImage;
//   dynamic workoutVideo;
//   String goalTitle;
//   String levelTitle;
//   String selectedDays;
//   List<String> dayNames;
//   List<DaysAllDatum> daysAllData;
//   List<String> availableEquipments;
//
//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//     workoutId: json["workout_id"],
//     workoutTitle: json["workout_title"],
//     workoutDescription: json["workout_description"],
//     workoutGoal: json["workout_goal"],
//     workoutLevel: json["workout_level"],
//     workoutDuration: json["workout_duration"],
//     workoutImage: json["workout_image"],
//     workoutVideo: json["workout_video"],
//     goalTitle: json["goal_title"],
//     levelTitle: json["level_title"],
//     selectedDays: json["selected_days"],
//     dayNames: List<String>.from(json["day_names"].map((x) => x)),
//     daysAllData: List<DaysAllDatum>.from(json["days_all_data"].map((x) => DaysAllDatum.fromJson(x))),
//     availableEquipments: List<String>.from(json["available_equipments"].map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "workout_id": workoutId,
//     "workout_title": workoutTitle,
//     "workout_description": workoutDescription,
//     "workout_goal": workoutGoal,
//     "workout_level": workoutLevel,
//     "workout_duration": workoutDuration,
//     "workout_image": workoutImage,
//     "workout_video": workoutVideo,
//     "goal_title": goalTitle,
//     "level_title": levelTitle,
//     "selected_days": selectedDays,
//     "day_names": List<dynamic>.from(dayNames.map((x) => x)),
//     "days_all_data": List<dynamic>.from(daysAllData.map((x) => x.toJson())),
//     "available_equipments": List<dynamic>.from(availableEquipments.map((x) => x)),
//   };
// }
//
// class DaysAllDatum {
//   DaysAllDatum({
//     this.days,
//   });
//
//   List<Day> days;
//
//   factory DaysAllDatum.fromJson(Map<String, dynamic> json) => DaysAllDatum(
//     days: List<Day>.from(json["days"].map((x) => Day.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "days": List<dynamic>.from(days.map((x) => x.toJson())),
//   };
// }
//
// class Day {
//   Day({
//     this.selectedExercises,
//     this.favorite,
//     this.day,
//     this.dayName,
//   });
//
//   List<String> selectedExercises;
//   List<dynamic> favorite;
//   String day;
//   String dayName;
//
//   factory Day.fromJson(Map<String, dynamic> json) => Day(
//     selectedExercises: List<String>.from(json["selected_exercises"].map((x) => x)),
//     favorite: json["favorite"] == null ? null : List<dynamic>.from(json["favorite"].map((x) => x)),
//     day: json["day"],
//     dayName: json["day_name"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "selected_exercises": List<dynamic>.from(selectedExercises.map((x) => x)),
//     "favorite": favorite == null ? null : List<dynamic>.from(favorite.map((x) => x)),
//     "day": day,
//     "day_name": dayName,
//   };
// }
