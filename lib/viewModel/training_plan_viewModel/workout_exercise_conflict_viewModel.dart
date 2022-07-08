import 'dart:developer';

import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/training_plans_response_model/workout_exercise_conflict_response_model.dart';
import 'package:tcm/repo/training_plan_repo/workout_exercise_conflict_repo.dart';

class WorkoutExerciseConflictViewModel extends GetxController {
  String? date;
  //
  // @override
  // onInit() {
  //   getWorkoutExerciseConflictDetails();
  //
  //   super.onInit();
  // }

  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  Future<void> getWorkoutExerciseConflictDetails(
      {String? date, String? userId, bool isLoading = false}) async {
    log('date ==========  $date ------------ $userId');

    if (isLoading) {
      _apiResponse = ApiResponse.loading(message: 'Loading');
    }
    update();
    try {
      WorkoutExerciseConflictResponseModel response =
          await WorkoutExerciseConflictRepo()
              .workoutExerciseConflictRepo(date: date, userId: userId);
      print('the response =>$response');
      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("----- 123123123 === >$e");
      _apiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
