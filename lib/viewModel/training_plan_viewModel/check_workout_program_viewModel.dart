import 'dart:convert';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/training_plan_request_model/check_workout_program_request_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/check_workout_program_response_model.dart';
import 'package:tcm/repo/training_plan_repo/check_workout_program_repo.dart';

class CheckWorkoutProgramViewModel extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  late CheckWorkoutProgramResponseModel response;
  Future<void> checkWorkoutProgramViewModel(
      CheckWorkoutProgramRequestModel model) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    update();
    print("model ---------- ${jsonEncode(model.toJson())}");
    try {
      print('==CheckWorkoutProgramViewModel=>');
      response = await CheckWorkoutProgramRepo()
          .checkWorkoutProgramRepo(model.toJson());
      print('==CheckWorkoutProgramViewModel=>$response');

      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      _apiResponse = ApiResponse.error(message: e.toString());
      print("......... CheckWorkoutProgramViewModel ===== $e");
    }
    update();
  }
}
