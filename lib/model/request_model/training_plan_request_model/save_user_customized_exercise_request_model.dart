class SaveUserCustomizedExerciseRequestModel {
  String? userId;
  String? exerciseId;
  String? reps;
  String? isCompleted;

  SaveUserCustomizedExerciseRequestModel(
      {this.userId, this.exerciseId, this.reps, this.isCompleted});

  SaveUserCustomizedExerciseRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    exerciseId = json['exercise_id'];
    reps = json['reps'];
    isCompleted = json['is_completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['exercise_id'] = this.exerciseId;
    data['reps'] = this.reps;
    data['is_completed'] = this.isCompleted;
    return data;
  }
}
