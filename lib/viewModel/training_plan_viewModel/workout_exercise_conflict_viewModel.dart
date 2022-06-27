import 'dart:developer';

import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/training_plans_response_model/workout_exercise_conflict_response_model.dart';
import 'package:tcm/repo/training_plan_repo/workout_exercise_conflict_repo.dart';

class WorkoutExerciseConflictViewModel extends GetxController {
  String? date;

  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  Future<void> getWorkoutExerciseConflictDetails({String? date}) async {
    log('date ==========  $date');
    _apiResponse = ApiResponse.loading(message: 'Loading');
    // update();
    try {
      WorkoutExerciseConflictResponseModel response =
          await WorkoutExerciseConflictRepo()
              .workoutExerciseConflictRepo(date: date);
      print('WorkoutByFilterResponseModel=>$response');
      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("----- WorkoutByFilterResponseModel === >$e");
      _apiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
