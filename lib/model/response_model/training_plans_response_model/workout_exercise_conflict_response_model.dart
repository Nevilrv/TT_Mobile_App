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
  List<Conflict>? data;

  factory WorkoutExerciseConflictResponseModel.fromJson(
          Map<String, dynamic> json) =>
      WorkoutExerciseConflictResponseModel(
        success: json["success"],
        msg: json["msg"],
        data:
            List<Conflict>.from(json["data"].map((x) => Conflict.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Conflict {
  Conflict({
    this.userWorkoutProgramId,
    this.workoutId,
    this.workoutTitle,
  });

  String? userWorkoutProgramId;
  String? workoutId;
  String? workoutTitle;

  factory Conflict.fromJson(Map<String, dynamic> json) => Conflict(
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
