import 'dart:developer';

import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/workout_response_model/user_workouts_date_response_model.dart';
import 'package:tcm/repo/workout_repo/user_workouts_date_repo.dart';

class UserWorkoutsDateViewModel extends GetxController {
  List exerciseId = [];
  List supersetExerciseId = [];
  int exeIdCounter = 0;
  bool isHold = false;
  bool isFirst = false;
  bool isGreaterOne = false;

  getExeId({int? counter}) {
    if (counter! < exerciseId.length) {
      exeIdCounter++;
    }
    update();
  }

  getBackId({int? counter}) {
    if (counter! > 0) {
      exeIdCounter--;
    }
    update();
  }

  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  Future<void> getUserWorkoutsDateDetails({
    String? date,
    String? userId,
  }) async {
    log('uid ==== $userId ------ date ========== $date ');
    if (_apiResponse.status == Status.INITIAL) {
      _apiResponse = ApiResponse.loading(message: 'Loading');
      update();
    }

    try {
      UserWorkoutsDateResponseModel response = await UserWorkoutsDateRepo()
          .userWorkoutsDateRepo(date: date, userId: userId);
      print('UserWorkoutsDateResponseModel=>$response');
      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("----- UserWorkoutsDateResponseModel === >$e");
      _apiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
