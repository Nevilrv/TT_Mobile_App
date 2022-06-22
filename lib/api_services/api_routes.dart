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

  String experienceUrl = baseUrl + "/json/data_experience_levels.php";
  String editPassUrl = baseUrl + "/json/data_change_password.php";
  String editProfileUrl = baseUrl + "/json/data_user_profile_update.php";

  String saveWorkoutProgramUrl =
      baseUrl + "/json/data_save_workout_exercise.php";

  String userDetailUrl = baseUrl + "/json/data_users.php?user_id=";

  static const String getCategories = baseUrl + "/json/data_categories.php";

  static const String getBodyParts = baseUrl + "/json/data_bodyparts.php";

  String registerUrl = baseUrl + "/json/data_register.php";
  String habitTrackerUrl = baseUrl + "/json/data_habits.php";
  String allWorkoutsUrl =
      baseUrl + "/json/data_workouts.php?goal=&level=&workout=";

  String exerciseByIdUrl = baseUrl + "/json/data_exercises.php?exercise=";
  String signInUrl = baseUrl + "/json/data_login.php";
  String dayBaseWorkoutUrl = baseUrl + "/json/data_days.php?day=";

  String workoutByFilterUrl = baseUrl + "/json/data_workout_filter.php?goal=";
  String workoutByID = baseUrl + "/json/data_single_workout.php?workout_id=";

  String dayOneUrl = baseUrl + "/json/data_day1.php";
  String dayTwoUrl = baseUrl + "/json/data_day2.php";
  String dayThreeUrl = baseUrl + "/json/data_day3.php";
  String dayFourUrl = baseUrl + "/json/data_day4.php";
  String dayFiveUrl = baseUrl + "/json/data_day5.php";
  String daySixUrl = baseUrl + "/json/data_day6.php";
  String daySevenUrl = baseUrl + "/json/data_day7.php";
}
