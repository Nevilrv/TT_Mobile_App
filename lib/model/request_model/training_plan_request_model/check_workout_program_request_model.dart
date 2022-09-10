class CheckWorkoutProgramRequestModel {
  String? userId;
  String? workoutId;

  CheckWorkoutProgramRequestModel({this.userId, this.workoutId});

  CheckWorkoutProgramRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    workoutId = json['workout_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['workout_id'] = this.workoutId;
    return data;
  }
}
