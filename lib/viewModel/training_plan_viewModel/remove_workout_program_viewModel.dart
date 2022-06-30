import 'dart:convert';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/training_plan_request_model/remove_workout_program_request_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/remove_workout_program_response_model.dart';
import 'package:tcm/repo/training_plan_repo/remove_workout_program_repo.dart';

class RemoveWorkoutProgramViewModel extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  late RemoveWorkoutProgramResponseModel response;
  Future<void> removeWorkoutProgramViewModel(
      RemoveWorkoutProgramRequestModel model) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    update();
    print("model ---------- ${jsonEncode(model.toJson())}");
    try {
      print('==RemoveWorkoutProgram=>');
      response = await RemoveWorkoutProgramRepo()
          .removeWorkoutProgramRepo(model.toJson());
      print('==RemoveWorkoutProgram=>$response');

      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      _apiResponse = ApiResponse.error(message: e.toString());
      print("......... RemoveWorkoutProgram ===== $e");
    }
    update();
  }
}
