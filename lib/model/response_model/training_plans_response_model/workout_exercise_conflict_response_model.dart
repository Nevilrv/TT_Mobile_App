import 'dart:convert';

WorkoutExerciseConflictResponseModel
    workoutExerciseConflictResponseModelFromJson(String str) =>
        WorkoutExerciseConflictResponseModel.fromJson(json.decode(str));

String workoutExerciseConflictResponseModelToJson(
        WorkoutExerciseConflictResponseModel data) =>
    json.encode(data.toJson());

class WorkoutExerciseConflictResponseModel {
  WorkoutExerciseConflictResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  Data? data;

  factory WorkoutExerciseConflictResponseModel.fromJson(
          Map<String, dynamic> json) =>
      WorkoutExerciseConflictResponseModel(
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
    this.userWorkoutProgramId,
    this.workoutId,
    this.workoutTitle,
  });

  String? userWorkoutProgramId;
  String? workoutId;
  String? workoutTitle;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userWorkoutProgramId: json["user_workout_program_id"],
        workoutId: json["workout_id"],
        workoutTitle: json["workout_title"],
      );

  Map<String, dynamic> toJson() => {
        "user_workout_program_id": userWorkoutProgramId,
        "workout_id": workoutId,
        "workout_title": workoutTitle,
      };
}
