import 'dart:developer';

import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/training_plans_response_model/workout_by_filter_response_model.dart';
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
      bool isLoding = false}) async {
    log('duration ==========  $duration -- goal === $goal -- gender ======= $gender');
    if (isLoding) {
      _apiResponse = ApiResponse.loading(message: 'Loading');
    }
    // update();
    try {
      WorkoutByFilterResponseModel response = await WorkoutByFilterRepo()
          .workoutByFilterRepo(
              goal: goal ?? '1',
              duration: duration ?? '3',
              gender: gender ?? 'male');
      print('WorkoutByFilterResponseModel=>$response');
      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("----- WorkoutByFilterResponseModel === >$e");
      _apiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
