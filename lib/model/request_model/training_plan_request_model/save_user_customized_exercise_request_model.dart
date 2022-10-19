class SaveUserCustomizedExerciseRequestModel {
  String? id;
  String? userId;
  String? exerciseId;
  String? repsData;
  String? weightData;
  String? exerciseType;

  SaveUserCustomizedExerciseRequestModel(
      {this.id,
      this.userId,
      this.exerciseId,
      this.repsData,
      this.weightData,
      this.exerciseType});

  SaveUserCustomizedExerciseRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    exerciseId = json['exercise_id'];
    repsData = json['reps_data'];
    weightData = json['weight_data'];
    exerciseType = json['exercise_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['exercise_id'] = this.exerciseId;
    data['reps_data'] = this.repsData;
    data['weight_data'] = this.weightData;
    data['exercise_type'] = this.exerciseType;
    return data;
  }
}
