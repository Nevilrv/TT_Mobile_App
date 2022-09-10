import 'dart:developer';

import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/training_plans_response_model/workout_by_filter_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/repo/training_plan_repo/workout_by_filter_repo.dart';

class WorkoutByFilterViewModel extends GetxController {
  String? goal;
  String? duration;
  String? gender;

  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  Future<void> getWorkoutByFilterDetails(
      {String? goal,
      String? duration,
      String? gender,
      String? userId,
      bool isLoading = false}) async {
    log('duration ==========  $duration -- goal === $goal -- gender ======= $gender ------ uid ==== $userId');
    if (isLoading) {
      _apiResponse = ApiResponse.loading(message: 'Loading');
    }
    // update();
    try {
      WorkoutByFilterResponseModel response = await WorkoutByFilterRepo()
          .workoutByFilterRepo(
              goal: goal ?? '1',
              duration: duration ?? '3',
              gender: gender ?? 'male',
              userId: userId);
      print('WorkoutByFilterResponseModel=>$response');
      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("----- WorkoutByFilterResponseModel === >$e");
      _apiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
