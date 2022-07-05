class ApiRoutes {
  static const String baseUrl = "https://tcm.sataware.dev/";

  /// other urls

  static const String getVideoes =
      baseUrl + "/json/data_videos.php?video_id=&category_id=";

  static const String getVideoesById =
      baseUrl + "/json/data_videos.php?video_id=";
  String videoLikeUrl = baseUrl + "/json/data_video_like.php";
  String videoDislikeUrl = baseUrl + "/json/data_video_dislike.php";
  String videoViewsUrl = baseUrl + "/json/data_visit.php";
  String goalUrl = baseUrl + "/json/data_goals.php";
  String saveUserCustomizedExerciseUrl =
      baseUrl + "/json/data_save_user_customized_exercise.php";
  String workoutExerciseConflictUrl =
      baseUrl + "/json/data_check_workout_exercise_conflict.php?date=";
  String removeWorkoutProgramUrl =
      baseUrl + "/json/data_remove_existed_workout_program.php";

  String experienceUrl = baseUrl + "/json/data_experience_levels.php";
  String editPassUrl = baseUrl + "/json/data_change_password.php";
  String editProfileUrl = baseUrl + "/json/data_user_profile_update.php";

  String saveWorkoutProgramUrl =
      baseUrl + "/json/data_save_workout_exercise.php";

  String userDetailUrl = baseUrl + "/json/data_users.php?user_id=";
  String scheduleByDateUrl =
      baseUrl + "/json/data_user_schedules_dates.php?user_id=";

  static const String getCategories = baseUrl + "/json/data_categories.php";

  static const String getBodyParts = baseUrl + "/json/data_bodyparts.php";

  String registerUrl = baseUrl + "/json/data_register.php";
  String habitTrackerUrl = baseUrl + "/json/data_habits.php?user_id=";
  String customHabitUrl = baseUrl + "/json/data_habits_add.php";
  String userHabitTrackUrl = baseUrl + "/json/data_habit_user.php";
  String habitRecordAddUpdateUrl = baseUrl + "/json/data_habit_record.php";
  String getHabitRecordurl = baseUrl + "/json/data_habit_record_get_date.php";
  String allWorkoutsUrl =
      baseUrl + "/json/data_workouts.php?goal=&level=&workout=";

  String exerciseByIdUrl = baseUrl + "/json/data_exercises.php?exercise=";
  String signInUrl = baseUrl + "/json/data_login.php";
  String dayBaseWorkoutUrl = baseUrl + "/json/data_days.php?day=";

  String workoutByFilterUrl = baseUrl + "/json/data_workout_filter.php?goal=";
  String workoutByID = baseUrl + "/json/data_single_workout.php?workout_id=";
}
