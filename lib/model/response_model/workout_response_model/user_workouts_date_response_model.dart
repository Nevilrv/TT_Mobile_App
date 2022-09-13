// import 'dart:convert';
//
// UserWorkoutsDateResponseModel userWorkoutsDateResponseModelFromJson(
//         String str) =>
//     UserWorkoutsDateResponseModel.fromJson(json.decode(str));
//
// String userWorkoutsDateResponseModelToJson(
//         UserWorkoutsDateResponseModel data) =>
//     json.encode(data.toJson());
//
// class UserWorkoutsDateResponseModel {
//   UserWorkoutsDateResponseModel({
//     this.success,
//     this.msg,
//     this.data,
//   });
//
//   bool? success;
//   String? msg;
//   Data? data;
//
//   factory UserWorkoutsDateResponseModel.fromJson(Map<String, dynamic> json) =>
//       UserWorkoutsDateResponseModel(
//         success: json["success"],
//         msg: json["msg"],
//         data: Data.fromJson(json["data"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "msg": msg,
//         "data": data!.toJson(),
//       };
// }
//
// class Data {
//   Data({
//     this.workoutId,
//     this.date,
//     this.exercisesIds,
//   });
//
//   String? workoutId;
//   String? date;
//   List<String>? exercisesIds;
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         workoutId: json["workout_id"],
//         date: json["date"],
//         exercisesIds: List<String>.from(json["exercises_ids"].map((x) => x)),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "workout_id": workoutId,
//         "date": date,
//         "exercises_ids": List<dynamic>.from(exercisesIds!.map((x) => x)),
//       };
// }

// To parse this JSON data, do
//
//     final userWorkoutsDateResponseModel = userWorkoutsDateResponseModelFromJson(jsonString);

import 'dart:convert';

UserWorkoutsDateResponseModel userWorkoutsDateResponseModelFromJson(
        String str) =>
    UserWorkoutsDateResponseModel.fromJson(json.decode(str));

String userWorkoutsDateResponseModelToJson(
        UserWorkoutsDateResponseModel data) =>
    json.encode(data.toJson());

class UserWorkoutsDateResponseModel {
  UserWorkoutsDateResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  Data? data;

  factory UserWorkoutsDateResponseModel.fromJson(Map<String, dynamic> json) =>
      UserWorkoutsDateResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.userProgramDatesId,
    this.workoutId,
    this.date,
    this.exercisesIds,
    this.supersetExercisesIds,
  });

  String? userProgramDatesId;
  String? workoutId;
  String? date;
  List<String>? exercisesIds;
  List<dynamic>? supersetExercisesIds;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userProgramDatesId: json["user_program_dates_id"],
        workoutId: json["workout_id"],
        date: json["date"],
        exercisesIds: List<String>.from(json["exercises_ids"].map((x) => x)),
        supersetExercisesIds:
            List<dynamic>.from(json["superset_exercises_ids"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "user_program_dates_id": userProgramDatesId,
        "workout_id": workoutId,
        "date": date,
        "exercises_ids": List<dynamic>.from(exercisesIds!.map((x) => x)),
        "superset_exercises_ids":
            List<dynamic>.from(supersetExercisesIds!.map((x) => x)),
      };
}
