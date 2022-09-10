import 'dart:convert';

DaysResponseModel DaysResponseModelFromJson(String str) =>
    DaysResponseModel.fromJson(json.decode(str));

String DaysResponseModelToJson(DaysResponseModel data) =>
    json.encode(data.toJson());

class DaysResponseModel {
  DaysResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<Days>? data;

  factory DaysResponseModel.fromJson(Map<String, dynamic> json) =>
      DaysResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: List<Days>.from(json["data"].map((x) => Days.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Days {
  Days({
    this.workoutId,
    this.day,
    this.exerciseTitle,
    this.exerciseReps,
    this.exerciseLevel,
    this.exerciseSets,
    this.exerciseRest,
    this.exerciseImage,
    this.exerciseVideo,
    this.exerciseId,
    this.exerciseTips,
    this.exerciseInstructions,
    this.equipmentTitle,
    this.levelTitle,
  });

  String? workoutId;
  String? day;
  String? exerciseTitle;
  String? exerciseReps;
  String? exerciseLevel;
  String? exerciseSets;
  ExerciseRest? exerciseRest;
  String? exerciseImage;
  String? exerciseVideo;
  String? exerciseId;
  String? exerciseTips;
  String? exerciseInstructions;
  EquipmentTitle? equipmentTitle;
  LevelTitle? levelTitle;

  factory Days.fromJson(Map<String, dynamic> json) => Days(
        workoutId: json["workout_id"],
        day: json["day"],
        exerciseTitle: json["exercise_title"],
        exerciseReps: json["exercise_reps"],
        exerciseLevel: json["exercise_level"],
        exerciseSets: json["exercise_sets"],
        exerciseRest: exerciseRestValues.map![json["exercise_rest"]],
        exerciseImage: json["exercise_image"],
        exerciseVideo: json["exercise_video"],
        exerciseId: json["exercise_id"],
        exerciseTips: json["exercise_tips"],
        exerciseInstructions: json["exercise_instructions"],
        equipmentTitle: equipmentTitleValues.map![json["equipment_title"]],
        levelTitle: levelTitleValues.map![json["level_title"]],
      );

  Map<String, dynamic> toJson() => {
        "workout_id": workoutId,
        "day": day,
        "exercise_title": exerciseTitle,
        "exercise_reps": exerciseReps,
        "exercise_level": exerciseLevel,
        "exercise_sets": exerciseSets,
        "exercise_rest": exerciseRestValues.reverse[exerciseRest],
        "exercise_image": exerciseImage,
        "exercise_video": exerciseVideo,
        "exercise_id": exerciseId,
        "exercise_tips": exerciseTips,
        "exercise_instructions": exerciseInstructions,
        "equipment_title": equipmentTitleValues.reverse[equipmentTitle],
        "level_title": levelTitleValues.reverse[levelTitle],
      };
}

enum EquipmentTitle {
  NO_EQUIPMENT,
  KETTLEBELLS,
  DUMBBELLS,
  BARBELL,
  MEDICINE_BALL,
  PULL_UP_BAR
}

final equipmentTitleValues = EnumValues({
  "Barbell": EquipmentTitle.BARBELL,
  "Dumbbells": EquipmentTitle.DUMBBELLS,
  "Kettlebells": EquipmentTitle.KETTLEBELLS,
  "Medicine Ball": EquipmentTitle.MEDICINE_BALL,
  "No Equipment": EquipmentTitle.NO_EQUIPMENT,
  "Pull-up Bar": EquipmentTitle.PULL_UP_BAR
});

enum ExerciseRest { THE_30_SEC, THE_1_MIN, THE_45_SEC }

final exerciseRestValues = EnumValues({
  "1 Min": ExerciseRest.THE_1_MIN,
  "30 Sec": ExerciseRest.THE_30_SEC,
  "45 Sec": ExerciseRest.THE_45_SEC
});

enum LevelTitle { BEGINNER, INTERMEDIATE, ADVANCED, ELITE }

final levelTitleValues = EnumValues({
  "Advanced": LevelTitle.ADVANCED,
  "Beginner": LevelTitle.BEGINNER,
  "Elite": LevelTitle.ELITE,
  "Intermediate": LevelTitle.INTERMEDIATE
});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
