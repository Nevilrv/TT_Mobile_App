// // To parse this JSON data, do
// //
// //     final scheduleByDateResponseModel = scheduleByDateResponseModelFromJson(jsonString);
//
// import 'dart:convert';
//
// ScheduleByDateResponseModel scheduleByDateResponseModelFromJson(String str) =>
//     ScheduleByDateResponseModel.fromJson(json.decode(str));
//
// String scheduleByDateResponseModelToJson(ScheduleByDateResponseModel data) =>
//     json.encode(data.toJson());
//
// class ScheduleByDateResponseModel {
//   ScheduleByDateResponseModel({
//     this.success,
//     this.msg,
//     this.data,
//   });
//
//   bool? success;
//   String? msg;
//   List<Schedule>? data;
//
//   factory ScheduleByDateResponseModel.fromJson(Map<String, dynamic> json) =>
//       ScheduleByDateResponseModel(
//         success: json["success"],
//         msg: json["msg"],
//         data:
//             List<Schedule>.from(json["data"].map((x) => Schedule.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "msg": msg,
//         "data": List<dynamic>.from(data!.map((x) => x.toJson())),
//       };
// }
//
// class Schedule {
//   Schedule({
//     this.id,
//     this.userProgramId,
//     this.userId,
//     this.date,
//     this.programData,
//   });
//
//   String? id;
//   String? userProgramId;
//   String? userId;
//   String? date;
//   List<ProgramSchedule>? programData;
//
//   factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
//         id: json["id"],
//         userProgramId: json["user_program_id"],
//         userId: json["user_id"],
//         date: json["date"],
//         programData: List<ProgramSchedule>.from(
//             json["program_data"].map((x) => ProgramSchedule.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "user_program_id": userProgramId,
//         "user_id": userId,
//         "date": date,
//         "program_data": List<dynamic>.from(programData!.map((x) => x.toJson())),
//       };
// }
//
// class ProgramSchedule {
//   ProgramSchedule({
//     this.id,
//     this.workoutId,
//     this.exerciseId,
//     this.selectedWeekDays,
//     this.programStartDate,
//     this.programEndDate,
//     this.gender,
//     this.workoutTitle,
//     this.workoutDescription,
//     this.workoutGoal,
//     this.workoutLevel,
//     this.workoutDuration,
//     this.workoutDurationData,
//     this.workoutStatus,
//     this.workoutImage,
//     this.workoutVideoType,
//     this.workoutVideo,
//     this.selectedDays,
//     this.status,
//     this.exerciseTitle,
//     this.exerciseReps,
//     this.exerciseSets,
//     this.exerciseRest,
//     this.exerciseEquipment,
//     this.exerciseLevel,
//     this.exerciseWeight,
//     this.exerciseTime,
//     this.exerciseDistance,
//     this.exerciseMeasurement,
//     this.exerciseImage,
//     this.exerciseVideoType,
//     this.exerciseVideo,
//     this.exerciseTips,
//     this.exerciseInstructions,
//     this.isFavorite,
//   });
//
//   String? id;
//   String? workoutId;
//   dynamic exerciseId;
//   String? selectedWeekDays;
//   String? programStartDate;
//   String? programEndDate;
//   String? gender;
//   dynamic workoutTitle;
//   dynamic workoutDescription;
//   dynamic workoutGoal;
//   dynamic workoutLevel;
//   dynamic workoutDuration;
//   List<dynamic>? workoutDurationData;
//   dynamic workoutStatus;
//   dynamic workoutImage;
//   String? workoutVideoType;
//   dynamic workoutVideo;
//   dynamic selectedDays;
//   String? status;
//   dynamic exerciseTitle;
//   dynamic exerciseReps;
//   dynamic exerciseSets;
//   dynamic exerciseRest;
//   dynamic exerciseEquipment;
//   dynamic exerciseLevel;
//   dynamic exerciseWeight;
//   dynamic exerciseTime;
//   dynamic exerciseDistance;
//   dynamic exerciseMeasurement;
//   dynamic exerciseImage;
//   dynamic exerciseVideoType;
//   dynamic exerciseVideo;
//   dynamic exerciseTips;
//   dynamic exerciseInstructions;
//   dynamic isFavorite;
//
//   factory ProgramSchedule.fromJson(Map<String, dynamic> json) =>
//       ProgramSchedule(
//         id: json["id"],
//         workoutId: json["workout_id"],
//         exerciseId: json["exercise_id"],
//         selectedWeekDays: json["selected_week_days"],
//         programStartDate: json["program_start_date"],
//         programEndDate: json["program_end_date"],
//         gender: json["gender"],
//         workoutTitle: json["workout_title"],
//         workoutDescription: json["workout_description"],
//         workoutGoal: json["workout_goal"],
//         workoutLevel: json["workout_level"],
//         workoutDuration: json["workout_duration"],
//         workoutDurationData: jsonDecode(json["workout_duration_data"]),
//         workoutStatus: json["workout_status"],
//         workoutImage: json["workout_image"],
//         workoutVideoType: json["workout_video_type"],
//         workoutVideo: json["workout_video"],
//         selectedDays: json["selected_days"],
//         status: json["status"],
//         exerciseTitle: json["exercise_title"],
//         exerciseReps: json["exercise_reps"],
//         exerciseSets: json["exercise_sets"],
//         exerciseRest: json["exercise_rest"],
//         exerciseEquipment: json["exercise_equipment"],
//         exerciseLevel: json["exercise_level"],
//         exerciseWeight: json["exercise_weight"],
//         exerciseTime: json["exercise_time"],
//         exerciseDistance: json["exercise_distance"],
//         exerciseMeasurement: json["exercise_measurement"],
//         exerciseImage: json["exercise_image"],
//         exerciseVideoType: json["exercise_video_type"],
//         exerciseVideo: json["exercise_video"],
//         exerciseTips: json["exercise_tips"],
//         exerciseInstructions: json["exercise_instructions"],
//         isFavorite: json["is_favorite"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "workout_id": workoutId,
//         "exercise_id": exerciseId,
//         "selected_week_days": selectedWeekDays,
//         "program_start_date": programStartDate,
//         "program_end_date": programEndDate,
//         "gender": gender,
//         "workout_title": workoutTitle,
//         "workout_description": workoutDescription,
//         "workout_goal": workoutGoal,
//         "workout_level": workoutLevel,
//         "workout_duration": workoutDuration,
//         "workout_duration_data": workoutDurationData,
//         "workout_status": workoutStatus,
//         "workout_image": workoutImage,
//         "workout_video_type": workoutVideoType,
//         "workout_video": workoutVideo,
//         "selected_days": selectedDays,
//         "status": status,
//         "exercise_title": exerciseTitle,
//         "exercise_reps": exerciseReps,
//         "exercise_sets": exerciseSets,
//         "exercise_rest": exerciseRest,
//         "exercise_equipment": exerciseEquipment,
//         "exercise_level": exerciseLevel,
//         "exercise_weight": exerciseWeight,
//         "exercise_time": exerciseTime,
//         "exercise_distance": exerciseDistance,
//         "exercise_measurement": exerciseMeasurement,
//         "exercise_image": exerciseImage,
//         "exercise_video_type": exerciseVideoType,
//         "exercise_video": exerciseVideo,
//         "exercise_tips": exerciseTips,
//         "exercise_instructions": exerciseInstructions,
//         "is_favorite": isFavorite,
//       };
// }

// To parse this JSON data, do
//
//     final scheduleByDateResponseModel = scheduleByDateResponseModelFromJson(jsonString);

import 'dart:convert';

ScheduleByDateResponseModel scheduleByDateResponseModelFromJson(String str) =>
    ScheduleByDateResponseModel.fromJson(json.decode(str));

String scheduleByDateResponseModelToJson(ScheduleByDateResponseModel data) =>
    json.encode(data.toJson());

class ScheduleByDateResponseModel {
  ScheduleByDateResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<Schedule>? data;

  factory ScheduleByDateResponseModel.fromJson(Map<String, dynamic> json) =>
      ScheduleByDateResponseModel(
        success: json["success"],
        msg: json["msg"],
        data:
            List<Schedule>.from(json["data"].map((x) => Schedule.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Schedule {
  Schedule({
    this.id,
    this.userProgramId,
    this.userId,
    this.date,
    this.programData,
  });

  String? id;
  String? userProgramId;
  String? userId;
  String? date;
  List<ProgramSchedule>? programData;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        id: json["id"],
        userProgramId: json["user_program_id"],
        userId: json["user_id"],
        date: json["date"],
        programData: List<ProgramSchedule>.from(
            json["program_data"].map((x) => ProgramSchedule.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_program_id": userProgramId,
        "user_id": userId,
        "date": date,
        "program_data": List<dynamic>.from(programData!.map((x) => x.toJson())),
      };
}

class ProgramSchedule {
  ProgramSchedule({
    this.id,
    this.workoutId,
    this.exerciseId,
    this.selectedWeekDays,
    this.programStartDate,
    this.programEndDate,
    this.gender,
    this.workoutTitle,
    this.workoutDescription,
    this.workoutGoal,
    this.workoutLevel,
    this.workoutDuration,
    this.workoutStatus,
    this.workoutImage,
    this.workoutVideoType,
    this.workoutVideo,
    this.selectedDays,
    this.status,
    this.exerciseTitle,
    this.exerciseReps,
    this.exerciseSets,
    this.exerciseRest,
    this.exerciseEquipment,
    this.exerciseLevel,
    this.exerciseType,
    this.exerciseWeight,
    this.exerciseTime,
    this.exerciseDistance,
    this.exerciseMeasurement,
    this.exerciseImage,
    this.exerciseVideoType,
    this.exerciseVideo,
    this.exerciseTips,
    this.exerciseInstructions,
    this.isFavorite,
  });

  String? id;
  String? workoutId;
  dynamic exerciseId;
  String? selectedWeekDays;
  String? programStartDate;
  String? programEndDate;
  String? gender;
  String? workoutTitle;
  String? workoutDescription;
  String? workoutGoal;
  String? workoutLevel;
  String? workoutDuration;
  String? workoutStatus;
  String? workoutImage;
  String? workoutVideoType;
  dynamic workoutVideo;
  String? selectedDays;
  String? status;
  dynamic exerciseTitle;
  dynamic exerciseReps;
  dynamic exerciseSets;
  dynamic exerciseRest;
  dynamic exerciseEquipment;
  dynamic exerciseLevel;
  dynamic exerciseType;
  dynamic exerciseWeight;
  dynamic exerciseTime;
  dynamic exerciseDistance;
  dynamic exerciseMeasurement;
  dynamic exerciseImage;
  dynamic exerciseVideoType;
  dynamic exerciseVideo;
  dynamic exerciseTips;
  dynamic exerciseInstructions;
  dynamic isFavorite;

  factory ProgramSchedule.fromJson(Map<String, dynamic> json) =>
      ProgramSchedule(
        id: json["id"],
        workoutId: json["workout_id"],
        exerciseId: json["exercise_id"],
        selectedWeekDays: json["selected_week_days"],
        programStartDate: json["program_start_date"],
        programEndDate: json["program_end_date"],
        gender: json["gender"],
        workoutTitle: json["workout_title"],
        workoutDescription: json["workout_description"],
        workoutGoal: json["workout_goal"],
        workoutLevel: json["workout_level"],
        workoutDuration: json["workout_duration"],
        workoutStatus: json["workout_status"],
        workoutImage: json["workout_image"],
        workoutVideoType: json["workout_video_type"],
        workoutVideo: json["workout_video"],
        selectedDays: json["selected_days"],
        status: json["status"],
        exerciseTitle: json["exercise_title"],
        exerciseReps: json["exercise_reps"],
        exerciseSets: json["exercise_sets"],
        exerciseRest: json["exercise_rest"],
        exerciseEquipment: json["exercise_equipment"],
        exerciseLevel: json["exercise_level"],
        exerciseType: json["exercise_type"],
        exerciseWeight: json["exercise_weight"],
        exerciseTime: json["exercise_time"],
        exerciseDistance: json["exercise_distance"],
        exerciseMeasurement: json["exercise_measurement"],
        exerciseImage: json["exercise_image"],
        exerciseVideoType: json["exercise_video_type"],
        exerciseVideo: json["exercise_video"],
        exerciseTips: json["exercise_tips"],
        exerciseInstructions: json["exercise_instructions"],
        isFavorite: json["is_favorite"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "workout_id": workoutId,
        "exercise_id": exerciseId,
        "selected_week_days": selectedWeekDays,
        "program_start_date": programStartDate,
        "program_end_date": programEndDate,
        "gender": gender,
        "workout_title": workoutTitle,
        "workout_description": workoutDescription,
        "workout_goal": workoutGoal,
        "workout_level": workoutLevel,
        "workout_duration": workoutDuration,
        "workout_status": workoutStatus,
        "workout_image": workoutImage,
        "workout_video_type": workoutVideoType,
        "workout_video": workoutVideo,
        "selected_days": selectedDays,
        "status": status,
        "exercise_title": exerciseTitle,
        "exercise_reps": exerciseReps,
        "exercise_sets": exerciseSets,
        "exercise_rest": exerciseRest,
        "exercise_equipment": exerciseEquipment,
        "exercise_level": exerciseLevel,
        "exercise_type": exerciseType,
        "exercise_weight": exerciseWeight,
        "exercise_time": exerciseTime,
        "exercise_distance": exerciseDistance,
        "exercise_measurement": exerciseMeasurement,
        "exercise_image": exerciseImage,
        "exercise_video_type": exerciseVideoType,
        "exercise_video": exerciseVideo,
        "exercise_tips": exerciseTips,
        "exercise_instructions": exerciseInstructions,
        "is_favorite": isFavorite,
      };
}
