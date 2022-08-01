class SaveWorkoutProgramRequestModel {
  String? userId;
  String? workoutId;
  String? exerciseId;
  // List<String>? selectedWeekDays;
  String? selectedWeekDays;
  String? startDate;
  String? endDate;
  String? selectedDates;
  String? workoutProgramId;
  // List<String>? selectedDates;

  SaveWorkoutProgramRequestModel(
      {this.userId,
      this.workoutId,
      this.exerciseId,
      this.selectedWeekDays,
      this.startDate,
      this.endDate,
      this.selectedDates,
      this.workoutProgramId});

  SaveWorkoutProgramRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    workoutId = json['workout_id'];
    exerciseId = json['exercise_id'];
    selectedWeekDays = json['selected_week_days'];
    // selectedWeekDays = json['selected_week_days'].cast<String>();
    startDate = json['start_date'];
    endDate = json['end_date'];
    selectedDates = json['selected_dates'];
    workoutProgramId = json['workout_program_id'] ?? '';
    // selectedDates = json['selected_dates'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['workout_id'] = this.workoutId;
    data['exercise_id'] = this.exerciseId;
    data['selected_week_days'] = this.selectedWeekDays;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['selected_dates'] = this.selectedDates;
    data['workout_program_id'] = this.workoutProgramId ?? '';
    return data;
  }
}
