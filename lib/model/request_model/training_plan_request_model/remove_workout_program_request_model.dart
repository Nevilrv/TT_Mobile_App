class RemoveWorkoutProgramRequestModel {
  String? userWorkoutProgramId;

  RemoveWorkoutProgramRequestModel({this.userWorkoutProgramId});

  RemoveWorkoutProgramRequestModel.fromJson(Map<String, dynamic> json) {
    userWorkoutProgramId = json['user_workout_program_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_workout_program_id'] = this.userWorkoutProgramId;
    return data;
  }
}
